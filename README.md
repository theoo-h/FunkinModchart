<p align="center">
  <h1 align="center">FunkinModchart</h1>
  <h4 align="center">An Modcharting backend library for Friday Night Funkin' made by modders, to modders.</h4>
</p>

**FunkinModchart** is a tool designed to bring [NotITG](https://www.noti.tg/) visuals and capabilities to [Friday Night Funkin](https://ninja-muffin24.itch.io/funkin), adding modifiers to change the **arrow trajectory, colors, transparency and the  rotation angle through 3D Axes**, event system to change the modifier's percent easing or setting those to create endless amazing visual effects and even **more**!.

This framework also provides **extra features** that can help you to make even more crazy visuals, as **arrow paths, 3D view camera, AFTs**, etc. *(If you have already modeled NotITG or StepMania, you know what I am talking about)*

<details>
<summary><h2>Importing the library</h2></summary>

This library currently has support for multiple engines such as [Codename Engine](https://codename-engine.com) and [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine.com), click [here](SUPPORT.md) for more information, and only takes a couple of lines of code to import it:

#### Go to your project and open `Project.xml`
At the bottom of where the haxelib section is, paste this code.
```xml
<haxedef name="FM_ENGINE" value="YOUR_ENGINE"/>
<haxedef name="FM_ENGINE_VERSION" value="ENGINE_VERSION"/>

<haxelib name="funkin-modchart" />
```

Fill in the definitions with your engine name and version using the [format](SUPPORT.md) mentioned.

And if you did everything good, it should compile and work normal !

</details>

<details>
<summary><h2>Making your own Adapter</h2></summary>

to do heheheh, if u know coding just check psych and codename adapters and u'll figure out (also check Adapter.hx and AdapterMacro.hx for more information)
also OBVIOUSLY has to be an flixel-based fnf engine

</details>

## Credits
**OpenITG:** Some math taken for modifiers.

**4mbr0s3:** Some code taken from [Schmovin'](https://github.com/4mbr0s3-2/Schmovin), his own Modcharting Lib. (really impresive)

## Special Thanks

**Ne_Eo (aka. Neo):** Support, help with some bugs.

**lunercleint:** Support, such a nice guy!

**Tsaku:** Support, bug finder. (thanks !!!)