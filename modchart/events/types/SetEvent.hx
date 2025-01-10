package modchart.events.types;

import modchart.events.Event;

class SetEvent extends Event {
	public function new(mod:String, beat:Float, target:Float, field:Int, parent:EventManager) {
		this.name = mod;
		this.target = target;
		this.field = field;

		super(beat, (_) -> {
			setModPercent(mod, target, field);
		}, parent);
	}
}
