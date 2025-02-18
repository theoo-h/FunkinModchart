package modchart.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import modchart.Modifier;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import modchart.modifiers.*;
import modchart.modifiers.false_paradise.*;
import openfl.geom.Vector3D;

@:structInit
@:publicFields
class ModifierOutput {
	var pos:Vector3D;
	var visuals:Visuals;
}

@:allow(modchart.Modifier)
class ModifierGroup {
	public static var GLOBAL_MODIFIERS:Map<String, Class<Modifier>> = [
		'reverse' => Reverse,
		'transform' => Transform,
		'opponentswap' => OpponentSwap,
		'drunk' => Drunk,
		'bumpy' => Bumpy,
		'tipsy' => Tipsy,
		'tornado' => Tornado,
		'invert' => Invert,
		'square' => Square,
		'zigzag' => ZigZag,
		'beat' => Beat,
		'boost' => Boost,
		'receptorscroll' => ReceptorScroll,
		'sawtooth' => SawTooth,
		'zoom' => Zoom,
		'rotate' => Rotate,
		'fieldrotate' => FieldRotate,
		'centerrotate' => CenterRotate,
		'confusion' => Confusion,
		'stealth' => Stealth,
		'scale' => Scale,
		'skew' => Skew,
		// YOU NEVER STOOD A CHANCE
		'infinite' => Infinite,
		'schmovindrunk' => SchmovinDrunk,
		'schmovintipsy' => SchmovinTipsy,
		'schmovintornado' => SchmovinTornado,
		'wiggle' => Wiggle,
		'arrowshape' => ArrowShape,
		'eyeshape' => EyeShape,
		'spiral' => Spiral,
		'counterclockwise' => CounterClockWise,
		'vibrate' => Vibrate,
		'bounce' => Bounce,
		'radionic' => Radionic,
		'schmovinarrowshape' => SchmovinArrowShape,
		'drugged' => Drugged
	];

	private var MODIFIER_REGISTRY:Map<String, Class<Modifier>> = GLOBAL_MODIFIERS;

	private var percents:StringMap<Vector<Float>> = new StringMap();
	private var modifiers:StringMap<Modifier> = new StringMap();

	private var sortedMods:Vector<String>;

	private var pf:PlayField;

	public function new(pf:PlayField) {
		this.pf = pf;

		__allocModSorting([]);
	}

	@:dox(hide)
	@:noCompletion private function __allocModSorting(newList:Array<String>) {
		return sortedMods = Vector.fromArrayCopy(newList);
	}

	// just render mods with the perspective stuff included
	public function getPath(pos:Vector3D, data:ArrowData, ?posDiff:Float = 0, ?allowVis:Bool = true, ?allowPos:Bool = true):ModifierOutput {
		var visuals:Visuals = {};

		if (!allowVis && !allowPos)
			return {pos: pos, visuals: visuals};

		final songPos = Adapter.instance.getSongPosition();
		final beat = Adapter.instance.getCurrentBeat();

		final args:RenderParams = {
			songTime: songPos,
			curBeat: beat,
			hitTime: data.hitTime + posDiff,
			distance: data.distance + posDiff,
			lane: data.lane,
			player: data.player,
			isTapArrow: data.isTapArrow
		}

		for (i in 0...sortedMods.length) {
			final mod = modifiers.get(sortedMods[i]);

			if (!mod.shouldRun(args))
				continue;

			if (allowPos)
				pos = mod.render(pos, args);
			if (allowVis)
				visuals = mod.visuals(visuals, args);
		}
		pos.z *= 0.001;
		return {
			pos: ModchartUtil.project(pos),
			visuals: visuals
		};
	}

	// TODO: add `activeMods` var (for optimization) and percentBackup for editor (can also be helpful for activeMods handling or idk)
	var activeMods:Vector<String>;
	var percentsBackup:StringMap<Vector<Float>>;

	public function refreshActiveMods() {}

	public function refreshPercentBackup() {}

	public function registerModifier(name:String, modifier:Class<Modifier>) {
		var lowerName = name.toLowerCase();
		if (MODIFIER_REGISTRY.get(lowerName) != null) {
			trace('There\'s already a modifier with name "$name" registered !');
			return;
		}
		MODIFIER_REGISTRY.set(lowerName, modifier);
	}

	public function addModifier(name:String) {
		var lowerName = name.toLowerCase();
		if (modifiers.exists(lowerName))
			return;
		var modifierClass:Null<Class<Modifier>> = MODIFIER_REGISTRY.get(lowerName);
		if (modifierClass == null) {
			trace('$name modifier was not found !');

			return;
		}
		var newModifier = Type.createInstance(modifierClass, [pf]);
		modifiers.set(lowerName, newModifier);

		final newArr = sortedMods.toArray();
		newArr.push(lowerName);
		__allocModSorting(newArr);
	}

	public function setPercent(name:String, value:Float, player:Int = -1) {
		var lwr = name.toLowerCase();
		var possiblePercs = percents.get(lwr);
		var generate = possiblePercs == null;
		var percs = generate ? __getAllocatedPercs() : possiblePercs;

		if (player == -1)
			for (_ in 0...percs.length)
				percs[_] = value;
		else
			percs[player] = value;

		// if the percent list already was created, we dont need to re-set the list
		if (generate)
			percents.set(lwr, percs);
	}

	public function getPercent(name:String, player:Int):Float {
		final percs = percents.get(name.toLowerCase());

		if (percs != null)
			return percs[player];
		return 0;
	}

	private inline function __getAllocatedPercs():Vector<Float> {
		final vector = new Vector<Float>(Adapter.instance.getPlayerCount());
		for (i in 0...vector.length)
			vector[i] = 0;
		return vector;
	}
}
