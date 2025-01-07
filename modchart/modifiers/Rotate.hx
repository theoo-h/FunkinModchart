package modchart.modifiers;

import modchart.core.util.ModchartUtil;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;
import flixel.FlxG;

class Rotate extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var angleX = getPercent(getRotateName() + Std.string('X'), params.field);
		var angleY = getPercent(getRotateName() + Std.string('Y'), params.field);
		var angleZ = getPercent(getRotateName() + Std.string('Z'), params.field);

		if ((angleX + angleY + angleZ) == 0)
			return curPos;
		
		final origin:Vector3D = getOrigin(curPos, params);
		final diff = curPos.subtract(origin);
		final out = ModchartUtil.rotate3DVector(diff, angleX, angleY, angleZ);
		curPos.copyFrom(origin.add(out));
		return curPos;
    }
	public function getOrigin(curPos:Vector3D, params:RenderParams):Vector3D
	{
		return new Vector3D(
			40 + WIDTH / 2 * params.field + 2 * ARROW_SIZE + ARROW_SIZEDIV2,
			HEIGHT * 0.5
		);
	}
	public function getRotateName():String
		return 'rotate';
	
	override public function shouldRun(params:RenderParams):Bool
		return true;
}