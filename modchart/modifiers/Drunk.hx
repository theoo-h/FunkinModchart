package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Drunk extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var speed = getPercent('drunkSpeed', params.field);
		var period = getPercent('drunkPeriod', params.field);
		var offset = getPercent('drunkOffset', params.field);

        var shift = params.sPos * 0.001 * (1 + speed) + params.receptor * ((offset * 0.2) + 0.2) + params.hDiff * ((period * 10) + 10) / HEIGHT;
        var drunk = (cos(shift) * ARROW_SIZE * 0.5);

        curPos.x += drunk * (getPercent('drunk', params.field) + getPercent('drunkX', params.field));
        curPos.y += drunk * getPercent('drunkY', params.field);
        curPos.z += drunk * getPercent('drunkZ', params.field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}