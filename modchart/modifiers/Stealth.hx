package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;
import flixel.FlxG;
import modchart.core.util.ModchartUtil;

class Stealth extends Modifier
{
	public static var fadeDistY = 65;

	public function getSuddenEnd(params){
		return (-120 * getPercent('suddenExtend', params.field)) + (FlxG.height* 0.5) + fadeDistY * FlxMath.remapToRange(getPercent('sudden', params.field),0,1,1,1.25) + (FlxG.height* 0.5) * getPercent("suddenOffset", params.field);
	}

	public function getSuddenStart(params){
		return (120 * getPercent('suddenExtend', params.field)) + (FlxG.height* 0.5) + fadeDistY * FlxMath.remapToRange(getPercent('sudden', params.field),0,1,0,0.25) + (FlxG.height* 0.5) * getPercent("suddenOffset", params.field);
	}
	public function new(pf)
	{
		super(pf);

		setPercent('alpha', 1, -1);
	}
	override public function visuals(data:Visuals, params:RenderParams)
	{
		var suddenAlpha = ModchartUtil.clamp(FlxMath.remapToRange(params.hDiff, getSuddenStart(params), getSuddenEnd(params), 0, -1), -1, 0);

		data.alpha = getPercent('alpha', params.field) + getPercent('alphaOffset', params.field);

		// sudden
		var sudden = getPercent('sudden', params.field);
		data.alpha += suddenAlpha * sudden;
		data.glow -= getPercent('flash', params.field) + suddenAlpha * (sudden * 1.5);

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}