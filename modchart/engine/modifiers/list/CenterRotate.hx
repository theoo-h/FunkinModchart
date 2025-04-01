package modchart.engine.modifiers.list;

import flixel.FlxG;
import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;
import modchart.backend.util.ModchartUtil;

class CenterRotate extends Rotate {
	override public function getOrigin(curPos:Vector3, params:RenderParams):Vector3 {
		return new Vector3(FlxG.width * 0.5, HEIGHT * 0.5);
	}

	override public function getRotateName():String
		return 'centerRotate';

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
