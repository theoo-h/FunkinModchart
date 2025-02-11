package modchart.modifiers;

import flixel.FlxG;

class Zoom extends Modifier {
	var __curPercent:Null<Float> = -1;

	override public function render(curPos:Vector3D, params:RenderParams) {
		updatePercent(params);
		
		if (__curPercent == 1)
			return curPos;

		var origin = new Vector3D(FlxG.width * .5, FlxG.height * .5);
		var diff = curPos.subtract(origin);
		diff.scaleBy(__curPercent);
		return diff.add(origin);
	}

	override public function visuals(data:Visuals, params:RenderParams):Visuals {
		if (__curPercent == null)
			updatePercent(params);

		data.scaleX = data.scaleX * __curPercent;
		data.scaleY = data.scaleY * __curPercent;

		__curPercent = null;

		return data;
	}

	inline function updatePercent(params:RenderParams) {
		__curPercent = 1 + ((getPercent('zoom', params.player) + -getPercent('mini', params.player)) * 0.5);
	}
	override public function shouldRun(params:RenderParams):Bool
		return true;
}
