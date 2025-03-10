package modchart.core;

import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
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

	/**
	 * ok so, here's a big change i made:
	 * 
	 * - replaced `StringMap<IntMap<Float>>` with (custom) `Vector<Vector<Float>>`, 
	 *   preallocated to the max size of a 16-bit integer (65536).
	 * - now, when we set a value, we hash the key to a 16-bit integer and 
	 *   store it in the corresponding position of the vector.
	 * - this makes the system way more optimized, 
	 *   cause we're using a more efficient data structure and faster access.
	 */
	private var percents:PercentArray = new PercentArray();

	/**
	 * we don't use it to iterate, so it doens't matter if stringmap isn't to fast
	 */
	private var modifiers:StringMap<Modifier> = new StringMap();

	@:noCompletion private var __sortedModifiers:Vector<Modifier> = new Vector<Modifier>(32);
	@:noCompletion private var __sortedIDs:Vector<String> = new Vector<String>(32);
	@:noCompletion private var __idCount:Int = 0;
	@:noCompletion private var __modCount:Int = 0;

	private var cache:ModifierCache = new ModifierCache();

	private var playfield:PlayField;

	inline private function __loadModifiers() {
		for (cls in COMPILED_MODIFIERS) {
			var name = Type.getClassName(cls);
			name = name.substring(name.lastIndexOf('.') + 1, name.length);
			MODIFIER_REGISTRY.set(name.toLowerCase(), cast cls);
		}
	}

	public function new(playfield:PlayField) {
		this.playfield = playfield;

		__loadModifiers();
	}

	public function postRender() {
		@:privateAccess cache.clear();
	}

	// just render mods with the perspective stuff included
	public inline function getPath(pos:Vector3D, data:ArrowData, ?posDiff:Float = 0, ?allowVis:Bool = true, ?allowPos:Bool = true):ModifierOutput {
		var visuals:Visuals = {};

		/*
			var cacheParams:CacheInstance = {
				lane: data.lane,
				player: data.player,
				pos: data.distance + posDiff,
				isArrow: data.isTapArrow,
				hitten: data.hitten
			};
			var possibleCache = @:privateAccess cache.load(cacheParams);
			if (possibleCache != null) {
				return possibleCache;
		}*/

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
		pos = ModchartUtil.project(pos);
		final output:ModifierOutput = {
			pos: pos,
			visuals: visuals
		};

		// cache.save(cacheParams, output);
		return output;
	}

	/*
		// TODO: add `activeMods` var (for optimization) and percentBackup for editor (can also be helpful for activeMods handling or idk)
		var activeMods:Vector<String>;
		var percentsBackup:StringMap<Vector<Float>>;

		public function refreshActiveMods() {}

		public function refreshPercentBackup() {}

		// discarted until i finish the new modifier system 
	 */
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
		var newModifier = Type.createInstance(modifierClass, [playfield]);
		__addModifier(lowerName, newModifier);
	}

	public inline function setPercent(name:String, value:Float, player:Int = -1) {
		var key = name.toLowerCase();

		var possiblePercs = percents.get(key);
		var generate = possiblePercs == null;
		var percs = generate ? __getPercentTemplate() : possiblePercs;

		if (player == -1)
			for (_ in 0...percs.length)
				percs[_] = value;
		else
			percs[player] = value;

		// if the percent list already was generated, we dont need to set it again
		if (generate)
			percents.set(key, percs);
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

// for some reason, is laggier than generating new parths every frame
/*
	final class ModifierCache {
	public var outputs:ObjectMap<CacheInstance, ModifierOutput> = new ObjectMap();

		private inline function unpackA(packed:Int):Int {
			return packed & 0xFFFF;
		}

		private inline function unpackB(packed:Int):Int {
			return packed >>> 16;
	}
	public function new() {}

	private inline function save(params:CacheInstance, output:ModifierOutput) {
		outputs.set(params, output);
	}

	private inline function load(params:CacheInstance):Null<ModifierOutput> {
		return outputs.get(params);
	}

	private inline function clear() {
		outputs.clear();
	}
	}

	@:structInit
	final class CacheInstance {
	public var lane:Int;
	public var player:Int;

	public var pos:Float;
	public var isA:Bool;
	public var hit:Bool;

	public function new(lane:Int, player:Int, pos:Float, isArrow:Bool, hitten:Bool) {
		this.lane = lane;
		this.player = player;
		this.pos = pos;
		this.isA = isArrow;
		this.hit = hitten;
	}

	inline public function compare(shit:CacheInstance):Bool {
		return (shit.lane == lane && shit.player == player && shit.pos == pos && isA == shit.isA && hit == shit.hit);
	}
	}
 */
// basicly 2d vector with string hashing
// used to store modifier values
final class PercentArray {
	private var vector:Vector<Vector<Float>>;

	public function new() {
		vector = new Vector<Vector<Float>>(Std.int(Math.pow(2, 16))); // preallocate by max 16-bit integer
	}

	private var __lastHashedKey:Int = -1;
	private var __lastKey:String = '';

	// hash the key to a 16-bit integer
	@:noCompletion inline private function __hashKey(key:String):Int {
		if (key == __lastKey)
			return __lastHashedKey;

		var hash:Int = 0;
		for (i in 0...key.length) {
			// hash computation
			hash = ((hash << 5) - hash) + Std.int(key.charCodeAt(i));
		}
		__lastKey = key;
		return __lastHashedKey = (hash & 0xFFFF); // 16-bit hash
	}

	// hash handlers
	@inline public function set(key:String, value:Vector<Float>):Void {
		vector.set(__hashKey(key), value);
	}

	inline public function get(key:String):Vector<Float> {
		return vector.get(__hashKey(key));
	}
}
