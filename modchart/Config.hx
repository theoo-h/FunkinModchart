package modchart;

/**
 * Configuration settings for modchart behavior.
 *
 * This class contains various static variables that control rendering,
 * performance optimizations, and visual settings for modcharts.
 * Adjust these settings to customize how elements behave and render.
 */
class Config {
	/**
	 * Enables or disables 3D cameras.
	 *
	 * Setting this to `false` will disable 3D camera functionality, which may improve performance.
	 * When disabled, all 3D-related transformations and rendering will be skipped.
	 *
	 * Default: `true` (3D cameras enabled).
	 */
	public static var CAMERA3D_ENABLED:Bool = true;

	/**
	 * Defines the order of rotation axes.
	 *
	 * Determines the sequence in which rotations are applied around the X, Y, and Z axes.
	 * Different orders can produce different final orientations due to rotational dependency.
	 *
	 * Default: `Z_Y_X` (Rotates around the X-axis last).
	 */
	public static var ROTATION_ORDER:RotationOrder = Z_Y_X;

	/**
	 * Optimizes the rendering of hold arrows.
	 *
	 * Theoretically, this makes calculations twice as fast by reducing redundant computations.
	 * However, it is not recommended for complex modcharts, as it may cause holds to look waggy,
	 * especially when using modifiers that use rotation or complex path operations>
	 *
	 * Default: `false` (Regular hold rendering).
	 */
	public static var OPTIMIZE_HOLDS:Bool = false;

	/**
	 * Scales the Z-axis values.
	 *
	 * This value is used to multiply the Z coordinate, effectively scaling depth.
	 * A higher value increases the perceived depth, while a lower value flattens it.
	 *
	 * Default: `1` (No scaling applied).
	 */
	public static var Z_SCALE:Float = 1;

	/**
	 * Ignores or renders the arrow path lines.
	 *
	 * When enabled, performance will be affected
	 * due to path computation.
	 * 
	 * Default: `false` (Disabled for performance).
	 */
	public static var RENDER_ARROW_PATHS:Bool = false;

	/**
	 * Extra configurations for the Arrow Paths.
	 */
	public static var ARROW_PATHS_CONFIG:ArrowPathConfig = {
		APPLY_COLOR: false,
		APPLY_ALPHA: true,
		APPLY_DEPTH: true,
		APPLY_SCALE: false,
		RESOLUTION: 1,
		LENGTH: 0
	};

	/**
	 * Scales the hold end size.
	 * 
	 * Default: `1` (no scaling applied).
	 */
	public static var HOLD_END_SCALE:Float = 1;

	/**
	 * Prevents scaling the hold ends. (Some people doens't like that lol)
	 * 
	 * **WARNING**: Performance may be affected if there's too much
	 * hold arrows at screen. (it basicly uses one extra `getPath()` call)
	 * 
	 * Default: `false`
	 */
	public static var PREVENT_SCALED_HOLD_END:Bool = false;

	/**
	 * Enables or disables column-specific modifiers.
	 *
	 * Disabling this may improve performance by
	 * reducing the number of `getPercent()` calls.
	 *
	 * **WARNING**: This does **not** directly affect any modifier.
	 * It only applies to *built-in modifiers*.
	 * Custom modifiers must manually check
	 * this config value for compatibility.
	 *
	 * Default: `true`
	 */
	public static var COLUMN_SPECIFIC_MODIFIERS:Bool = true;
}

typedef ArrowPathConfig = {
	/**
	 * Line alpha gets affected
	 * by color/glow modifiers.
	 */
	APPLY_COLOR:Bool,

	/**
	 * Line alpha gets affected
	 * by alpha modifiers.
	 */
	APPLY_ALPHA:Bool,

	/**
	 * Thickness gets affected by Z.
	 */
	APPLY_DEPTH:Bool,

	/**
	 * Thickness gets affected by arrow scale.
	 */
	APPLY_SCALE:Bool,

	/**
	 * "Resulution" multiplier of arrow paths.
	 * Higher value = More divisions = Smoother path.
	 * **WARNING**: Can't be zero or it will CRASH.
	 */
	RESOLUTION:Float,

	/**
	 * Path lines length addition.
	 */
	LENGTH:Int
}
