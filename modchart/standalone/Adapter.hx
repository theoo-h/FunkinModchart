package modchart.standalone;

import haxe.xml.Fast;
import flixel.FlxSprite;
import flixel.FlxCamera;

class Adapter
{
    public static var instance(default, null):IAdapter;
    private static var ENGINE_NAME:String = haxe.macro.Compiler.getDefine('FM_ENGINE');

    public static function init()
    {
        if (instance != null)
            return;
        
        final possibleClientName = ENGINE_NAME.substr(0, 1).toUpperCase() + ENGINE_NAME.substr(1).toLowerCase();
        final client = Type.createInstance(Type.resolveClass('modchart.standalone.adapters.' + possibleClientName), []);

        trace('modchart.standalone.adapters.' + possibleClientName);

        if (client == null)
            throw 'Client not founded for $ENGINE_NAME';
        
        instance = client;
    }
}
/*
class EAdapter implements IAdapter
{
    public function onModchartingInitialization():Void {}
    
    // Song-related stuff
    public function getSongPosition():Float        {return 0;}
    public function getStaticCrochet():Float       {return 0;}
    public function getCurrentBeat():Float         {return 0;}
    public function getCurrentScrollSpeed():Float  {return 0;}

    // Arrow-related stuff
    public function getDefaultReceptorX(lane:Int, player:Int):Float {return 0;}
    public function getDefaultReceptorY(lane:Int, player:Int):Float {return 0;}
    public function getTimeFromArrow(arrow:FlxSprite):Float         {return 0;}
    public function isTapNote(sprite:FlxSprite):Bool                {return false;}
    public function isHoldEnd(sprite:FlxSprite):Bool                {return false;}
    public function arrowHitted(sprite:FlxSprite):Bool              {return false;}

    public function getLaneFromArrow(sprite:FlxSprite):Int          {return 0;}
    public function getPlayerFromArrow(sprite:FlxSprite):Int        {return 0;}

    public function getKeycount():Int       {return 0;};
    public function getPlayercount():Int    {return 0;};

    public function getArrowCamera():Array<FlxCamera> {return [];};

    public function getHoldSubdivitions():Int  {return 0;};

    public function getArrowItems():Array<Array<Array<FlxSprite>>> {return [];};
}*/
interface IAdapter
{
    public function onModchartingInitialization():Void;
    
    // Song-related stuff
    public function getSongPosition():Float;        // Current song position
    // public function getCrochet():Float           // Current beat crochet
    public function getStaticCrochet():Float;       // Beat crochet without bpm changes
    public function getCurrentBeat():Float;         // Current beat
    public function getCurrentScrollSpeed():Float;  // Current arrow scroll speed

    // Arrow-related stuff
    public function getDefaultReceptorX(lane:Int, player:Int):Float; // Get default strum x position
    public function getDefaultReceptorY(lane:Int, player:Int):Float; // Get default strum y position
    public function getTimeFromArrow(arrow:FlxSprite):Float;         // Get strum time for arrow
    public function isTapNote(sprite:FlxSprite):Bool;                // If the sprite is an arrow, return true, if it is an receptor/strum, return false
    public function isHoldEnd(sprite:FlxSprite):Bool;                // If its the hold end
    public function arrowHitted(sprite:FlxSprite):Bool;              // If the arrow was hitted

    public function getLaneFromArrow(sprite:FlxSprite):Int;          // Get lane/note data from arrow
    public function getPlayerFromArrow(sprite:FlxSprite):Int;        // Get player from arrow

    public function getKeycount(?player:Int):Int;       // Get total key count (4 for almost every engine)
    public function getPlayercount():Int;    // Get total player count (2 for almost every engine)

    // Get cameras to render the arrows (camHUD for almost every engine)
    public function getArrowCamera():Array<FlxCamera>;

    // Options section
    public function getHoldSubdivitions():Int;  // Hold resolution
    public function getDownscroll():Bool;       // Get if it is downscroll

    /**
     * Get the every arrow/receptor indexed by player.
     * Example: 
     * [
     *      [ // Player 0
     *          [strum1, strum2...],
     *          [arrow1, arrow2...],
     *          [hold1, hold2....]
     *      ],
     *      [ // Player 2
     *          [strum1, strum2...],
     *          [arrow1, arrow2...],
     *          [hold1, hold2....]
     *      ]
     * ]
     * @return Array<Array<Array<FlxSprite>>>
     */
    public function getArrowItems():Array<Array<Array<FlxSprite>>>;
}