package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class SchmovinTipsy extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
        curPos.y += sin(params.fBeat / 4 * PI + params.receptor) * ARROW_SIZEDIV2 * getPercent('schmovinTipsy', params.field);
        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}