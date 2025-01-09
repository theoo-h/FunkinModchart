package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Drunk extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
        var field = params.field;
		var speed = getPercent('drunkSpeed', field);
		var period = getPercent('drunkPeriod', field);
		var offset = getPercent('drunkOffset', field);

        var shift = params.sPos * 0.001 * (1 + speed) + params.receptor * ((offset * 0.2) + 0.2) + params.hDiff * ((period * 10) + 10) / HEIGHT;
        var drunk = (cos(shift) * ARROW_SIZE * 0.5);

        curPos.x += drunk * (getPercent('drunk', field) + getPercent('drunkX', field));
        curPos.y += drunk * getPercent('drunkY', field);
        curPos.z += drunk * getPercent('drunkZ', field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}