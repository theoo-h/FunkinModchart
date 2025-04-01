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
			case ANGLE_NEG_90: -90;
			case ANGLE_270: 270;
			default: 0; // ANGLE_0
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

	inline static public function getHoldUVT(arrow:FlxSprite, subs:Int) {
		var frameAngle = -ModchartUtil.getFrameAngle(arrow);

		var uv = new DrawData<Float>(8 * subs, true, []);

		var frameUV = arrow.frame.uv;
		var frameWidth = frameUV.width - frameUV.x;
		var frameHeight = frameUV.height - frameUV.y;

		var subDivided = 1.0 / subs;

		// if the frame doesnt have rotation, we skip the rotated uv shit
		if ((frameAngle % 360) == 0) {
			for (curSub in 0...subs) {
				var uvOffset = subDivided * curSub;
				var subIndex = curSub * 8;

				uv[subIndex] = uv[subIndex + 4] = frameUV.x;
				uv[subIndex + 2] = uv[subIndex + 6] = frameUV.width;
				uv[subIndex + 1] = uv[subIndex + 3] = frameUV.y + uvOffset * frameHeight;
				uv[subIndex + 5] = uv[subIndex + 7] = frameUV.y + (uvOffset + subDivided) * frameHeight;
			}
			return uv;
		}

		var angleRad = frameAngle * FlxAngle.TO_RAD;
		var cosA = ModchartUtil.cos(angleRad);
		var sinA = ModchartUtil.sin(angleRad);

		var uCenter = frameUV.x + frameWidth * .5;
		var vCenter = frameUV.y + frameHeight * .5;

		// my brain is not braining anymore
		// i give up
		for (curSub in 0...subs) {
			var uvOffset = subDivided * curSub;
			var subIndex = curSub * 8;

			// uv coords before rotation
			var uvCoords = [
				[frameUV.x, frameUV.y + uvOffset * frameHeight], // tl
				[frameUV.width, frameUV.y + uvOffset * frameHeight], // tr
				[frameUV.x, frameUV.y + (uvOffset + subDivided) * frameHeight], // bl
				[frameUV.width, frameUV.y + (uvOffset + subDivided) * frameHeight] // br
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
	@:deprecated('Use Vector3.interpolate instead.')
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
