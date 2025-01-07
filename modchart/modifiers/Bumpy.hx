package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Bumpy extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var bumpyx = (40 * sin((params.hDiff + (100.0 * getPercent('bumpyXOffset', params.field))) / ((getPercent('bumpyXPeriod', params.field) * 24.0) + 24.0)));
		var bumpyy = (40 * sin((params.hDiff + (100.0 * getPercent('bumpyYOffset', params.field))) / ((getPercent('bumpyYPeriod', params.field) * 24.0) + 24.0)));
		var bumpyz = (40 * sin((params.hDiff + (100.0 * getPercent('bumpyZOffset', params.field))) / ((getPercent('bumpyZPeriod', params.field) * 24.0) + 24.0)));

		curPos.x += bumpyx * getPercent('bumpyX', params.field); 
        curPos.y += bumpyy * getPercent('bumpyY', params.field);
        curPos.z += bumpyz * (getPercent('bumpy', params.field) + getPercent('bumpyZ', params.field));

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}