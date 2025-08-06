<p align="center">
  <h1 align="center">FunkinModchart</h1>
  <h4 align="center">An Modcharting backend library for Friday Night Funkin' made by modders, to modders.</h4>
</p>

**FunkinModchart** is a tool designed to bring [NotITG](https://www.noti.tg/) visuals and capabilities to [Friday Night Funkin](https://ninja-muffin24.itch.io/funkin) ***or VSRG games made in flixel***, adding modifiers to change the **arrow trajectory, colors, transparency and the  rotation angle through 3D Axes**, event system to change the modifier's percent easing or setting those to create endless amazing visual effects and even **more**!.

This framework also provides **extra features** that can help you to make even more crazy visuals, as **arrow paths, 3D view camera, AFTs**, etc. *(If you have already modeled NotITG or StepMania, you know what I am talking about)*

<details>
<summary><h2>Importing the library</h2></summary>

This library currently has support for multiple Friday Night Funkin' engines, such as [Codename Engine](https://codename-engine.com), [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) and [FPS Plus](https://github.com/ThatRozebudDude/FPS-Plus-Public) click [here](https://github.com/TheoDevelops/FunkinModchart/blob/main/SUPPORT.md) for more information, and only takes a couple of lines of code to import it:

#### Go to your project and open `Project.xml`
At the bottom of where the haxelib section is, paste this code.
```xml
<haxedef name="FM_ENGINE" value="YOUR_ENGINE"/>
<haxedef name="FM_ENGINE_VERSION" value="ENGINE_VERSION"/>

<haxelib name="funkin-modchart" />
<haxeflag name="--macro" value="modchart.backend.macros.Macro.includeFiles()"/>
```

Fill in the definitions with your engine name and version using the [format](https://github.com/TheoDevelops/FunkinModchart/blob/main/SUPPORT.md) mentioned.

And if you did everything good, it should compile and work normal !

</details>

<details>
<summary><h2>Using the library</h2></summary>

This is the easiest thing, you only have to do a couple of steps for add the modchart instance to a song.

#### Import `modchart.Manager`
And then make an instance of it, and add it to the state.

```haxe
var funkin_modchart_instance:Manager = new Manager();
// On your create function.
add(funkin_modchart_instance);
```

This can be done via haxe scripts or source code, and will soon be possible in PsychLua for `PSYCH` as well.

Make sure that at the time you create the instance, the notes and strums were already generated.
This now all the stuff should be working, do your stuff now.

#### Making a Modchart
First, you should know all the modcharting functions, check them [here](https://github.com/TheoDevelops/FunkinModchart/blob/main/DOC.md).
To make a modchart you don't necessarily have to follow instructions, it's a matter of experimenting with the modifiers and all the functions that FunkinModchart offers, although previous experience with The Mirin Template and NotITG would help you design a good modchart more easily.

</details>

<details>
<summary><h2>Making your own Adapter</h2></summary>

An **Adapter** is a wrapper class which contains all the methods required by the modchart manager to work.
Before you make the Adapter for your Friday Night Funkin' Engine or your VSRG game, there are 2 requirements.

### Your game should be made in HaxeFlixel
I think this obvious since this was originally made for only **Friday Night Funkin'** engines, but just in case.
### Your arrows, receptors and holds needs to be a FlxSprite
FunkinModchart uses a group of custom renderers that takes a **FlxSprite** as input, so you can't use this tool if your arrow system is based on **3D Sprites** or complex graphic rendering.

To make your own Adapter, read [read the methods of the interface](/modchart/standalone/IAdapter.hx), with a little analysis, you will understand how to make your own adapters.
If you have not understood correctly, [you can rely on existing adapters](/modchart/standalone/adapters/).

The name of your adapter class will be the name required in the "FM_ENGINE" define.
One more thing you should keep in mind is that the class name must begin with a capital letter, and all other characters must begin with lowercase.

In case you want to rewrite the adapter when the game is running, you can do so. (can be useful for editors or viewing modcharts outside of the playing field).
</details>

## Credits
**TheoDev**: Owner, Lead coder.

**Ne_Eo (aka. Neo)**: Coder, bugfixes & Optimizer.

**EdwhakKB**: Maintainer.

**OpenITG:** Some math taken for modifiers.

**4mbr0s3:** Some code taken from [Schmovin'](https://github.com/4mbr0s3-2/Schmovin), his own Modcharting Lib. (really impressive)

## Special Thanks

**lunarcleint:** Support, such a nice guy!

**Tsaku:** Support, bug finder. (thanks !!!)
