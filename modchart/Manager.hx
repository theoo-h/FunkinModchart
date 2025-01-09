package modchart;

import modchart.core.PlayField;
import modchart.core.graphics.ModchartGraphics.ModchartRenderer;
import modchart.core.graphics.ModchartGraphics.ModchartArrowPath;
import modchart.core.graphics.ModchartGraphics.ModchartHoldRenderer;
import modchart.core.graphics.ModchartGraphics.ModchartArrowRenderer;

import flixel.FlxBasic;
import flixel.tweens.FlxEase.EaseFunction;

import modchart.modifiers.*;
import modchart.events.*;
import modchart.events.types.*;
import modchart.core.util.ModchartUtil;
import modchart.core.ModifierGroup;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;

@:allow(modchart.core.ModifierGroup)
@:allow(modchart.core.graphics.ModchartGraphics)
class Manager extends FlxBasic
{
    public static var instance:Manager;

	// turn on if u wanna arrow paths
	public var renderArrowPaths:Bool = false;

	public var playfields:Array<PlayField> = [];

    public function new()
    {
        super();

		instance = this;

		Adapter.init();
		Adapter.instance.onModchartingInitialization();

		addPlayfield();
    }

	@:noCompletion
	private function __playfieldChoice(func:PlayField->Void, field:Int = -1)
	{
		if (field != -1)
			func(playfields[field]);
		else
			for (pf in playfields) func(pf);
	}
	public function registerModifier(name:String, mod:Class<Modifier>, field:Int = -1)
		__playfieldChoice((pf) -> pf.registerModifier(name, mod), field);
	public function addModifier(name:String, field:Int = -1)
		__playfieldChoice((pf) -> pf.addModifier(name), field);
	public function setPercent(name:String, value:Float, player:Int = -1, field:Int = -1)
		__playfieldChoice((pf) -> pf.setPercent(name, value, player), field);
	public function getPercent(name:String, player:Int = -1, field:Int)
		__playfieldChoice((pf) -> pf.getPercent(name, player), field);
	public function addEvent(event:Event, field:Int = -1)
		__playfieldChoice((pf) -> pf.addEvent(event), field);
    public function set(name:String, beat:Float, value:Float, player:Int = -1, field:Int = -1)
		__playfieldChoice((pf) -> pf.set(name, beat, value, player), field);
    public function ease(name:String, beat:Float, length:Float, value:Float = 1, easeFunc:EaseFunction, player:Int = -1, field:Int = -1)
		__playfieldChoice((pf) -> pf.ease(name, beat, length, value, easeFunc, player), field);
	public function repeater(beat:Float, length:Float, callback:Event->Void, field:Int = -1)
		__playfieldChoice((pf) -> pf.repeater(beat, length, callback), field);
	public function callback(beat:Float, callback:Event->Void, field:Int = -1)
		__playfieldChoice((pf) -> pf.callback(beat, callback), field);

	public function addPlayfield()
	{
		playfields.push(new PlayField());

		// default mods
		addModifier('reverse', playfields.length - 1);
		addModifier('stealth', playfields.length - 1);
		addModifier('confusion', playfields.length - 1);
		addModifier('skew', playfields.length - 1);

		setPercent('arrowPathAlpha', 1, -1, playfields.length - 1);
		setPercent('arrowPathThickness', 1, -1, playfields.length - 1);
		setPercent('arrowPathDivisions', 1, -1, playfields.length - 1);
		setPercent('rotateHoldY', 1, -1, playfields.length - 1);
	}
    override function update(elapsed:Float):Void
    {
		super.update(elapsed);

		__playfieldChoice(pf -> pf.update(elapsed));
    }

	override function draw():Void
    {
		var drawQueue:Array<{callback:Void->Void, z:Float}> = [];

		__playfieldChoice(pf -> {
			pf.draw();

			@:privateAccess
			drawQueue = drawQueue.concat(pf.drawCB);
		});

		drawQueue.sort((a, b) -> {
			return Math.round(b.z - a.z);
		});

		for (item in drawQueue) item.callback();
    }

	override function destroy():Void
	{
		super.destroy();

		__playfieldChoice(pf -> pf.destroy());
	}

    public static var HOLD_SIZE:Float = 50 * 0.7;
    public static var HOLD_SIZEDIV2:Float = (50 * 0.7) * 0.5;
    public static var ARROW_SIZE:Float = 160 * 0.7;
    public static var ARROW_SIZEDIV2:Float = (160 * 0.7) * 0.5;
}