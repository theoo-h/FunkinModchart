package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Transform extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var receptorName = Std.string(params.receptor);
		var field = params.field;
		var val = 1;
        if (Adapter.instance.getDownscroll())
			val *= -1;

		curPos.x += getPercent('x', field) + getPercent('x' + receptorName, field) + getPercent('xoffset', field) + getPercent('xoffset' + receptorName, field);

		//Y poss adds this "YD" modifier, modifier used for when you need like "downscroll and upscroll movement" but not like the same, basically, if upscroll goes down, if down, then goes up.
		curPos.y += getPercent('y', field) + getPercent('y' + receptorName, field) + (getPercent('yd', field)*val) + (getPercent('yd' + receptorName, field)*val)
			 	+ getPercent('yoffset', field) + getPercent('yoffset' + receptorName, field) + (getPercent('ydoffset', field)*val) + (getPercent('ydoffset' + receptorName, field)*val);

		curPos.z += getPercent('z', field) + getPercent('z' + receptorName, field) + getPercent('zoffset', field) + getPercent('zoffset' + receptorName, field);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
