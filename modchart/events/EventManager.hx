package modchart.events;

import haxe.ds.StringMap;
import modchart.core.PlayField;
import modchart.core.util.ModchartUtil;
import modchart.events.types.*;

@:allow(modchart.events.Event)
class EventManager {
	private var table:StringMap<Array<Array<Event>>> = new StringMap();
	private var eventList:Array<Event> = [];

	private var pf:PlayField;

	public function new(pf:PlayField) {
		this.pf = pf;
	}

	public function add(event:Event) {
		if (event.name != null) {
			final lwr = event.name.toLowerCase();

			if (table.get(lwr) == null)
				table.set(lwr, []);
			if (table.get(lwr)[event.field] == null)
				table.get(lwr)[event.field] = [];

			table.get(lwr)[event.field].push(event);
		}

		eventList.push(event);

		sortEvents();
	}

	public function update(curBeat:Float) {
		for (ev in eventList) {
			ev.active = false;

			if (ev.beat >= curBeat)
				continue;

			ev.active = true;
			ev.update(curBeat);
		}
	}

	public function getLastEventBefore(event:Event) {
		final playerEvents = table.get(event.name.toLowerCase());
		final eventList = playerEvents != null ? playerEvents[event.field] : null;
		if (eventList != null) {
			final lastIndex = eventList.indexOf(event);
			if (lastIndex > 0) {
				final possibleEvent = eventList[lastIndex - 1];
				if (possibleEvent != null)
					return possibleEvent;
			}
		}
		return null;
	}

	private function sortEvents() {
		for (modTab in table.iterator()) {
			for (events in modTab) {
				events.sort(__sortFunction);
			}
		}
	}

	@:noCompletion
	private final __sortFunction:(Event, Event) -> Int = (a, b) -> {
		return Math.floor(a.beat - b.beat);
	};
}
