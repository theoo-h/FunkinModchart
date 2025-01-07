package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;
import flixel.tweens.FlxEase;

class Beat extends Modifier
{
    private static final getBeatAmp:(Float) -> Float = (currentBeat:Float) -> {
        var beat = currentBeat % 1;
        var amp:Float = 0;
        if (beat <= 0.3)
            amp = FlxEase.quadIn((0.3 - beat) / 0.3) * 0.3;
        else if (beat >= 0.7)
            amp = -FlxEase.quadOut((beat - 0.7) / 0.3) * 0.3;
        var neg = 1;
        if (currentBeat % 2 >= 1)
            neg = -1;
        return amp / 0.3 * neg;
    }
    override public function render(curPos:Vector3D, params:RenderParams)
    {
        final amp = getBeatAmp(params.fBeat) * cos(params.hDiff / 45);
        final beat = amp * ARROW_SIZE / 2;

        curPos.x += beat * (getPercent('beat', params.field) + getPercent('beatX', params.field));
        curPos.y += beat * (getPercent('beatY', params.field));
        curPos.z += beat * (getPercent('beatZ', params.field));

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}