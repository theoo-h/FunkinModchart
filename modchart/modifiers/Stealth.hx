package modchart.modifiers;

import flixel.FlxG;
import flixel.math.FlxMath;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Stealth extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('alpha', 1, -1);

		setPercent('suddenStart', 5, -1);
		setPercent('suddenEnd', 3, -1);
		setPercent('suddenGlow', 1, -1);

		setPercent('hiddenStart', 5, -1);
		setPercent('hiddenEnd', 3, -1);
		setPercent('hiddenGlow', 1, -1);
	}

	function computeSudden(data:Visuals, params:RenderParams) {
		final field = params.field;

		final sudden = getPercent('sudden', field);

		if (sudden == 0)
			return;

		final start = getPercent('suddenStart', field) * 100;
		final end = getPercent('suddenEnd', field) * 100;
		final glow = getPercent('suddenGlow', field);

		final alpha = FlxMath.remapToRange(FlxMath.bound(params.hDiff, end, start), end, start, 1, 0);

		if (glow != 0)
			data.glow += Math.max(0, (1 - alpha) * sudden * 2) * glow;
		data.alpha *= alpha * sudden;
	}

	function computeHidden(data:Visuals, params:RenderParams) {
		final field = params.field;

		final hidden = getPercent('hidden', field);

		if (hidden == 0)
			return;

		final start = getPercent('hiddenStart', field) * 100;
		final end = getPercent('hiddenEnd', field) * 100;
		final glow = getPercent('hiddenGlow', field);

		final alpha = FlxMath.remapToRange(FlxMath.bound(params.hDiff, end, start), end, start, 0, 1);

		if (glow != 0)
			data.glow += Math.max(0, (1 - alpha) * hidden * 2) * glow;
		data.alpha *= alpha * hidden;
	}

	override public function visuals(data:Visuals, params:RenderParams) {
		final field = params.field;

		final visibility = getPercent(params.arrow ? 'stealth' : 'dark', field) + getPercent(params.arrow ? 'stealth' : 'dark' + Std.string(params.receptor), field);
		data.alpha = ((getPercent('alpha', field) + getPercent('alpha' + Std.string(params.receptor), field)) * (1 - ((Math.max(0.5, visibility) - 0.5) * 2))) + getPercent('alphaOffset', field);
		data.glow += getPercent('flash', field) + (visibility * 2);

		// sudden & hidden
		computeSudden(data, params);
		computeHidden(data, params);

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
