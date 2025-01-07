package modchart.core.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;

import modchart.standalone.adapters.*;

class AdapterMacro
{
    // shortest macro ive made
    public static function init()
    {
        // just add the adapter class to the compiler lol
        Context.onAfterInitMacros(() -> {
            final ENGINE:String = cast haxe.macro.Context.definedValue('FM_ENGINE');
            Context.getType('modchart.standalone.adapters.' + ENGINE.substr(0, 1).toUpperCase() + ENGINE.substr(1).toLowerCase());
        });
    }
}