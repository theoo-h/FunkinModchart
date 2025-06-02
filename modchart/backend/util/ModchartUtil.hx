package modchart.backend.util;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import haxe.ds.Vector;
import openfl.geom.Matrix3D;

using StringTools;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:keep class ModchartUtil {
	// pain (we need this if we want support for sprite sheet packer)
	@:pure
	inline public static function getFrameAngle(spr:FlxSprite):Float {
		return switch (spr.frame.angle) {
			case ANGLE_90: 90;
			case ANGLE_270 | ANGLE_NEG_90: 270;
			default: 0; // ANGLE_0d
		}
	}

	@:pure @:noDebug
	inline public static function rotate3DVector(vec:Vector3, angleX:Float, angleY:Float, angleZ:Float):Vector3 {
		if (angleX == 0 && angleY == 0 && angleZ == 0)
			return vec;

		final RAD = FlxAngle.TO_RAD;
		final quatX = Quaternion.fromAxisAngle(Vector3D.X_AXIS, angleX * RAD);
		final quatY = Quaternion.fromAxisAngle(Vector3D.Y_AXIS, angleY * RAD);
		final quatZ = Quaternion.fromAxisAngle(Vector3D.Z_AXIS, angleZ * RAD);

		// this is confusing, X_Y_Z is done like this:
		// OUT = Z;
		// OUT *= Y
		// OUT *= X
		// But it feels wrong, so investigate this
		switch (Config.ROTATION_ORDER) {
			case Z_X_Y:
				quatY.multiplyInPlace(quatX);
				quatY.multiplyInPlace(quatZ);
				return quatY.rotateVector(vec);
			case X_Y_Z:
				quatZ.multiplyInPlace(quatY);
				quatZ.multiplyInPlace(quatX);
				return quatZ.rotateVector(vec);
			case X_Z_Y:
				quatY.multiplyInPlace(quatZ);
				quatY.multiplyInPlace(quatX);
				return quatY.rotateVector(vec);
			case Y_X_Z:
				quatZ.multiplyInPlace(quatX);
				quatZ.multiplyInPlace(quatY);
				return quatZ.rotateVector(vec);
			case Y_Z_X:
				quatX.multiplyInPlace(quatZ);
				quatX.multiplyInPlace(quatY);
				return quatX.rotateVector(vec);
			case Z_Y_X:
				quatX.multiplyInPlace(quatY);
				quatX.multiplyInPlace(quatZ);
				return quatX.rotateVector(vec);
			case X_Y_X:
				quatX.multiplyInPlace(quatY);
				quatX.multiplyInPlace(quatX);
				return quatX.rotateVector(vec);
			case X_Z_X:
				quatX.multiplyInPlace(quatZ);
				quatX.multiplyInPlace(quatX);
				return quatX.rotateVector(vec);
			case Y_X_Y:
				quatY.multiplyInPlace(quatX);
				quatY.multiplyInPlace(quatY);
				return quatY.rotateVector(vec);
			case Y_Z_Y:
				quatY.multiplyInPlace(quatZ);
				quatY.multiplyInPlace(quatY);
				return quatY.rotateVector(vec);
			case Z_X_Z:
				quatZ.multiplyInPlace(quatX);
				quatZ.multiplyInPlace(quatZ);
				return quatZ.rotateVector(vec);
			case Z_Y_Z:
				quatZ.multiplyInPlace(quatY);
				quatZ.multiplyInPlace(quatZ);
				return quatZ.rotateVector(vec);
		}
	}

	inline static public function getHoldUVT(arrow:FlxSprite, subs:Int, ?vector:DrawData<Float>) {
		var frameAngle = -ModchartUtil.getFrameAngle(arrow);

		var uv:DrawData<Float> = null;

		if (vector != null && vector.length >= 8 * subs)
			uv = vector;
		else
			uv = new DrawData<Float>(8 * subs, true, []);

		#if (flixel < "6.0.0")
		var frameUV:FlxUVRect = cast arrow.frame.uv;
		#else
		var frameUV = arrow.frame.uv;
		#end
		var frameWidth = frameUV.top - frameUV.left;
		var frameHeight = frameUV.bottom - frameUV.right;

		var subDivided = 1.0 / subs;

		// if the frame doesnt have rotation, we skip the rotated uv shit
		if ((frameAngle % 360) == 0) {
			for (curSub in 0...subs) {
				var uvOffset = subDivided * curSub;
				var subIndex = curSub * 8;

				uv[subIndex] = uv[subIndex + 4] = frameUV.left;
				uv[subIndex + 2] = uv[subIndex + 6] = frameUV.top;
				uv[subIndex + 1] = uv[subIndex + 3] = frameUV.right + uvOffset * frameHeight;
				uv[subIndex + 5] = uv[subIndex + 7] = frameUV.right + (uvOffset + subDivided) * frameHeight;
			}
			return uv;
		}

		var angleRad = frameAngle * (Math.PI / 180);
		var cosA = ModchartUtil.cos(angleRad);
		var sinA = ModchartUtil.sin(angleRad);

		var uCenter = frameUV.left + frameWidth * .5;
		var vCenter = frameUV.right + frameHeight * .5;

		// my brain is not braining anymore
		// i give up
		for (curSub in 0...subs) {
			var uvOffset = subDivided * curSub;
			var subIndex = curSub * 8;

			// uv coords before rotation
			var uvCoords = [
				[frameUV.left, frameUV.right + uvOffset * frameHeight], // tl
				[frameUV.top, frameUV.right + uvOffset * frameHeight], // tr
				[frameUV.left, frameUV.right + (uvOffset + subDivided) * frameHeight], // bl
				[frameUV.top, frameUV.right + (uvOffset + subDivided) * frameHeight] // br
			];

			// apply rotation
			for (i in 0...4) {
				var u = uvCoords[i][0] - uCenter; // x
				var v = uvCoords[i][1] - vCenter; // y

				var uRot = u * cosA - v * sinA;
				var vRot = u * sinA + v * cosA;

				uv[subIndex + i * 2] = uRot + uCenter;
				uv[subIndex + i * 2 + 1] = vRot + vCenter;
			}
		}

		return uv;
	}

	/**
		map should be. [
			top left x,  top left y,
			top right x, top right y,
			bot left x,  bot left y
			bot right x, bot right y
		]
	 */
	inline static public function appendUVRotation(map:Array<Float>, angle:Float) {
		return map;
	}

	// gonna keep this shits inline cus are basic functions

	public static inline function getHalfPos():Vector3 {
		return new Vector3(Manager.ARROW_SIZEDIV2, Manager.ARROW_SIZEDIV2, 0, 0);
	}

	@:pure
	public static inline function sign(x:Int)
		return x == 0 ? 0 : x > 0 ? 1 : -1;

	@:pure
	public static inline function clamp(n:Float, l:Float, h:Float) {
		if (n < l)
			return l;
		if (n > h)
			return h;
		return n;
	}

	@:pure
	public static inline function sin(num:Float)
		return FlxMath.fastSin(num);

	@:pure
	public static inline function cos(num:Float)
		return FlxMath.fastCos(num);

	@:pure
	public static inline function tan(num:Float)
		return sin(num) / cos(num);

	@:pure
	@:deprecated("Use Vector3.interpolate instead.")
	inline public static function lerpVector3D(start:Vector3, end:Vector3, ratio:Float) {
		if (ratio == 0)
			return start;
		if (ratio == 1)
			return end;

		final diff = end.subtract(start);
		diff.scaleBy(ratio);

		return start.add(diff);
	}

	public static function coolTextFile(path:String):Array<String> {
		var trim:String;
		return [
			for (line in openfl.utils.Assets.getText(path).split("\n"))
				if ((trim = line.trim()) != "" && !trim.startsWith("#")) trim
		];
	}
}

