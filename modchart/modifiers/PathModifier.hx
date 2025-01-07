package modchart.modifiers;

import modchart.core.PlayField;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;
import haxe.ds.Vector;

/**
 * An Path Manager for FunkinModchart
 * 
 * TODO: Make the trajectory interpolation LINEAR
 * @author TheoDev
 */
@:skipModifier
class PathModifier extends Modifier
{
	private var __path:Vector<PathNode>;
	private var __pathBound:Float = 1500;

	public var pathOffset:Vector3D = new Vector3D();

	// TODO
	public var pathEase:Float->Float = (t) -> t;
	// set this to false if wanna extra performance
	public var pathLinear:Bool = false;
	
	public function new(pf:PlayField, path:Array<PathNode>)
	{
		super(pf);

		loadPath(path);
	}

	public function loadPath(newPath:Array<PathNode>)
	{
		__path = Vector.fromArrayCopy(newPath);
	}

	public function computePath(pos:Vector3D, params:RenderParams, percent:Float)
	{
		if (__path.length <= 0)
			return pos;
		if (__path.length == 1)
			return new Vector3D(__path[0].x, __path[0].y, __path[0].z);

        var nodeProgress = (__path.length - 1) * (Math.abs(Math.min(__pathBound, params.hDiff)) * (1 / __pathBound));
        var thisNodeIndex = Math.floor(nodeProgress);
        var nextNodeIndex = Math.floor(Math.min(thisNodeIndex + 1, __path.length - 1));
        var nextNodeRatio = nodeProgress - thisNodeIndex;

		return ModchartUtil.lerpVector3D(pos, new Vector3D(
			FlxMath.lerp(__path[thisNodeIndex].x, __path[nextNodeIndex].x, nextNodeRatio),
			FlxMath.lerp(__path[thisNodeIndex].y, __path[nextNodeIndex].y, nextNodeRatio),
			FlxMath.lerp(__path[thisNodeIndex].z, __path[nextNodeIndex].z, nextNodeRatio)).add(pathOffset),
		percent);
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
@:structInit
class PathNode
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
}