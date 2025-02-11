package modchart.modifiers;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Beat extends Modifier {
	public function new(pf) {
		super(pf);

		var stuff = ['', 'x', 'y', 'z'];
		for (i in 0...stuff.length) {
			setPercent('beat' + stuff[i] + 'speed', 1, -1);
			setPercent('beat' + stuff[i] + 'mult', 1, -1);
			setPercent('beat' + stuff[i] + 'offset', 0, -1);
			setPercent('beat' + stuff[i] + 'alternate', 1, -1);
		}
	}

	function beatMath(params:RenderParams, offset:Float, speed:Float, mult:Float, alternate:Float):Float {
		var fAccelTime = 0.2;
		var fTotalTime = 0.5;

		var timmy:Float = (params.curBeat + offset) * speed;

		var posMult:Float = mult * 2; // Multiplied by 2 to make the effect more pronounced instead of being like drunk-lite lmao

		var curBeat = timmy + fAccelTime;
		var bEvenBeat = (Math.floor(curBeat) % 2) != 0;

		if (curBeat < 0)
			return 0;

		curBeat -= Math.floor(curBeat);
		curBeat += 1;
		curBeat -= Math.floor(curBeat);

		if (curBeat >= fTotalTime)
			return 0;

		var fAmount:Float;

		if (curBeat < fAccelTime) {
			fAmount = FlxMath.remapToRange(curBeat, 0.0, fAccelTime, 0.0, 1.0);
			fAmount *= fAmount;
		} else
			/* curBeat < fTotalTime */ {
			fAmount = FlxMath.remapToRange(curBeat, fAccelTime, fTotalTime, 1.0, 0.0);
			fAmount = 1 - (1 - fAmount) * (1 - fAmount);
		}

		if (bEvenBeat && alternate >= 0.5)
			fAmount *= -1;

		var fShift = 20.0 * fAmount * sin((params.distance * 0.01 * posMult) + (Math.PI / 2.0));
		return fShift;
	}

	function doBeat(curPos:Vector3D, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.lane);
		final player = params.player;
		var distance = params.distance;

		var offset = getPercent('beat' + axis + 'Offset', player) + getPercent('beat' + axis + receptorName + 'Offset', player);
		var speed = getPercent('beat' + axis + 'Speed', player) + getPercent('beat' + axis + receptorName + 'Speed', player);
		var mult = getPercent('beat' + axis + 'Mult', player) + getPercent('beat' + axis + receptorName + 'Mult', player);
		var alternate = getPercent('beat' + axis + 'Alternate', player) + getPercent('beat' + axis + receptorName + 'Alternate', player);

		var shift = 0.;

		shift += beatMath(params, offset, speed, mult, alternate) * (getPercent('beat' + axis, player) + getPercent('beat' + axis + receptorName, player));

		switch (realAxis) {
			case 'x':
				curPos.x += shift;
			case 'y':
				curPos.y += shift;
			case 'z':
				curPos.z += shift;
		}
	}

	override public function render(curPos:Vector3D, params:RenderParams) {
		doBeat(curPos, params, '', 'x');
		doBeat(curPos, params, 'x', 'x');
		doBeat(curPos, params, 'y', 'y');
		doBeat(curPos, params, 'z', 'z');

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
