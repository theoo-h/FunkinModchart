package modchart.core.graphics;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.Vector;
import openfl.Vector;
import openfl.display.GraphicsPathCommand;
import openfl.display.Shape;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Vector3D;

var rotationVector = new Vector3D();
var helperVector = new Vector3D();
var __matrix:Matrix = new Matrix();
var pathVector = new Vector3D();

class ModchartRenderer<T:FlxBasic> extends FlxBasic {
	private var instance:Null<PlayField>;
	private var queue:Array<FMDrawInstruction>;
	private var count:Int = 0;

	public function new(instance:PlayField) {
		super();

		this.instance = instance;
	}

	// Renderer-side
	public function prepare(item:T) {}

	public function shift():Void {}

	public function dispose() {}

	// Built-in functions
	public function preallocate(length:Int) {
		queue = [];
		count = 0;
		queue.resize(length);
	}

	// public function render(times:Null<Int>):Void {}
}

class ModchartHoldRenderer extends ModchartRenderer<FlxSprite> {
	private var __lastHoldSubs:Int = -1;

	var _indices:Null<Vector<Int>> = new Vector<Int>();

	/**
	 * Returns the normal points along the hold path at specific hitTime.
	 *
	 * Based on schmovin' hold system
	 * @param basePos The hold position per default
	 */
	@:noCompletion
	private function getHoldSegment(hold:FlxSprite, basePos:Vector3D, params:ArrowData):Array<Dynamic> {
		if (instance == null)
			return [];
		// rotated hold shit
		final holdRotateX = instance.getPercent('holdAngleX', params.player);
		final holdRotateY = instance.getPercent('holdAngleY', params.player);
		final holdRotateZ = instance.getPercent('holdAngleZ', params.player);

		final output1 = instance.modifiers.getPath(basePos.clone(), params);
		final output2 = instance.modifiers.getPath(basePos.clone(), params, 1);

		var curPoint = output1.pos;
		var nextPoint = output2.pos;

		/*
			// rotation from parent arrow
			if (holdRotateX != 0 || holdRotateY != 0 || holdRotateZ != 0)
			{
				final parentTime = Adapter.instance.getHoldParentTime(hold);
				final parentOutput = instance.modifiers.getPath(basePos.clone(), {
					hitTime: parentTime,
					distance: parentTime - Adapter.instance.getSongPosition(),
					lane: params.lane,
					player: params.player,
					arrow: true
				});

				for (point in [curPoint, nextPoint])
				{
					var subQuad = point.subtract(parentOutput.pos.clone());
					var subRotation = ModchartUtil.rotate3DVector(subQuad.clone(), holdRotateX, holdRotateY, holdRotateZ);
					subRotation.z *= 0.001;
					var subPerspective = ModchartUtil.project(subRotation.add(parentOutput.pos.clone()), new Vector3D());	
				}
		}*/

		var zScale:Float = curPoint.z != 0 ? (1 / curPoint.z) : 1;
		curPoint.z = nextPoint.z = 0;

		// normalized points difference (from 0-1)
		var unit = nextPoint.subtract(curPoint);
		unit.normalize();

		var size = hold.frame.frame.width * hold.scale.x * .5;

		var quad0 = new Vector3D(-unit.y * size, unit.x * size);
		var quad1 = new Vector3D(unit.y * size, -unit.x * size);
		@:privateAccess
		for (i in 0...2) {
			var visuals = switch (i) {
				case 0: output1.visuals;
				case 1: output2.visuals;
				default: null;
			}
			var quad = switch (i) {
				case 0: quad0;
				case 1: quad1;
				default: null;
			}
			var rotation = ModchartUtil.rotate3DVector(quad, visuals.angleX * instance.getPercent('rotateHoldX', params.player),
				visuals.angleY * instance.getPercent('rotateHoldY', params.player), visuals.angleZ * instance.getPercent('rotateHoldZ', params.player));

			if (visuals.skewX != 0 || visuals.skewY != 0) {
				__matrix.b = ModchartUtil.tan(visuals.skewY * FlxAngle.TO_RAD);
				__matrix.c = ModchartUtil.tan(visuals.skewX * FlxAngle.TO_RAD);

				rotation.x = __matrix.__transformX(rotation.x, rotation.y);
				rotation.y = __matrix.__transformY(rotation.x, rotation.y);

				__matrix.identity();
			}
			rotation.x = rotation.x * zScale * visuals.scaleX;
			rotation.y = rotation.y * zScale * visuals.scaleY;

			var view = new Vector3D(rotation.x + curPoint.x, rotation.y + curPoint.y, rotation.z);
			if (Config.CAMERA3D_ENABLED)
				view = instance.camera3D.applyViewTo(view);
			view.z *= 0.001;

			// The result of the perspective projection of rotation
			final projection = ModchartUtil.project(view);

			quad.x = projection.x;
			quad.y = projection.y;
			quad.z = projection.z;
		}
		return [
			[quad0, quad1, curPoint.add(new Vector3D(0, 0, 1 + (1 - zScale) * 0.001))],
			output1.visuals
		];
	}

