package modchart.modifiers;

import flixel.FlxG;
import flixel.math.FlxMath;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Stealth extends Modifier {
	public static var fadeDistY = 65;

	// public function getEnd(value:Float, extend:Float, offset:Float, hidden:Bool = false) {
	// 	return (-120 * extend)
	// 		+ (FlxG.height * 0.5)
	// 		+ fadeDistY * FlxMath.remapToRange(value, !hidden ? 0 : 1, !hidden ? 1 : 0, 1, 1.25)
	// 		+ (FlxG.height * 0.5) * offset;
	// }

	// public function getStart(value:Float, extend:Float, offset:Float, hidden:Bool = false) {
	// 	return (120 * extend)
	// 		+ (FlxG.height * 0.5)
	// 		+ fadeDistY * FlxMath.remapToRange(value, !hidden ? 0 : 1, !hidden ? 1 : 0, 0, 0.25)
	// 		+ (FlxG.height * 0.5) * offset;
	// }

	public function new(pf) {
		super(pf);

		setPercent('alpha', 1, -1); //control alpha of target and arrow
		setPercent('stealth', 0, -1); //substracts the color and alpha of arrow
		setPercent('dark', 0, -1); //same as up but for target
		setPercent('flash', 0, -1); //both target and arrow

		setPercent('suddenStart', 5, -1);
		setPercent('suddenEnd', 3, -1);
		setPercent('suddenGlow', 1, -1);
		setPercent('suddenExtend', 0, -1);
		setPercent('suddenOffset', 0, -1);

		setPercent('hiddenStart', 5, -1);
		setPercent('hiddenEnd', 3, -1);
		setPercent('hiddenGlow', 1, -1);
		setPercent('hiddenExtend', 0, -1);
		setPercent('hiddenOffset', 0, -1);
	}

	override public function visuals(data:Visuals, params:RenderParams) {
		var field = params.field;
		var sudden = getPercent('sudden', field);
		var sudStart = getPercent('suddenStart', field);
		var sudEnd = getPercent('suddenEnd', field);
		var sudGlow = getPercent('suddenGlow', field);
		var sudExtend = getPercent('suddenExtend', field);
		var sudOffset = getPercent('suddenOffset', field);
		// var suddenAlpha = ModchartUtil.clamp(FlxMath.remapToRange(params.hDiff, 
		// 		getStart(sudden, suddenExtend, suddenOffset),
		// 		getEnd(sudden, suddenExtend, suddenOffset), 0, -1),
		// 	-1, 0);
		var suddenAlpha = FlxMath.remapToRange(params.hDiff*sudExtend, 
			(sudStart*10) + (sudOffset*10), 
			(sudEnd*10) + (sudOffset*10), 
		1, 0);
		suddenAlpha = FlxMath.bound(suddenAlpha, 0, 1);

		var hidden = getPercent('hidden', field);
		var hidStart = getPercent('hiddenStart', field);
		var hidEnd = getPercent('hiddenEnd', field);
		var hidGlow = getPercent('hiddenGlow', field);
		var hidExtend = getPercent('hiddenExtend', field);
		var hidOffset = getPercent('hiddenOffset', field);
		// var hiddenAlpha = ModchartUtil.clamp(FlxMath.remapToRange(params.hDiff, 
		// 		getStart(hidden, hiddenExtend, hiddenOffset, true),
		// 		getEnd(hidden, hiddenExtend, hiddenOffset, true), 1, 0),
		// 	0, 1);
		var hiddenAlpha = FlxMath.remapToRange(params.hDiff*hidExtend,
			(hidStart*10) + (hidOffset*10), 
			(hidEnd*10) + (hidOffset*10), 
		0, 1);
		hiddenAlpha = FlxMath.bound(hiddenAlpha, 0, 1);


		//Alpha
		data.alpha = getPercent('alpha', field) + getPercent('alphaOffset', field);

		//Glow vars
		var stealthGlow:Float = getPercent('flash', field)*2;

        var substractAlpha:Float = getPercent('flash', field)-0.5;
		substractAlpha = FlxMath.bound(substractAlpha*2, 0, 1);

		var sudGlowCalc = suddenAlpha*sudden; //Calculate how the glow will spawn
		var hidGlowCalc = hiddenAlpha*hidden; //same as up but for despawn

		var finalGlowSud = sudGlowCalc * 2;
		var finalGlowHid = hidGlowCalc * 2;

		//Arrow
		if (params.arrow){
			//stealth
			stealthGlow += getPercent('stealth', field)*2;
			data.glow += stealthGlow
					+ (FlxMath.bound(finalGlowSud, -1, 1) * sudGlow) //sudden
					+ (FlxMath.bound(finalGlowHid, -1, 1) * hidGlow); //hidden

			substractAlpha += getPercent('stealth', field)-0.5;
			substractAlpha = FlxMath.bound(substractAlpha*2, 0, 1);
			data.alpha += -substractAlpha - FlxMath.bound((sudGlowCalc-0.5)*2, -1, 1) - FlxMath.bound((hidGlowCalc-0.5)*2, -1, 1);
			return data;
		}

		//Receptor
		if (!params.arrow){
			stealthGlow += getPercent('dark', field)*2;
			data.glow += stealthGlow;

			substractAlpha += getPercent('dark', field)-0.5;
			substractAlpha = FlxMath.bound(substractAlpha*2, 0, 1);
			data.alpha += -substractAlpha;
			return data;
		}

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
