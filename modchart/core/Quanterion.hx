package modchart.core;

import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

@:publicFields
final class Quaternion {
	var x:Float;
	var y:Float;
	var z:Float;
	var w:Float;

	// This could be inline, to make local quaternions abstracted away
	function new(x:Float, y:Float, z:Float, w:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	@:pure
	function multiply(q:Quaternion):Quaternion {
		return new Quaternion(w * q.x
			+ x * q.w
			+ y * q.z
			- z * q.y, w * q.y
			- x * q.z
			+ y * q.w
			+ z * q.x, w * q.z
			+ x * q.y
			- y * q.x
			+ z * q.w,
			w * q.w
			- x * q.x
			- y * q.y
			- z * q.z);
	}

	@:noDebug
	inline function multiplyInPlace(q:Quaternion):Void {
		var x = this.x;
		var y = this.y;
		var z = this.z;
		var w = this.w;

		this.x = w * q.x + x * q.w + y * q.z - z * q.y;
		this.y = w * q.y - x * q.z + y * q.w + z * q.x;
		this.z = w * q.z + x * q.y - y * q.x + z * q.w;
		this.w = w * q.w - x * q.x - y * q.y - z * q.z;
	}

	@:noDebug
	inline function multiplyInPlaceInverted(q:Quaternion):Void {
		var x = -this.x;
		var y = -this.y;
		var z = -this.z;
		var w = this.w;

		this.x = w * q.x + x * q.w + y * q.z - z * q.y;
		this.y = w * q.y - x * q.z + y * q.w + z * q.x;
		this.z = w * q.z + x * q.y - y * q.x + z * q.w;
		this.w = w * q.w - x * q.x - y * q.y - z * q.z;
	}

	@:pure
	inline function rotateVector(v:Vector3D):Vector3D {
		var qVec = new Quaternion(v.x, v.y, v.z, 0);
		qVec.multiplyInPlace(this);
		qVec.multiplyInPlaceInverted(this);
		return new Vector3D(qVec.x, qVec.y, qVec.z, 0);
	}

	@:pure
	static function fromAxisAngle(axis:Vector3D, angleRad:Float):Quaternion {
		var sinHalfAngle = ModchartUtil.sin(angleRad * .5);
		var cosHalfAngle = ModchartUtil.cos(angleRad * .5);
		return new Quaternion(axis.x * sinHalfAngle, axis.y * sinHalfAngle, axis.z * sinHalfAngle, cosHalfAngle);
	}
}
