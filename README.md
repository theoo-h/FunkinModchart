# ![FunkinModchart Logo](https://raw.githubusercontent.com/theoo-h/FunkinModchart/refs/heads/main/github/imagotipo.png)
<p align="center">
  <b>A powerful modcharting backend for <a href="https://ninja-muffin24.itch.io/funkin">Friday Night Funkin'</a> and other HaxeFlixel-based VSRGs — built by modders, for modders.</b>
</p>


## ¿What is FunkinModchart?

**FunkinModchart** is a fully featured **modcharting framework** that brings [NotITG](https://www.noti.tg/)-style visuals and effects to **Friday Night Funkin’** and any other **VSRG made in HaxeFlixel**.  

With this library, you can easily:
- Modify **arrow trajectories**, **colors**, **transparency**, and **rotation** across full 3D axes.  
- Use a **dynamic event system** to animate modifier values over time.  
- Create **custom easing effects** and **complex visual transitions** — all with simple scripting.

And that’s just the start. FunkinModchart also gives you **extra visual tools** like:
- Visualizing Arrow Paths
- 3D Camera System
- Multiple **Playfields** and **Proxies** for even craziers results

If you’ve ever used **NotITG** or **StepMania**, you’ll feel right at home.

---

## Installation

FunkinModchart supports several major FNF engines:
- [Codename Engine](https://codename-engine.com)  
- [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine)  
- [FPS Plus](https://github.com/ThatRozebudDude/FPS-Plus-Public)  

See the [Support guide](https://github.com/TheoDevelops/FunkinModchart/blob/main/SUPPORT.md) for details.

---

### Setup

Open your project’s `Project.xml`, then scroll to where you define your haxelibs and add:

```xml
<haxedef name="FM_ENGINE" value="YOUR_ENGINE"/>
<haxedef name="FM_ENGINE_VERSION" value="ENGINE_VERSION"/>

<haxelib name="funkin-modchart" />
<haxeflag name="--macro" value="modchart.backend.macros.Macro.includeFiles()"/>
```

Replace the defines with your engine’s name and version (check the format in the [support guide](https://github.com/TheoDevelops/FunkinModchart/blob/main/SUPPORT.md)).  
If everything is set up properly, your project should compile and run as usual — but now with full modchart power.

---

## Using FunkinModchart

### 1. Add the Manager

In your song state or script:

```haxe
import modchart.Manager;

var funkinModchart:Manager = new Manager();
add(funkinModchart);
```

Make sure the **arrow and receptors** are already initialized before creating the modchart instance.  
You can add it directly in source code or through the scripting layer if the game admits it.

---

### 2. Create a Modchart

Explore the available functions in the [Documentation](https://github.com/TheoDevelops/FunkinModchart/blob/main/DOC.md).

> Tip: You don’t need to strictly follow examples — experiment!  
> A bit of experience with **NotITG** or **The Mirin Template** will help you design stunning modcharts faster.

---

## Creating Your Own Adapter

An **Adapter** is a simple wrapper class that lets FunkinModchart work with your game or engine.  
It defines all the essential methods the Modchart Manager depends on.

### Requirements
- Your game must use **HaxeFlixel**.  
- Arrows, receptors, and holds must be **FlxSprite** objects.  
  > FunkinModchart renderers relies on default FlxSprite renderer — it won’t work with sprites that have its custom way for rendering.

### Steps
1. Review the [IAdapter interface](/modchart/standalone/IAdapter.hx).  
2. Check existing [adapter implementations](/modchart/standalone/adapters/) for examples.  
3. The adapter class name must match the value of your `FM_ENGINE` define (PascalCase).

You can even **swap adapters at runtime** — perfect for editors or very crazy modcharts that could require it.

---

## Credits

|   |   |
|------|--------------|
| **Lead Programmer** | [Theo](https://x.com/_the0p) |
| **Help with Optimization** | Ne_Eo (aka. Neo) |
| **Maintainer** | [EdwhakKB](https://x.com/EDWHAK_KB) |
| **Math References** | [OpenITG](https://openitg.gr-p.com/) |
| **Code References** | [Schmovin by 4mbr0s3](https://github.com/4mbr0s3-2/Schmovin) |
| **Logo Artist** | [Soihan](https://x.com/SoihanP) |

---

## Special Thanks

- **lunarcleint** – Moral support, the goat
- **Tsaku** – Beta testing & feedback  
- **All contributors !**

  <a href="https://github.com/theoo-h/FunkinModchart/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=theoo-h/FunkinModchart" width="350" />
  </a>


  Made with [contrib.rocks](https://contrib.rocks).
  
# Licensing

<div style="display: flex; align-items: center; gap: 1em;">
  <img src="github/isotipo.png" alt="Logo" style="height:10em;" />
  <div style="font-size: 1.2em;">
    <strong>FunkinModchart</strong> is available under the MIT License.<br>
    <a href="LICENSE">Check License for more info.</a>
  </div>
</div>
