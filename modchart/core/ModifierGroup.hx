package modchart.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import modchart.Modifier;
import modchart.core.macros.ModifiersMacro;
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
final class ModifierGroup {
	public static final COMPILED_MODIFIERS = ModifiersMacro.get();

	private var MODIFIER_REGISTRY:Map<String, Class<Modifier>> = new Map<String, Class<Modifier>>();

	private var percents:StringMap<Vector<Float>> = new StringMap();
	private var modifiers:StringMap<Modifier> = new StringMap();

	@:noCompletion private var __sortedModifiers:Vector<Modifier> = new Vector<Modifier>(16);
	@:noCompletion private var __sortedIDs:Vector<String> = new Vector<String>(16);
	@:noCompletion private var __idCount:Int = 0;
	@:noCompletion private var __modCount:Int = 0;

	private var pf:PlayField;

	inline private function __loadModifiers() {
		for (cls in COMPILED_MODIFIERS) {
			var name = Type.getClassName(cls);
			name = name.substring(name.lastIndexOf('.') + 1, name.length);
			MODIFIER_REGISTRY.set(name.toLowerCase(), cast cls);
		}
	}

	public function new(pf:PlayField) {
		__loadModifiers();

		this.pf = pf;
	}

	// just render mods with the perspective stuff included
	public inline function getPath(pos:Vector3D, data:ArrowData, ?posDiff:Float = 0, ?allowVis:Bool = true, ?allowPos:Bool = true):ModifierOutput {
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

		for (i in 0...__modCount) {
			final mod = __sortedModifiers[i];

			if (!mod.shouldRun(args))
				continue;

			if (allowPos)
				pos = mod.render(pos, args);
			if (allowVis)
				visuals = mod.visuals(visuals, args);
		}
		pos.z *= 0.001 * Config.Z_SCALE;
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

	public inline function registerModifier(name:String, modifier:Class<Modifier>) {
		var lowerName = name.toLowerCase();
		if (MODIFIER_REGISTRY.get(lowerName) != null) {
			trace('There\'s already a modifier with name "$name" registered !');
			return;
		}
		MODIFIER_REGISTRY.set(lowerName, modifier);
	}

	public inline function addScriptedModifier(name:String, instance:Modifier)
		__addModifier(name, instance);

	public inline function addModifier(name:String) {
		var lowerName = name.toLowerCase();
		if (modifiers.exists(lowerName))
			return;

		var modifierClass:Null<Class<Modifier>> = MODIFIER_REGISTRY.get(lowerName);
		if (modifierClass == null) {
			trace('$name modifier was not found !');

			return;
		}
		var newModifier = Type.createInstance(modifierClass, [pf]);
		__addModifier(lowerName, newModifier);
	}

	public inline function setPercent(name:String, value:Float, player:Int = -1) {
		var lwr = name.toLowerCase();
		var possiblePercs = percents.get(lwr);
		var generate = possiblePercs == null;
		var percs = generate ? __getPercentTemplate() : possiblePercs;

		if (player == -1)
			for (_ in 0...percs.length)
				percs[_] = value;
		else
			percs[player] = value;

		// if the percent list already was created, we dont need to re-set the list
		if (generate)
			percents.set(lwr, percs);
	}

	public inline function getPercent(name:String, player:Int):Float {
		final percs = percents.get(name.toLowerCase());

		if (percs != null)
			return percs[player];
		return 0;
	}

	@:noCompletion
	inline private function __addModifier(name:String, modifier:Modifier) {
		modifiers.set(name, modifier);

		// update modifier identificators
		if (__idCount > (__sortedIDs.length - 1)) {
			final oldIDs = __sortedIDs.copy();
			__sortedIDs = new Vector<String>(oldIDs.length + 8);

			for (i in 0...oldIDs.length)
				__sortedIDs[i] = oldIDs[i];
		}
		__sortedIDs[__idCount++] = name;

		// update modifier list
		if (__modCount > (__sortedModifiers.length - 1)) {
			final oldMods = __sortedModifiers.copy();
			__sortedModifiers = new Vector<Modifier>(oldMods.length + 8);

			for (i in 0...oldMods.length)
				__sortedModifiers[i] = oldMods[i];
		}
		__sortedModifiers[__modCount++] = modifier;
	}

	@:noCompletion
	inline private function __getPercentTemplate():Vector<Float> {
		final vector = new Vector<Float>(Adapter.instance.getPlayerCount());
		for (i in 0...vector.length)
			vector[i] = 0;
		return vector;
	}
}
