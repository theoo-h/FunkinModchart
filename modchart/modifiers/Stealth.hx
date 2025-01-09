package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;
import flixel.FlxG;
import modchart.core.util.ModchartUtil;

class Stealth extends Modifier {
	public static var fadeDistY = 65;

	public function getSuddenEnd(sudden:Float, suddenExtend:Float, suddenOffset:Float) {
		return (-120 * suddenExtend)
			+ (FlxG.height * 0.5)
			+ fadeDistY * FlxMath.remapToRange(sudden, 0, 1, 1, 1.25)
			+ (FlxG.height * 0.5) * suddenOffset;
	}

	public function getSuddenStart(sudden:Float, suddenExtend:Float, suddenOffset:Float) {
		return (120 * suddenExtend)
			+ (FlxG.height * 0.5)
			+ fadeDistY * FlxMath.remapToRange(sudden, 0, 1, 0, 0.25)
			+ (FlxG.height * 0.5) * suddenOffset;
	}

	public function new(pf) {
		super(pf);

		setPercent('alpha', 1, -1);
	}

	override public function visuals(data:Visuals, params:RenderParams) {
		var field = params.field;
		var sudden = getPercent('sudden', field);
		var suddenExtend = getPercent('suddenExtend', field);
		var suddenOffset = getPercent('suddenOffset', field);
		var suddenAlpha = ModchartUtil.clamp(
			FlxMath.remapToRange(
				params.hDiff,
				getSuddenStart(sudden, suddenExtend, suddenOffset),
				getSuddenEnd(sudden, suddenExtend, suddenOffset),
				0, -1
			),
			-1, 0
		);

		data.alpha = getPercent('alpha', field) + getPercent('alphaOffset', field);

		// sudden
		data.alpha += suddenAlpha * sudden;
		data.glow -= getPercent('flash', field) + suddenAlpha * (sudden * 1.5);

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
