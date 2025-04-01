package modchart.backend.graphics.renderers;

typedef HoldSegmentOutput = {
	origin:Vector3,
	left:Vector3,
	right:Vector3,
	visuals:Visuals,
	depth:Float
}

final __matrix:Matrix = new Matrix();

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ModchartHoldRenderer extends ModchartRenderer<FlxSprite> {
	private var __lastHoldSubs:Int = -1;

	var _indices:Null<Vector<Int>> = new Vector<Int>();

	public function new(instance:PlayField) {
		super(instance);

		instance.setPercent('dizzyHolds', 1, -1);
	}

	inline private function __rotateTail(pos:Vector3) {
		if (__parentOutput == null || (__rotateX == 0 && __rotateY == 0 && __rotateZ == 0))
			return pos;

		var tailFactor = pos.subtract(__parentOutput.pos);
		tailFactor = ModchartUtil.rotate3DVector(tailFactor, __rotateX, __rotateY, __rotateZ);
		var output = __parentOutput.pos.add(tailFactor);
		output.z *= 0.001 * Config.Z_SCALE;
		return projection.transformVector(output, __parentOutput.pos);
	}

	/**
	 * Returns the normal points along the hold path at specific hitTime using.
	 *
	 * Based on schmovin' hold system
	 * @param basePos The hold position per default
	 * @see https://en.wikipedia.org/wiki/Unit_circle
	 */
	@:noCompletion
	inline private function getHoldSegment(hold:FlxSprite, basePos:Vector3, params:ArrowData):HoldSegmentOutput {
		@:privateAccess
		var holdTime = params.hitTime;
		var parentTime = Adapter.instance.getHoldParentTime(hold);

		var holdDistance = params.distance;
		var parentDistance = Math.max(0, parentTime - Adapter.instance.getSongPosition());

		params.hitTime = FlxMath.lerp(parentTime, holdTime, __long);
		params.distance = FlxMath.lerp(parentDistance, holdDistance, __long);
		if (params.hitten && params.distance < 0)
			params.distance = 0;

		final size = hold.frame.frame.width * hold.scale.x * .5;

		var origin:ModifierOutput = instance.modifiers.getPath(basePos.clone(), params);
		var curPoint = origin.pos;
		final depth = (origin.pos.z - 1) * 1000;
		final zScale:Float = curPoint.z != 0 ? (1 / curPoint.z) : 1;
		curPoint.z = 0;

		var unit:Vector3;

		if (Config.OPTIMIZE_HOLDS) {
			unit = new Vector3(0, 1, 0);
		} else {
			var next = instance.modifiers.getPath(basePos.clone(), params, 1, false, true);
			next.pos.z = 0;

			// normalized points difference (from 0-1)
			unit = next.pos.subtract(curPoint);
			unit.normalize();
		}

		var quad0 = new Vector3(-unit.y * size, unit.x * size);
		var quad1 = new Vector3(unit.y * size, -unit.x * size);

		final visuals = origin.visuals;
		@:privateAccess
		for (i in 0...2) {
			var quad = switch (i) {
				case 0: quad0;
				case 1: quad1;
				default: null;
			}
			var rotation = quad;
			var rotate = __dizzy != 0;

			if (rotate)
				rotation = ModchartUtil.rotate3DVector(quad, 0, visuals.angleY * __dizzy, 0);

			if (visuals.skewX != 0 || visuals.skewY != 0) {
				__matrix.identity();

				__matrix.b = ModchartUtil.tan(visuals.skewY * FlxAngle.TO_RAD);
				__matrix.c = ModchartUtil.tan(visuals.skewX * FlxAngle.TO_RAD);

				rotation.x = __matrix.__transformX(rotation.x, rotation.y);
				rotation.y = __matrix.__transformY(rotation.x, rotation.y);
			}
			rotation.x = rotation.x * zScale * visuals.scaleX;
			rotation.y = rotation.y * zScale * visuals.scaleY;

			var view = new Vector3(rotation.x + curPoint.x, rotation.y + curPoint.y, rotation.z);
			view = __rotateTail(view);
			if (Config.CAMERA3D_ENABLED)
				view = instance.camera3D.applyViewTo(view);
			view.z *= 0.001;

			// The result of the perspective projection of rotation
			var projection = view;

			if (view.z != 0)
				projection = this.projection.transformVector(view);

			quad.x = projection.x;
			quad.y = projection.y;
			quad.z = projection.z;
		}
		return {
			origin: curPoint,
			left: quad0,
			right: quad1,
			visuals: origin.visuals,
			depth: depth
		};
	}

	private var __long:Float = 0.0;
	private var __straightAmount:Float = 0.0;
	private var __calculatingSegments:Bool = false;
	private var __rotateX:Float = 0;
	private var __rotateY:Float = 0;
	private var __rotateZ:Float = 0;
	private var __dizzy:Float = 0;
	private var __parentOutput:ModifierOutput;
	private var __centered2:Float = 0;
	private var basePos:Vector3;

	/*
		private function getStraightHoldSegment(hold:FlxSprite, basePos:Vector3, params:ArrowData):Array<Dynamic> {
			var perc = __straightAmount;

			var oldHitTime = params.hitTime;
			params.hitTime = Adapter.instance.getHoldParentTime(hold);

			var distance = params.hitTime - Adapter.instance.getSongPosition();
			params.distance = oldHitTime == 0 ? 0 : distance;

			var holdProgress = oldHitTime - params.hitTime;
			final origin = instance.modifiers.getPath(basePos.clone(), params);
			final next = instance.modifiers.getPath(basePos.clone(), params, 1);
			final originPos = origin.pos;
			final nextPos = next.pos;

			originPos.z = nextPos.z = 0;

			// actual unit
			var unit = nextPos.subtract(originPos);
			unit.normalize();

			// the center position of the hold
			var holdOrigin = unit.clone();
			holdOrigin.scaleBy(holdProgress * __long);
			holdOrigin.incrementBy(originPos);

			var zScale:Float = holdOrigin.z != 0 ? (1 / holdOrigin.z) : 1;
			holdOrigin.z = 0;

			var size = hold.frame.frame.width * hold.scale.x * .5;

			var quad0 = new Vector3(-unit.y * size, unit.x * size);
			var quad1 = new Vector3(unit.y * size, -unit.x * size);

			return [
				[
					holdOrigin.add(quad0),
					holdOrigin.add(quad1),
					holdOrigin.add(new Vector3(0, 0, 1 + (1 - zScale) * 0.001))
				],
				origin.visuals
			];
	}*/
	@:noCompletion
	inline private function updateIndices() {
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
		if (item.alpha <= 0)
			return;
		final arrow:FlxSprite = item;
		final newInstruction:FMDrawInstruction = {};
		final HOLD_SUBDIVISIONS = Adapter.instance.getHoldSubdivisions();

		if (__lastHoldSubs != HOLD_SUBDIVISIONS)
			updateIndices();

		if (__lastHoldSubs == -1)
			__lastHoldSubs = Adapter.instance.getHoldSubdivisions();

		Manager.HOLD_SIZE = arrow.width;
		Manager.HOLD_SIZEDIV2 = arrow.width * .5;

		final player = Adapter.instance.getPlayerFromArrow(item);
		final lane = Adapter.instance.getLaneFromArrow(item);

		basePos = ModchartUtil.getHalfPos();
		basePos.x += Adapter.instance.getDefaultReceptorX(lane, player);
		basePos.y += Adapter.instance.getDefaultReceptorY(lane, player);

		var vertices:openfl.Vector<Float> = new openfl.Vector<Float>(8 * HOLD_SUBDIVISIONS, true);
		var transfTotal:Array<ColorTransform> = [];
		transfTotal.resize(HOLD_SUBDIVISIONS);
		var tID = 0;

		var lastData:ArrowData = null;
		var lastSegment:Null<HoldSegmentOutput> = null;

		var depthApplied = false;
		var alphaTotal:Float = 0.;

		// refresh global mods percents
		__long = instance.getPercent('longHolds', player) - instance.getPercent('shortHolds', player) + 1;
		__centered2 = instance.getPercent('centered2', player);
		__dizzy = instance.getPercent('dizzyHolds', player);

		__rotateX = instance.getPercent('holdRotateX', player);
		__rotateY = instance.getPercent('holdRotateY', player);
		__rotateZ = instance.getPercent('holdRotateZ', player);

		var parentTime = Adapter.instance.getHoldParentTime(item);
		var parentData:ArrowData = {
			hitTime: parentTime,
			// this fixed the clipping gaps
			distance: Math.max(0, parentTime - Adapter.instance.getSongPosition()),
			lane: lane,
			player: player,
			hitten: Adapter.instance.arrowHit(item),
			isTapArrow: true
		};
		if (__rotateX != 0 || __rotateY != 0 || __rotateZ != 0) {
			__parentOutput = instance.modifiers.getPath(basePos.clone(), parentData);
			__parentOutput.pos.z = (__parentOutput.pos.z - 1) * 1000;
		}

		var getSegmentFunc = getHoldSegment;

		var vertPointer = 0;

		final end = Adapter.instance.isHoldEnd(item);
		final scale = (end ? (Config.PREVENT_SCALED_HOLD_END ? 1 : 0.6) * Config.HOLD_END_SCALE : 1);
		final height = item.frame.frame.height * item.scale.y * Config.HOLD_END_SCALE;

		var endScale = 1.;
		var scaled = false;

		var subCr = ((Adapter.instance.getStaticCrochet() * .25) * scale) / HOLD_SUBDIVISIONS;
		for (sub in 0...HOLD_SUBDIVISIONS) {
			var subOff = subCr * sub * endScale;

			var out1 = lastSegment;

			if (out1 == null)
				out1 = getSegmentFunc(item, basePos, lastData != null ? lastData : getArrowParams(arrow, subOff));

			var out2 = getSegmentFunc(item, basePos, (lastData = getArrowParams(arrow, subOff + (subCr * endScale))));

			if (!scaled && end && Config.PREVENT_SCALED_HOLD_END) {
				var diff = out2.origin.subtract(out1.origin);
				var actualHeight = diff.length;

				endScale = (subCr * 0.5) / actualHeight;
				out2 = getSegmentFunc(item, basePos, (lastData = getArrowParams(arrow, subCr * endScale)));

				scaled = true;
			}

			lastSegment = out2;

			if (!depthApplied) {
				arrow._z = out1.depth;
				depthApplied = true;
			}

			alphaTotal = alphaTotal + out1.visuals.alpha;

			var vertPos = (vertPointer++) * 8;
			vertices[vertPos] = out1.left.x;
			vertices[vertPos + 1] = out1.left.y;
			vertices[vertPos + 2] = out1.right.x;
			vertices[vertPos + 3] = out1.right.y;
			vertices[vertPos + 4] = out2.left.x;
			vertices[vertPos + 5] = out2.left.y;
			vertices[vertPos + 6] = out2.right.x;
			vertices[vertPos + 7] = out2.right.y;

			final negGlow = 1 - out1.visuals.glow;
			final absGlow = out1.visuals.glow * 255;
			transfTotal[tID++] = new ColorTransform(negGlow, negGlow, negGlow, out1.visuals.alpha * arrow.alpha, Math.round(out1.visuals.glowR * absGlow),
				Math.round(out1.visuals.glowG * absGlow), Math.round(out1.visuals.glowB * absGlow));
		}

		newInstruction.item = item;
		newInstruction.vertices = vertices;
		newInstruction.indices = _indices.copy();
		newInstruction.uvt = ModchartUtil.getHoldUVT(arrow, HOLD_SUBDIVISIONS);
		newInstruction.colorData = transfTotal;
		newInstruction.extra = [alphaTotal];

		queue[count] = newInstruction;
		count++;

		__lastHoldSubs = Adapter.instance.getHoldSubdivisions();
	}

	inline static final drawMargin = 50;

	inline function shouldDraw(info:HoldSegmentOutput) {
		return info.origin.x < -drawMargin
			&& info.origin.x > FlxG.width + drawMargin
			&& info.origin.y < -drawMargin
			&& info.origin.y > FlxG.height + drawMargin;
	}

	override public function shift() {
		__drawInstruction(queue[postCount++]);
	}

	private function __drawInstruction(instruction:FMDrawInstruction) {
		if (instruction == null)
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

	inline private function computeCentered2Height() {
		var center = FlxG.height * .5;
		var cury = basePos.y;
	}

	inline private function getArrowParams(arrow:FlxSprite, posOff:Float = 0):ArrowData {
		final player = Adapter.instance.getPlayerFromArrow(arrow);
		final lane = Adapter.instance.getLaneFromArrow(arrow);

		final timeC2 = flixel.FlxG.height * 0.25 * __centered2;
		final hitTime = Adapter.instance.getTimeFromArrow(arrow);

		var pos = (hitTime - Adapter.instance.getSongPosition()) + posOff;

		pos += timeC2;

		return {
			__holdSubdivisionOffset: posOff,
			hitTime: hitTime + posOff + timeC2,
			distance: pos,
			lane: lane,
			player: player,
			hitten: Adapter.instance.arrowHit(arrow),
			isTapArrow: true
		};
	}
}
