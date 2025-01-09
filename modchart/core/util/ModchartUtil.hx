package modchart.core.util;

import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import modchart.Manager;

using StringTools;

@:keep
class ModchartUtil
{
	private static var __viewMatrix:Matrix3D = new Matrix3D();

	public static function updateViewMatrix(position:Vector3D, lookAt:Vector3D, up:Vector3D)
	{
		__viewMatrix.pointAt(position, lookAt, up);
		return __viewMatrix;
	}
	public static function applyViewMatrix(vector:Vector3D)
	{
		var translatedVector = __viewMatrix.transformVector(vector.subtract(new Vector3D(FlxG.width * .5, FlxG.height * .5)));
		return translatedVector.add(new Vector3D(FlxG.width * .5, FlxG.height * .5));
	}
    inline public static function rotate(x:Float, y:Float, angle:Float)
    {
		if ((angle % 360) == 0)
			return [x, y];

        final sin = ModchartUtil.sin(angle);
        final cos = ModchartUtil.cos(angle);

        return [x * cos - y * sin, x * sin + y * cos];
    };
    inline public static function rotate3DVector(vec:Vector3D, angleX:Float, angleY:Float, angleZ:Float)
	{
		final RAD = Math.PI / 180;
		if ((angleX + angleY + angleZ) == 0)
			return vec;

		final rotateZ = rotate(vec.x, vec.y, angleZ * RAD);
		final offZ = new Vector3D(rotateZ[0], rotateZ[1], vec.z);

		final rotateY = rotate(offZ.x, offZ.z, angleY * RAD);
		final offY = new Vector3D(rotateY[0], offZ.y, rotateY[1]);

		final rotateX = rotate(offY.z, offY.y, angleX * RAD);
		final offX = new Vector3D(offY.x, rotateX[1], rotateX[0]);

		return offX;
	}

	inline static final near:Int = 0;
	inline static final far:Int = 1;
	inline static final range:Int = -1;

	// stolen & improved from schmovin (Camera3DTransforms)
	inline static public function perspective(pos:Vector3D, ?origin:Vector3D)
	{
		final fov = Math.PI / 2;

		if (origin == null)
			origin = new Vector3D(FlxG.width / 2, FlxG.height / 2);
		pos.decrementBy(origin);

		final worldZ = Math.min(pos.z - 1, 0); // bound to 1000 z

		final halfFovTan = 1 / ModchartUtil.tan(fov / 2);
		final rangeDivision = 1 / range;

		final projectionScale = (near + far) * rangeDivision;
		final projectionOffset = 2 * near * (far * rangeDivision);
		final projectionZ = projectionScale * worldZ + projectionOffset;

		final projectedPos = new Vector3D(pos.x * halfFovTan, pos.y * halfFovTan, projectionZ * projectionZ, projectionZ);
		projectedPos.project();
		projectedPos.incrementBy(origin);
		return projectedPos;
	}

	inline static public function getHoldVertex(upper:Array<Vector3D>, lower:Array<Vector3D>)
	{
		return [
			upper[0].x, upper[0].y,
			upper[1].x, upper[1].y,
			lower[0].x, lower[0].y,
			lower[1].x, lower[1].y
		];
	}
	inline static public function getHoldUVT(arrow:FlxSprite, subs:Int)
	{
		var uv = new DrawData<Float>(8 * subs, true, []);

		var frameUV = arrow.frame.uv;
		var frameHeight = frameUV.height - frameUV.y;

		var subDivided = 1.0 / subs;

		for (curSub in 0...subs)
		{
			var uvOffset = subDivided * curSub;
			var subIndex = curSub * 8;

			uv[subIndex] = uv[subIndex + 4] = frameUV.x;
			uv[subIndex + 2] = uv[subIndex + 6] = frameUV.width;
			uv[subIndex + 1] = uv[subIndex + 3] = frameUV.y + uvOffset * frameHeight;
			uv[subIndex + 5] = uv[subIndex + 7] = frameUV.y + (uvOffset + subDivided) * frameHeight;
		}

		return uv;
	}
	// gonna keep this shits inline cus are basic functions
	public static inline function getHalfPos():Vector3D
	{
		return new Vector3D(Manager.ARROW_SIZEDIV2, Manager.ARROW_SIZEDIV2, 0, 0);
	}
	// dude wtf it works
	public inline static function sign(x:Int)
	{
		return (x >> 31) | ((x != 0) ? 1 : 0);
	}
	public inline static function clamp(n:Float, l:Float, h:Float)
	{
		return Math.min(Math.max(n, l), h);
	}

	// no way guys, regular sinus is faster than fastSin :surprised:
    // (in hl fastSin is still faster than regular sin)
    // https://github.com/HaxeFlixel/flixel/issues/3215#issuecomment-2226858302
    // https://try.haxe.org/#847eac2B
    public static inline function sin(num:Float)
        return #if !hl Math.sin(num) #else FlxMath.fastSin(num) #end;
    public static inline function cos(num:Float)
        return #if !hl Math.cos(num) #else FlxMath.fastCos(num) #end;
    public static inline function tan(num:Float)
        return #if !hl Math.tan(num) #else sin(num) / cos(num) #end;

    inline public static var HOLD_SIZE:Float = 44 * 0.7;
	inline public static var ARROW_SIZE:Float = 160 * 0.7;
    inline public static var ARROW_SIZEDIV2:Float = (160 * 0.7) * 0.5;

	inline public static function lerpVector3D(start:Vector3D, end:Vector3D, ratio:Float)
	{
		final diff = end.subtract(start);
		diff.scaleBy(ratio);

		return start.add(diff);
	}

	inline public static function applyVectorZoom(vec:Vector3D, zoom:Float)
	{
		if(zoom != 1){
			var centerX = FlxG.width * 0.5;
			var centerY = FlxG.height * 0.5;

			vec.x = (vec.x - centerX) * zoom + centerX;
			vec.y = (vec.y - centerY) * zoom + centerY;
		}

		return vec;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var trim:String;
		return [for(line in openfl.utils.Assets.getText(path).split("\n")) if ((trim = line.trim()) != "" && !trim.startsWith("#")) trim];
	}
}