	@:noCompletion
	private function updateIndices() {
		final HOLD_SUBDIVISIONS = Adapter.instance.getHoldSubdivisions();

		_indices.length = (HOLD_SUBDIVISIONS * 6);
		for (sub in 0...HOLD_SUBDIVISIONS) {
			var vert = sub * 4;
			var count = sub * 6;

			_indices[count] = _indices[count + 3] = vert;
			_indices[count + 2] = _indices[count + 5] = vert + 3;
			_indices[count + 1] = vert + 1;
			_indices[count + 4] = vert + 2;
		}
	}

	override public function prepare(item:FlxSprite):Void {
		final arrow:FlxSprite = item;
		final newInstruction:FMDrawInstruction = {};
		final HOLD_SUBDIVISIONS = Adapter.instance.getHoldSubdivisions();

		if (__lastHoldSubs != HOLD_SUBDIVISIONS)
			updateIndices();

		if (__lastHoldSubs == -1)
			__lastHoldSubs = Adapter.instance.getHoldSubdivisions();

		var player = Adapter.instance.getPlayerFromArrow(item);
		var lane = Adapter.instance.getLaneFromArrow(item);

		var basePos = new Vector3D(Adapter.instance.getDefaultReceptorX(lane, player),
			Adapter.instance.getDefaultReceptorY(lane, player)).add(ModchartUtil.getHalfPos());

		var vertices:Array<Float> = [];
		var transfTotal:Array<ColorTransform> = [];
		transfTotal.resize(HOLD_SUBDIVISIONS);

		var tID = 0;

		var lastVis:Visuals = null;
		var lastQuad:Array<Vector3D> = null;
		var lastData:ArrowData = null;

		var depth:Float = Math.NaN;

		var alphaTotal:Single = 0.;

		Manager.HOLD_SIZE = arrow.width;
		Manager.HOLD_SIZEDIV2 = arrow.width * .5;

		var subCr = ((Adapter.instance.getStaticCrochet() * .25) * ((Adapter.instance.isHoldEnd(item)) ? 0.6 : 1)) / HOLD_SUBDIVISIONS;
		for (sub in 0...HOLD_SUBDIVISIONS) {
			var subOff = subCr * sub;

			var out1:Array<Dynamic> = [lastQuad, lastVis];
			if (lastQuad == null)
				out1 = getHoldSegment(item, basePos, lastData != null ? lastData : getArrowParams(arrow, subOff));
			var out2 = getHoldSegment(item, basePos, (lastData = getArrowParams(arrow, subOff + subCr)));

			var topQuads:Array<Vector3D> = out1[0];
			var topVisuals:Visuals = out1[1];

			var bottomQuads:Array<Vector3D> = out2[0];
			var bottomVisuals:Visuals = out2[1];

			vertices = vertices.concat(ModchartUtil.buildHoldVertices(topQuads, bottomQuads));

			lastVis = bottomVisuals;
			lastQuad = bottomQuads;

			if (Math.isNaN(depth))
				depth = topQuads[2].z * 1000;

			alphaTotal = alphaTotal + topVisuals.alpha;

			final negGlow = 1 - topVisuals.glow;
			final absGlow = topVisuals.glow * 255;
			transfTotal[tID++] = new ColorTransform(negGlow, negGlow, negGlow, topVisuals.alpha * arrow.alpha, Math.round(topVisuals.glowR * absGlow),
				Math.round(topVisuals.glowG * absGlow), Math.round(topVisuals.glowB * absGlow));
		}

		arrow._z = depth;

		newInstruction.item = item;
		newInstruction.vertices = new openfl.Vector<Float>(vertices.length, true, vertices);
		newInstruction.indices = _indices.copy();
		newInstruction.uvt = ModchartUtil.getHoldUVT(arrow, HOLD_SUBDIVISIONS);
		newInstruction.colorData = transfTotal;
		newInstruction.extra = [alphaTotal];

		queue[count] = newInstruction;
		count++;

		__lastHoldSubs = Adapter.instance.getHoldSubdivisions();
	}

