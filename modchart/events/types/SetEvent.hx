package modchart.events.types;

import modchart.events.Event;

class SetEvent extends Event {
	public var target:Float;
	public var mod:String;

	public function new(mod:String, beat:Float, target:Float, field:Int, parent:EventManager) {
		this.mod = this.name = mod.toLowerCase();
		this.target = target;
		this.field = field;

		super(beat, (_) -> {
			setModPercent(mod, target, field);

			final prevEvent = parent.getLastEvent(this.mod, this.field, EaseEvent);
			if (prevEvent != null) {
				if (prevEvent.beat != beat)
					prevEvent.fired = true;
				else
					cast(prevEvent, EaseEvent).data.startValue = target;
			}
		}, parent);
	}
}
