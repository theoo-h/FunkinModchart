package modchart;

class Config {
	/**
	 * Set to false to disable 3d cameras (it also can improve performance)
	 */
	public static var CAMERA3D_ENABLED:Bool = true;

	/**
	 * Rotation Axis Order
	 * 
	 * `Z_Y_X` by default.
	 */
	public static var ROTATION_ORDER:RotationOrder = Z_Y_X;

	/**
	 * Optimize the hold arrows (theoretically it makes the calculation twice as fast)
	 * I don't recommend to use this until your modchart is not complex,
	 * otherwise the holds gonna look BAD. (specially when rotation or complex paths applied)
	 */
	public static var OPTIMIZE_HOLDS:Bool = false;

	/**
	 * The name says it, isn't it?
	 */
	public static var Z_SCALE:Float = 1;
}
