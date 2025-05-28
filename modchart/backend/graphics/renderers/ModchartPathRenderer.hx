package modchart.backend.graphics.renderers;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxDestroyUtil;

@:structInit
@:publicFields
private final class PathSegment {
	var alpha:Float;
	var scale:Float;
	var color:Int;
	var pos:Vector3;
}

var pathVector = new Vector3();

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
final class ModchartPathRenderer extends ModchartRenderer<FlxSprite> {
	var __lineGraphic:FlxGraphic;
	var __lastDivisions:Int = -1;

	var uvt:DrawData<Float>;
	var indices:DrawData<Int>;

	public function updateTris(divisions:Int) {
		final segs = divisions - 1;
		if (divisions != __lastDivisions) {
			uvt = new DrawData<Float>(segs * 12, true);
			indices = new DrawData<Int>(segs * 6, true);
			var ui = 0, ii = 0, vertCount = 0;
			for (div in 0...divisions) {
				for (_ in 0...4) {
					uvt.set(ui++, 0);
					uvt.set(ui++, 0);
					uvt.set(ui++, 1);
				}

				// indices
				indices.set(ii++, vertCount);
				indices.set(ii++, vertCount + 1);
				indices.set(ii++, vertCount + 2);
				indices.set(ii++, vertCount + 1);
				indices.set(ii++, vertCount + 3);
				indices.set(ii++, vertCount + 2);

				vertCount += 4;
			}
		}

		__lastDivisions = divisions;
	}

	public function new(instance:PlayField) {
		super(instance);

		__lineGraphic = FlxG.bitmap.create(10, 10, 0xFFFFFFFF);
	}

	// the entry sprite should be A RECEPTOR / STRUM !!
	override public function prepare(item:FlxSprite) {
		final lane = Adapter.instance.getLaneFromArrow(item);
		final fn = Adapter.instance.getPlayerFromArrow(item);

		final alpha = instance.getPercent('arrowPathAlpha', fn);
		final thickness = instance.getPercent('arrowPathThickness', fn);

		if (alpha <= 0 || thickness <= 0)
			return;

		final divisions = Std.int(20 * Config.ARROW_PATHS_CONFIG.RESOLUTION);
		final limit = 1500 + Config.ARROW_PATHS_CONFIG.LENGTH;
		final interval = limit / divisions;
		final songPos = Adapter.instance.getSongPosition();

		final segs = divisions - 1;
		final vertices = new DrawData<Float>(segs * 8, true);

		var vi = 0, vertCount = 0;

		var lastSegment:PathSegment = null;
		pathVector.setTo(Adapter.instance.getDefaultReceptorX(lane, fn), Adapter.instance.getDefaultReceptorY(lane, fn), 0);
		pathVector.incrementBy(ModchartUtil.getHalfPos());

		for (index in 0...divisions) {
			var hitTime = -500 + interval * index;

			var output = instance.modifiers.getPath(pathVector.clone(), {
				hitTime: songPos + hitTime,
				distance: hitTime,
				lane: lane,
				player: fn,
				isTapArrow: true
			});

			final segment:PathSegment = {
				pos: output.pos,
				alpha: alpha,
				scale: thickness,
				color: 0xFFFFFF
			};

			if (Config.ARROW_PATHS_CONFIG.COLORED)
				segment.alpha *= output.visuals.alpha;

			if (Config.ARROW_PATHS_CONFIG.APPLY_SCALE)
				segment.scale *= output.visuals.scaleX;

			if (Config.ARROW_PATHS_CONFIG.APPLY_DEPTH)
				segment.scale *= 1 / (output.pos.z * 2);

			if (lastSegment != null) {
				final p0 = lastSegment;
				final p1 = segment;

				final pos0 = p0.pos;
				final pos1 = p1.pos;

				final dx = pos1.x - pos0.x;
				final dy = pos1.y - pos0.y;
				final len = Math.sqrt(dx * dx + dy * dy);
				final nx = -dy / len;
				final ny = dx / len;

				final t0 = p0.scale * 0.5;
				final t1 = p1.scale * 0.5;

				final a1x = pos0.x + nx * t0;
				final a1y = pos0.y + ny * t0;
				final a2x = pos0.x - nx * t0;
				final a2y = pos0.y - ny * t0;

				final b1x = pos1.x + nx * t1;
				final b1y = pos1.y + ny * t1;
				final b2x = pos1.x - nx * t1;
				final b2y = pos1.y - ny * t1;

				// vertices
				vertices.set(vi++, a1x);
				vertices.set(vi++, a1y);
				vertices.set(vi++, a2x);
				vertices.set(vi++, a2y);
				vertices.set(vi++, b1x);
				vertices.set(vi++, b1y);
				vertices.set(vi++, b2x);
				vertices.set(vi++, b2y);

				vertCount += 4;
			}

			lastSegment = segment;
		}

		updateTris(divisions);

		var newInstruction:FMDrawInstruction = {};
		newInstruction.extra = [vertices, indices, uvt];
		queue[count++] = newInstruction;
	}

	override public function shift() {
		if (queue.length <= 0)
			return;

		final cameras = Adapter.instance.getArrowCamera();
		for (instruction in queue) {
			final vertices:DrawData<Float> = cast instruction.extra[0];
			final indices:DrawData<Int> = cast instruction.extra[1];
			final uvt:DrawData<Float> = cast instruction.extra[2];

			for (camera in cameras) {
				camera.drawTriangles(__lineGraphic, vertices, indices, uvt, new DrawData<Int>(), null, null, false, true, null, null);
			}
		}
	}

	override function dispose() {
		__lineGraphic = FlxDestroyUtil.destroy(__lineGraphic);
	}

	inline static final ARROW_PATH_BOUNDARY_OFFSET:Float = 300;
}
