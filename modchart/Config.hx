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
}