	override public function shift() {
		__drawInstruction(queue.shift());
	}

	private function __drawInstruction(instruction:FMDrawInstruction) {
		if (cast(instruction.extra[0], Float) <= 0)
			return;

		final item:FlxSprite = instruction.item;

		var cameras = item._cameras != null ? item._cameras : Adapter.instance.getArrowCamera();

		@:privateAccess for (camera in cameras) {
			var cTransforms = instruction.colorData.copy();

			for (t in cTransforms)
				t.alphaMultiplier *= camera.alpha;

			var item = camera.startTrianglesBatch(item.graphic, item.antialiasing, true, item.blend, true, item.shader);
			item.addGradientTriangles(instruction.vertices, instruction.indices, instruction.uvt, new openfl.Vector<Int>(), null, camera._bounds, cTransforms);
		}
	}

	private function getArrowParams(arrow:FlxSprite, posOff:Float = 0):ArrowData {
		final player = Adapter.instance.getPlayerFromArrow(arrow);
		final lane = Adapter.instance.getLaneFromArrow(arrow);

		final centered2 = instance.getPercent('centered2', player);
		final timeC2 = flixel.FlxG.height * 0.25 * centered2;
		final hitTime = Adapter.instance.getTimeFromArrow(arrow);

		var pos = (hitTime - Adapter.instance.getSongPosition()) + posOff;

		// clip rect
		if (Adapter.instance.arrowHit(arrow) && pos < 0)
			pos = 0;

		pos += timeC2;

		return {
			hitTime: hitTime + posOff + timeC2,
			distance: pos,
			lane: lane,
			player: player,
			isTapArrow: true
		};
	}
}

class ModchartArrowRenderer extends ModchartRenderer<FlxSprite> {
	inline private function getGraphicVertices(planeWidth:Float, planeHeight:Float, flipX:Bool, flipY:Bool) {
		var x1 = flipX ? planeWidth : -planeWidth;
		var x2 = flipX ? -planeWidth : planeWidth;
		var y1 = flipY ? planeHeight : -planeHeight;
		var y2 = flipY ? -planeHeight : planeHeight;

		return [
			// top left
			x1,
			y1,
			// top right
			x2,
			y1,
			// bottom left
			x1,
			y2,
			// bottom right
			x2,
			y2
		];
	}