#if (flixel < "6.0.0")
/**
 * FlxRect, but instead of `x`, `y`, `width` and `height`, it takes a `left`, `right`, `top` and
 * `bottom`. This is for optimization reasons, to reduce arithmetic when drawing vertices
 */
@:forward(put)
abstract FlxUVRect(FlxRect) from FlxRect to flixel.util.FlxPool.IFlxPooled
{
	public var left(get, set):Float;
	inline function get_left():Float { return this.x; }
	inline function set_left(value):Float { return this.x = value; }
	
	/** Top */
	public var right(get, set):Float;
	inline function get_right():Float { return this.y; }
	inline function set_right(value):Float { return this.y = value; }
	
	/** Right */
	public var top(get, set):Float;
	inline function get_top():Float { return this.width; }
	inline function set_top(value):Float { return this.width = value; }
	
	/** Bottom */
	public var bottom(get, set):Float;
	inline function get_bottom():Float { return this.height; }
	inline function set_bottom(value):Float { return this.height = value; }
	
	public inline function set(l, t, r, b)
	{
		this.set(l, t, r, b);
	}
	
	public inline function copyTo(uv:FlxUVRect)
	{
		uv.set(left, top, right, bottom);
	}
	
	public inline function copyFrom(uv:FlxUVRect)
	{
		set(uv.left, uv.top, uv.right, uv.bottom);
	}
	
	public static function get(l = 0.0, t = 0.0, r = 0.0, b = 0.0)
	{
		return FlxRect.get(l, t, r, b);
	}
}
#end