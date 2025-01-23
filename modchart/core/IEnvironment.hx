package modchart.core;

interface IEnvironment {
	public var parent:Manager;

	public function setup(parent:Manager):Void;
	public function dispose():Void;
}
