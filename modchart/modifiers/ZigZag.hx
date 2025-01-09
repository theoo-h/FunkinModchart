package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class ZigZag extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
        final zigzag = getPercent('zigZag', params.field);

        if (zigzag == 0)
            return curPos;

		var theta = -params.hDiff / ARROW_SIZE * PI;
		var outRelative = Math.acos(cos(theta + PI / 2)) / PI * 2 - 1;

        curPos.x += outRelative * ARROW_SIZEDIV2;

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}