	override public function prepare(arrow:FlxSprite) {
		final arrowPosition = helperVector;

		final player = Adapter.instance.getPlayerFromArrow(arrow);

		// setup the position
		var arrowTime = Adapter.instance.getTimeFromArrow(arrow);
		var songPos = Adapter.instance.getSongPosition();
		var arrowDiff = arrowTime - songPos;

		// apply centered 2 (aka centered path)
		if (Adapter.instance.isTapNote(arrow)) {
			arrowDiff += FlxG.height * 0.25 * instance.getPercent('centered2', player);
		} else {
			arrowTime = songPos + (FlxG.height * 0.25 * instance.getPercent('centered2', player));
			arrowDiff = arrowTime - songPos;
		}
		var arrowData:ArrowData = {
			hitTime: arrowTime,
			distance: arrowDiff,
			lane: Adapter.instance.getLaneFromArrow(arrow),
			player: player,
			isTapArrow: Adapter.instance.isTapNote(arrow)
		};

		arrowPosition.setTo(Adapter.instance.getDefaultReceptorX(arrowData.lane, arrowData.player) + Manager.ARROW_SIZEDIV2,
			Adapter.instance.getDefaultReceptorY(arrowData.lane, arrowData.player) + Manager.ARROW_SIZEDIV2, 0);

		final output = instance.modifiers.getPath(arrowPosition, arrowData);
		arrowPosition.copyFrom(output.pos.clone());

		arrow._z = arrowPosition.z * 1000;

		// internal mods
		final orient = instance.getPercent('orient', arrowData.player);
		if (orient != 0) {
			final nextOutput = instance.modifiers.getPath(new Vector3D(Adapter.instance.getDefaultReceptorX(arrowData.lane, arrowData.player)
				+ Manager.ARROW_SIZEDIV2,
				Adapter.instance.getDefaultReceptorY(arrowData.lane, arrowData.player)
				+ Manager.ARROW_SIZEDIV2),
				arrowData, 1);
			final thisPos = output.pos;
			final nextPos = nextOutput.pos;

			output.visuals.angleZ += FlxAngle.wrapAngle((-90 + (Math.atan2(nextPos.y - thisPos.y, nextPos.x - thisPos.x) * FlxAngle.TO_DEG)) * orient);
		}

		// prepare the instruction for drawing
		final projectionDepth = arrowPosition.z;
		final depth = projectionDepth;

		var depthScale = 1 / depth;
		var planeWidth = arrow.frame.frame.width * arrow.scale.x * .5;
		var planeHeight = arrow.frame.frame.height * arrow.scale.y * .5;

		var planeVertices = getGraphicVertices(planeWidth, planeHeight, arrow.flipX, arrow.flipY);
		var projectionZ:haxe.ds.Vector<Float> = new haxe.ds.Vector(Math.ceil(planeVertices.length / 2));

		var vertPointer = 0;
		@:privateAccess do {
			rotationVector.setTo(planeVertices[vertPointer], planeVertices[vertPointer + 1], 0);

			// The result of the vert rotation
			var rotation = ModchartUtil.rotate3DVector(rotationVector, output.visuals.angleX, output.visuals.angleY, output.visuals.angleZ);

			// apply skewness
			if (output.visuals.skewX != 0 || output.visuals.skewY != 0) {
				__matrix.identity();

				__matrix.b = ModchartUtil.tan(output.visuals.skewY * FlxAngle.TO_RAD);
				__matrix.c = ModchartUtil.tan(output.visuals.skewX * FlxAngle.TO_RAD);

				rotation.x = __matrix.__transformX(rotation.x, rotation.y);
				rotation.y = __matrix.__transformY(rotation.x, rotation.y);
			}
			rotation.x = rotation.x * depthScale * output.visuals.scaleX;
			rotation.y = rotation.y * depthScale * output.visuals.scaleY;

			var view = new Vector3D(rotation.x + arrowPosition.x, rotation.y + arrowPosition.y, rotation.z);
			if (Config.CAMERA3D_ENABLED)
				view = instance.camera3D.applyViewTo(view);
			view.z *= 0.001;

			// The result of the perspective projection of rotation
			final projection = ModchartUtil.project(view);

			planeVertices[vertPointer] = projection.x;
			planeVertices[vertPointer + 1] = projection.y;

			// stores depth from this vert to use it for perspective correction on uv's
			projectionZ[Math.floor(vertPointer / 2)] = Math.max(0.0001, projection.z);

			vertPointer = vertPointer + 2;
		} while (vertPointer < planeVertices.length);

        // @formatter:off
		// this is confusing af
		var vertices = new DrawData<Float>(12, true, [
			// triangle 1
			planeVertices[0], planeVertices[1], // top left
			planeVertices[2], planeVertices[3], // top right
			planeVertices[6], planeVertices[7], // bottom left
			// triangle 2
			planeVertices[0], planeVertices[1], // top right
			planeVertices[4], planeVertices[5], // top left
			planeVertices[6], planeVertices[7] // bottom right
		]);
		final uvRectangle = arrow.frame.uv;
		var uvData = new DrawData<Float>(18, true, [
			// uv for triangle 1
			uvRectangle.x,      uvRectangle.y,      1 / projectionZ[0], // top left
			uvRectangle.width,  uvRectangle.y,      1 / projectionZ[1], // top right
			uvRectangle.width,  uvRectangle.height, 1 / projectionZ[3], // bottom left
			// uv for triangle 2
			uvRectangle.x,      uvRectangle.y,      1 / projectionZ[0], // top right
			uvRectangle.x,      uvRectangle.height, 1 / projectionZ[2], // top left
			uvRectangle.width,  uvRectangle.height, 1 / projectionZ[3]  // bottom right
		]);
        // @formatter:on
		final absGlow = output.visuals.glow * 255;
		final negGlow = 1 - output.visuals.glow;
		var color = new ColorTransform(negGlow, negGlow, negGlow, arrow.alpha * output.visuals.alpha, Math.round(output.visuals.glowR * absGlow),
			Math.round(output.visuals.glowG * absGlow), Math.round(output.visuals.glowB * absGlow));

		// make the instruction
		var newInstruction:FMDrawInstruction = {};
		newInstruction.item = arrow;
		newInstruction.vertices = vertices;
		newInstruction.uvt = uvData;
		newInstruction.indices = new Vector<Int>(vertices.length, true, [for (i in 0...vertices.length) i]);
		newInstruction.colorData = [color];

		queue[count] = newInstruction;
		count++;
	}

