package modchart.standalone;

class Adapter {
	public static var instance:IAdapter;
	private static var ENGINE_NAME:String = haxe.macro.Compiler.getDefine("FM_ENGINE");

	public static function init() {
		if (instance != null)
			return;

		final possibleClientName = ENGINE_NAME.substr(0, 1).toUpperCase() + ENGINE_NAME.substr(1).toLowerCase();
		final client = Type.createInstance(Type.resolveClass('modchart.standalone.adapters.${ENGINE_NAME.toLowerCase()}.' + possibleClientName), []);

		trace('modchart.standalone.adapters.${ENGINE_NAME.toLowerCase()}.' + possibleClientName);

		if (client == null)
			throw 'Client not founded for $ENGINE_NAME';

		instance = client;
	}
}
