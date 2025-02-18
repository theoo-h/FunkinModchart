package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Transform extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var receptorName = Std.string(params.lane);
		var player = params.player;
		var val = 1;
		if (Adapter.instance.getDownscroll())
			val *= -1;

		curPos.x += getPercent('x', player) + getPercent('x' + receptorName, player) + getPercent('xoffset', player)
			+ getPercent('xoffset' + receptorName, player);

		// Y poss adds this "YD" modifier, modifier used for when you need like "downscroll and upscroll movement" but not like the same, basically, if upscroll goes down, if down, then goes up.
		curPos.y += getPercent('y', player) + getPercent('y' + receptorName, player) + (getPercent('yd', player) * val)
			+ (getPercent('yd' + receptorName, player) * val) + getPercent('yoffset', player) + getPercent('yoffset' + receptorName, player)
			+ (getPercent('ydoffset', player) * val) + (getPercent('ydoffset' + receptorName, player) * val);

		curPos.z += getPercent('z', player) + getPercent('z' + receptorName, player) + getPercent('zoffset', player)
			+ getPercent('zoffset' + receptorName, player);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
