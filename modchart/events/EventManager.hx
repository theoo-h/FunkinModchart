package modchart.events;

import modchart.core.PlayField;
import modchart.core.util.ModchartUtil;
import modchart.events.types.*;

import haxe.ds.StringMap;

@:allow(modchart.events.Event)
class EventManager
{
	private var table:StringMap<Array<Array<Event>>> = new StringMap();
	private var pf:PlayField;

    public function new(pf:PlayField)
	{
		this.pf = pf;
	}

    public function add(event:Event)
    {
		if (table.get(event.name) == null)
			table.set(event.name, [[], []]);

		table.get(event.name)[event.field].push(event);

		sortEvents();
    }
    public function update(curBeat:Float)
    {
		for (fieldTable in table.iterator())
		{
			for (events in fieldTable)
			{
				for (ev in events)
				{
					ev.active = false;

					if (ev.beat >= curBeat)
						continue;
					else
						ev.active = true;

					ev.update(curBeat);
	
					if (ev.fired)
						events.remove(ev);
				}
			} 
		}
    }
	public function getLastEvent<T>(name:String, field:Int, evClass:T)
	{
		var list = table.get(name)[field];
		var idx = list.length;

		while (idx >= 0)
		{
			final ev = list[idx];
			
			if (Std.isOfType(ev, evClass) && ev.field == field && ev.active)
				return ev;

			idx--;
		}

		return null;
	}
    private function sortEvents()
    {
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