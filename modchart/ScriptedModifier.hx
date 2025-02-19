package modchart;

// todo: finish that macro lol
// @:build(modchart.core.macros.Macro.buildScriptedFields())
class ScriptedModifier extends Modifier {
	public var renderFunc:(Vector3D, RenderParams) -> Vector3D;
	public var visualsFunc:(Visuals, RenderParams) -> Visuals;

	override public function render(v, r) {
		return renderFunc != null ? renderFunc(v, r) : v;
	}

	override public function visuals(v, r) {
		return visualsFunc != null ? visualsFunc(v, r) : v;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
