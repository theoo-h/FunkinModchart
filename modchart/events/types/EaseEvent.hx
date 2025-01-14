package modchart.events.types;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import modchart.events.Event;

typedef EaseData = {
	var startBeat:Float;
	var endBeat:Float;

	var beatLength:Float;

	var ease:EaseFunction;
}

class EaseEvent extends Event {
	public var data:EaseData;

	public function new(mod:String, beat:Float, len:Float, target:Float, ease:EaseFunction, field:Int, parent:EventManager) {
		this.name = mod;
		this.field = field;

		this.data = {
			startBeat: beat,
			endBeat: beat + len,
			beatLength: len,
			ease: ease != null ? ease : FlxEase.linear
		};

		this.target = target;

		super(beat, (_) -> {}, parent, true);
	}

	var entryPerc:Null<Float> = null;

	override function update(curBeat:Float) {
		if (fired)
			return;

		if (curBeat < data.endBeat) {
			if (entryPerc == null) {
				// this fixed A LOT of visual issues when convining eases and sets
				// based on schmovin timeline
				final possibleLastEvent = parent.getLastEventBefore(this);

				if (possibleLastEvent != null)
					entryPerc = possibleLastEvent.target;
				else
					entryPerc = getModPercent(name, field);
			}

			var progress = (curBeat - data.startBeat) / (data.endBeat - data.startBeat);
			// maybe we should make it use bound?
			var out = FlxMath.lerp(entryPerc, target, data.ease(progress));
			setModPercent(name, out, field);
			fired = false;
		} else if (curBeat >= data.endBeat) {
			fired = true;

			// we're using the ease function bc it may dont return 1
			setModPercent(name, data.ease(1) * target, field);
		}
	}
}