	override public function shift() {
		__drawInstruction(queue.shift());
	}

	/*
		override public function render(times:Null<Int>):Void
		{
			if (times == null)
				times = queue.length;

			var iterator = queue.iterator();
			var count = 0;

			@:privateAccess do {
				__drawInstruction(iterator.next());

				count++;
			} while (count < times && iterator.hasNext());

			queue = queue.splice(count, queue.length);
	}*/
	private function __drawInstruction(instruction:FMDrawInstruction) {
		if (instruction.colorData[0].alphaMultiplier <= 0)
			return;

		final item = instruction.item;
		final cameras = item._cameras != null ? item._cameras : Adapter.instance.getArrowCamera();

		@:privateAccess
		for (camera in cameras) {
			final cTransform = instruction.colorData[0];
			cTransform.alphaMultiplier *= camera.alpha;

			camera.drawTriangles(item.graphic, instruction.vertices, instruction.indices, instruction.uvt, new Vector<Int>(), null, item.blend, false,
				item.antialiasing, cTransform, item.shader);
		}
	}
}

class ModchartArrowPath extends ModchartRenderer<FlxSprite> {
	var __shape:Shape = new Shape();
	var __display:FlxSprite = new FlxSprite();
	var __queuedPoints:Array<Array<Float>> = [];
	var __pathPoints:Vector<Float> = new Vector<Float>();
	var __pathCommands:Vector<Int> = new Vector<Int>();

	public function new(instance:PlayField) {
		super(instance);

		__display.makeGraphic(FlxG.width, FlxG.height, 0x00FFFFFF);
	}

