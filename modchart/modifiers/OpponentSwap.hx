package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;
import modchart.core.util.ModchartUtil;

class OpponentSwap extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var distX = WIDTH / getPlayercount();
		curPos.x -= distX * ModchartUtil.sign((params.field + 1) * 2 - 3) * getPercent('opponentSwap', params.field);
        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('opponentSwap', params.field) != 0;

}