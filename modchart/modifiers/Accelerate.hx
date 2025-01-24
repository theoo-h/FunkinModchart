package modchart.modifiers;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Accelerate extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('waveMult', 1, -1);
	}

	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;

		//All the mod names are wrong theo, i will kill you. (they are Boost, Brake and Wave, not accelerate decelerate and acedelerate (last one is a joke xd))

		//Accelerate / Boost
		final scale = HEIGHT * (1 + (getPercent('accelerateScale', field) + getPercent('boostScale', field)));

		var off = params.hDiff * 1.5 / ((params.hDiff + (scale) / 1.2) / scale);
		curPos.y += ModchartUtil.clamp((getPercent('accelerate', field) + getPercent('boost', field)) * (off - params.hDiff), -600, 600);

		//Decelerate / Brake
		final scale2 = HEIGHT * (1 + (getPercent('decelerateScale', field) + getPercent('brakeScale', field)));

		var off2 = params.hDiff * 1.5 / ((params.hDiff + (scale2) / 1.2) / scale);
		curPos.y += ModchartUtil.clamp(-(getPercent('decelerate', field) + getPercent('brake', field)) * (off2 - params.hDiff), -600, 600);

		//Acedelerate / Wave mod
   	 	curPos.y += (-getPercent('wave', field)*100) * sin(params.hDiff / 38.0 * getPercent('waveMult', field) * 0.2);
		
		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