	// the entry sprite should be A RECEPTOR / STRUM !!
	override public function prepare(item:FlxSprite) {
		final lane = Adapter.instance.getLaneFromArrow(item);
		final fn = Adapter.instance.getPlayerFromArrow(item);

		final alpha = instance.getPercent('arrowPathAlpha', fn);
		final thickness = 1 + Math.round(instance.getPercent('arrowPathThickness', fn));

		if (alpha <= 0 || thickness <= 0)
			return;

		final divisions = Math.round(60 / Math.max(1, instance.getPercent('arrowPathDivisions', fn)));
		final limit = 1500 * (1 + instance.getPercent('arrowPathLength', fn));
		final interval = limit / divisions;

		var moved = false;

		pathVector.setTo(Adapter.instance.getDefaultReceptorX(lane, fn), Adapter.instance.getDefaultReceptorY(lane, fn), 0);
		pathVector.incrementBy(ModchartUtil.getHalfPos());

		var pointData:Array<Array<Dynamic>> = [];
		pointData.resize(divisions);

		var pID = 0;

		var songPos = Adapter.instance.getSongPosition();

		for (sub in 0...divisions) {
			var hitTime = -500 + interval * sub;

			var output = instance.modifiers.getPath(pathVector.clone(), {
				hitTime: songPos + hitTime,
				distance: hitTime,
				lane: lane,
				player: fn,
				isTapArrow: true
			}, 0, false);
			final position = output.pos;

			/**
				* So it seems that if the lines are too far from the screen
				causes HORRIBLE memory leaks (from 60mb to 3gb-5gb in 2 seconds WHAT THE FUCK)
			 */
			if ((position.x <= 0 - thickness - ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.x >= __display.pixels.rect.width + ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.y <= 0 - thickness - ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.y >= __display.pixels.rect.height + ARROW_PATH_BOUNDARY_OFFSET))
				continue;

			pointData[pID++] = [!moved, position.x, position.y];

			moved = true;
		}

		var newInstruction:FMDrawInstruction = {};
		newInstruction.mappedExtra = [
			'style' => [thickness, 0xFFFFFFFF, alpha],
			'position' => pointData,
			'lane' => lane
		];

		queue[count] = newInstruction;
		count++;
	}

	override public function shift() {
		if (queue.length <= 0)
			return;

		__pathPoints.splice(0, __pathPoints.length);
		__pathCommands.splice(0, __pathCommands.length);
		__shape.graphics.clear();
		__display.cameras = Adapter.instance.getArrowCamera();

		final iterator = queue.iterator();
		var iteratorHasNext = iterator.hasNext;
		var iteratorNext = iterator.next;
		var lastLane = -1;

		do {
			final instruction = iteratorNext();
			final thisLane = instruction.mappedExtra.get('lane');

			if (lastLane != thisLane) {
				final style = instruction.mappedExtra.get('style');
				__shape.graphics.lineStyle(style[0], style[1], style[2], false, NORMAL, ROUND, ROUND);
			}

			final steps = instruction.mappedExtra.get('position').iterator();

			var stepsHasNext = steps.hasNext;
			var stepsNext = steps.next;

			while (stepsHasNext()) {
				final thisStep = stepsNext();

				final needsToMove:Bool = cast thisStep[0];
				final posX:Float = cast thisStep[1];
				final posY:Float = cast thisStep[2];

				__pathCommands.push(needsToMove ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
				__pathPoints.push(posX);
				__pathPoints.push(posY);
			}

			lastLane = thisLane;
		} while (iteratorHasNext());

		__shape.graphics.drawPath(__pathCommands, __pathPoints);

		// then drawing the path pixels into the sprite pixels
		__display.pixels.fillRect(__display.pixels.rect, 0x00FFFFFF);
		__display.pixels.draw(__shape);
		// draw the sprite to the cam
		__display.draw();

		queue.splice(0, queue.length);
	}

	override function dispose() {
		__display.destroy();
		__shape.graphics.clear();
		__pathPoints.splice(0, __pathPoints.length);
		__pathCommands.splice(0, __pathCommands.length);
	}

	inline static final ARROW_PATH_BOUNDARY_OFFSET:Float = 50;
}

// TODO: fix this shit, i have this class in private cuz it sucks and doesnt even draw anything
// also should i call this actor frame ?
class ModchartProxyRenderer extends ModchartRenderer<FlxCamera> {
	override public function prepare(cam:FlxCamera):Void {}
}

@:publicFields
@:structInit
class FMDrawInstruction {
	var item:FlxSprite;
	var vertices:openfl.Vector<Float>;
	var uvt:openfl.Vector<Float>;
	var indices:openfl.Vector<Int>;
	var colorData:Array<ColorTransform>;

	var extra:Array<Dynamic>;
	var mappedExtra:Map<String, Dynamic>;

	public function new() {}
}
