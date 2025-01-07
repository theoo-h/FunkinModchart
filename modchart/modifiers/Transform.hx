package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Transform extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
        curPos.x += getPercent('x', params.field) + getPercent('xoffset', params.field) + getPercent('xoffset' + Std.string(params.receptor), params.field) + getPercent('x' + Std.string(params.receptor), params.field);
        curPos.y += getPercent('y', params.field) + getPercent('yoffset', params.field) + getPercent('yoffset' + Std.string(params.receptor), params.field) + getPercent('y' + Std.string(params.receptor), params.field);
        curPos.z += getPercent('z', params.field) + getPercent('zoffset', params.field) + getPercent('zoffset' + Std.string(params.receptor), params.field) + getPercent('z' + Std.string(params.receptor), params.field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}