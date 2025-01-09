package modchart.core;

import flixel.FlxSprite;
import flixel.tweens.FlxEase.EaseFunction;
import modchart.events.types.SetEvent;
import modchart.events.Event;
import modchart.events.types.RepeaterEvent;
import modchart.events.types.EaseEvent;
import openfl.geom.Vector3D;
import modchart.core.util.ModchartUtil;
import modchart.core.graphics.ModchartGraphics.ModchartArrowPath;
import modchart.core.graphics.ModchartGraphics.ModchartHoldRenderer;
import modchart.core.graphics.ModchartGraphics.ModchartArrowRenderer;
import modchart.events.EventManager;
import flixel.FlxBasic;

// TODO: make this extend to flxsprite and use parented transformation matrix
class PlayField extends FlxBasic
{
    public var events:EventManager;
	public var modifiers:ModifierGroup;

	private var arrowRenderer:ModchartArrowRenderer;
	private var receptorRenderer:ModchartArrowRenderer;
	private var holdRenderer:ModchartHoldRenderer;
	private var pathRenderer:ModchartArrowPath;

    public function new()
    {
        super();

        this.events = new EventManager(this);
		this.modifiers = new ModifierGroup(this);

        arrowRenderer = new ModchartArrowRenderer(this);
		receptorRenderer = new ModchartArrowRenderer(this);
		holdRenderer = new ModchartHoldRenderer(this);
		pathRenderer = new ModchartArrowPath(this);
    }

    public function registerModifier(name:String, mod:Class<Modifier>)    return modifiers.registerModifier(name, mod);
    public function setPercent(name:String, value:Float, player:Int = -1) return modifiers.setPercent(name, value, player);
    public function getPercent(name:String, player:Int)    				  return modifiers.getPercent(name, player);
    public function addModifier(name:String)		 	 				  return modifiers.addModifier(name);

	public function addEvent(event:Event)
	{
		events.add(event);
	}
    public function set(name:String, beat:Float, value:Float, player:Int = -1):Void
    {
		if (player == -1)
		{
			for (curField in 0...Adapter.instance.getPlayerCount())
				set(name, beat, value, curField);
			return;
		}

        addEvent(new SetEvent(name.toLowerCase(), beat, value, player, events));
    }
    public function ease(name:String, beat:Float, length:Float, value:Float = 1, easeFunc:EaseFunction, player:Int = -1):Void
    {
		if (player == -1)
		{
			for (curField in 0...Adapter.instance.getPlayerCount())
				ease(name, beat, length, value, easeFunc, curField);
			return;
		}

        addEvent(new EaseEvent(name, beat, length, value, easeFunc, player, events));
    }
	public function repeater(beat:Float, length:Float, callback:Event->Void):Void
		addEvent(new RepeaterEvent(beat, length, callback, events));

	public function callback(beat:Float, callback:Event->Void):Void
		addEvent(new Event(beat, callback, events));

    override function update(elapsed:Float):Void
    {
        // Update Event Timeline
        events.update(Adapter.instance.getCurrentBeat());
    }

    override public function draw()
    {
        __drawPlayField();
    }
    var drawCB:Array<{callback:Void->Void, z:Float}> = [];
    private function __drawPlayField()
    {
        drawCB = [];

		var playerItems:Array<Array<Array<FlxSprite>>> = Adapter.instance.getArrowItems();

		// i is player index
		for (i in 0...playerItems.length)
		{
			var curItems:Array<Array<FlxSprite>> = playerItems[i];

			// update view matrix
			ModchartUtil.updateViewMatrix(
				// View Position
				new Vector3D(
					getPercent('viewX', i),
					getPercent('viewY', i),
					getPercent('viewZ', i) + -0.71
				),
				// View Point
				new Vector3D(
					getPercent('viewLookX', i),
					getPercent('viewLookY', i),
					getPercent('viewLookZ', i)
				),
				// up
				new Vector3D(
					getPercent('viewUpX', i),
					1 + getPercent('viewUpY', i),
					getPercent('viewUpZ', i)
				)
			);

			// tap notes
			for (arrow in curItems[1])
			{
				arrow.visible = false;
				arrowRenderer.prepare(arrow);
				drawCB.push({
					callback: () -> {
						arrowRenderer.shift();
					},
					z: arrow._z - 2
				});
			}

			// hold notes
			for (arrow in curItems[2])
			{
				arrow.visible = false;
				holdRenderer.prepare(arrow);
				drawCB.push({
					callback: () -> {
						holdRenderer.shift();
					},
					z: arrow._z - 1
				});
			}

			// receptors
			for (receptor in curItems[0])
			{
				receptor.visible = false;
				receptorRenderer.prepare(receptor);
				if (Manager.instance.renderArrowPaths)
					pathRenderer.prepare(receptor);

				drawCB.push({
					callback: () -> {
						receptorRenderer.shift();
					},
					z: receptor._z
				});
			}
		}

		if (Manager.instance.renderArrowPaths)
			pathRenderer.shift();
    }
}