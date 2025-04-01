package modchart.backend.graphics.renderers;

@:publicFields
@:structInit
class PathVisuals {
	var alpha:Float = 1;
	var scale:Float = 1;
	var color:Int = 0xFFFFFFF;
}

var pathVector = new Vector3();

class ModchartPathRenderer extends ModchartRenderer<FlxSprite> {
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
		final thickness = 1 + Std.int(instance.getPercent('arrowPathThickness', fn));

		if (alpha <= 0 || thickness <= 0)
			return;

		final divisions = Std.int(40 / Math.max(1, instance.getPercent('arrowPathDivisions', fn)));
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
			}, 0, true);
			final position = output.pos;

			/*
			 * So it seems that if the lines are too far from the screen
			 * causes HORRIBLE memory leaks (from 60mb to 3gb-5gb in 2 seconds WHAT THE FUCK)
			 */
			if ((position.x <= 0 - thickness - ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.x >= __display.pixels.rect.width + ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.y <= 0 - thickness - ARROW_PATH_BOUNDARY_OFFSET)
				|| (position.y >= __display.pixels.rect.height + ARROW_PATH_BOUNDARY_OFFSET))
				continue;

			final vis:PathVisuals = {
				alpha: alpha * output.visuals.alpha,
				scale: thickness * output.visuals.scaleX,
				color: 0xFFFFFF
			};
			pointData[pID++] = [!moved, position.x, position.y, position.z, vis];

			moved = true;
		}

		var newInstruction:FMDrawInstruction = {};
		// newInstruction.mappedExtra = ['s' => [thickness, 0xFFFFFFFF, alpha], 'pd' => pointData, 'l' => lane, 'p' => fn];
		newInstruction.extra = [pointData];
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

		var lastLane = -1;

		for (i in 0...queue.length) {
			final instruction = queue[i];
			final data:Array<Array<Dynamic>> = cast instruction.extra[0];
			final steps = data.iterator();

			var stepsHasNext = steps.hasNext;
			var stepsNext = steps.next;

			while (stepsHasNext()) {
				final thisStep = stepsNext();

				// in case the instruction is null (if the point is not visible in screen, we skip it)
				if (thisStep == null)
					continue;

				final needsToMove:Bool = cast thisStep[0];
				final posX:Float = cast thisStep[1];
				final posY:Float = cast thisStep[2];
				final visuals:PathVisuals = cast thisStep[4];

				__shape.graphics.lineStyle(visuals.scale, visuals.color, visuals.alpha, false, NORMAL);
				__pathCommands.push(needsToMove ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
				__pathPoints.push(posX);
				__pathPoints.push(posY);
			}
		}

		__shape.graphics.drawPath(__pathCommands, __pathPoints);

		// then drawing the path pixels into the sprite pixels
		__display.pixels.fillRect(__display.pixels.rect, 0x00FFFFFF);
		__display.pixels.draw(__shape);
		// draw the sprite to the cam
		__display.draw();
	}

	override function dispose() {
		__display.destroy();
		__shape.graphics.clear();
		__pathPoints.splice(0, __pathPoints.length);
		__pathCommands.splice(0, __pathCommands.length);
	}

	inline static final ARROW_PATH_BOUNDARY_OFFSET:Float = 300;
}
