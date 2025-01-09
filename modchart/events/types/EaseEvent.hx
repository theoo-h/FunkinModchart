package modchart.events.types;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import modchart.events.Event;

typedef EaseData = {
    var startValue:Null<Float>;
    var targetValue:Float;

    var startBeat:Float;
    var endBeat:Float;
    
    var beatLength:Float;

    var ease:EaseFunction;
}
class EaseEvent extends Event
{
    public var mod:String;
    public var data:EaseData;

    public function new(mod:String, beat:Float, len:Float, target:Float, ease:EaseFunction, field:Int, parent:EventManager)
    {
        this.mod = this.name = mod.toLowerCase();
		this.field = field;

        this.data = {
            startValue: null,
            targetValue: target,
            startBeat: beat,
            endBeat: beat + len,
            beatLength: len,
            ease: ease != null ? ease : FlxEase.linear
        };

        super(beat, (_) -> {}, parent, true);
    }
    override function update(curBeat:Float)
    {
		if (fired)
			return;
		
		if (data.startValue == null) {
			data.startValue = getModPercent(this.mod, this.field);

			// prevent overlapping
			final prevEvent = parent.getLastEvent(this.mod, this.field, EaseEvent);
			if (prevEvent != null && prevEvent != this)
				prevEvent.fired = true;
		}
		if (data.ease == null)
			data.ease = FlxEase.linear;

		if (curBeat < data.endBeat)
		{
            // this is easier than u think
			var progress = (curBeat - data.startBeat) / (data.endBeat - data.startBeat);
            var out = FlxMath.lerp(data.startValue, data.targetValue, data.ease(progress));
			setModPercent(mod, out, field);
			fired = false;
		}
		else if (curBeat >= data.endBeat)
		{
			fired = true;
			
			setModPercent(mod, data.ease(1) * data.targetValue, field);
		}
    }
}