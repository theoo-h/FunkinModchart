package modchart.backend.graphics;

#if !macro
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import haxe.ds.Vector as NativeVector;
import modchart.backend.graphics.ModchartRenderer.FMDrawInstruction;
import modchart.backend.graphics.ModchartRenderer;
import modchart.engine.modifiers.ModifierGroup.ModifierOutput;
import openfl.Vector;
import openfl.display.GraphicsPathCommand;
import openfl.display.Shape;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
#end
