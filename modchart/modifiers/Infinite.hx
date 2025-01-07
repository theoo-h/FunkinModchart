package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;

class Infinite extends Modifier
{
    override function render(pos:Vector3D, params:RenderParams)
	{
		var perc = getPercent('infinite', params.field);

		if (perc == 0)
			return pos;
		
		var infinite = new Vector3D();

		// alternate the angles
		var rat = params.receptor % 2 == 0 ? 1 : -1;
		// adding 45° so the arrows ends at the end
		var fTime = (-params.hDiff * Math.PI * 0.001) + rat * Math.PI / 2;
		// used for make the curve
		final invTransf = (2 / (3 - cos(fTime * 2)));

		// apply the scroll
		infinite.setTo(
			WIDTH * .5 + invTransf * cos(fTime) * 580,
			HEIGHT * .5 + invTransf * (sin(fTime * 2) / 2) * 750,
			0
		);

		return ModchartUtil.lerpVector3D(pos, infinite, perc);
	}
	override public function shouldRun(params:RenderParams):Bool
		return true;
}