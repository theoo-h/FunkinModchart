package modchart.core.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;

class AdapterMacro
{
    public static function init()
    {
        Compiler.include("modchart.standalone.adapters." + haxe.macro.Context.definedValue("FM_ENGINE").toLowerCase());
    }
}