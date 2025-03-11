## 8/10/21
- Hold note quad rework (from Schmovin')
- Added modifiers (PathModifier, Bumpy, Infinite)
- Fixed note positions
- Improved some code
- Fixed hold size (+= 6)

## 8/10/21 (2)
- Hold scale fix

## 12/10/24
- Hold graphic subdivition system (from Schmovin')
	- A subdivision system was already in, but hold notes were literally splited, causing you to gain or lose more heatlh (plus it caused more lag, as well as causing visual issues with texture)
	- Also because of the new subdivision system in hold notes, now to implement this library in cne it is no longer necessary to change anything within the source code.
- Fixed hold notes position and scale when scaling by Z or Zoom.
- Code improvements
- Optimization.

## 12/10/24 (2)
- Schmovin Drunk & Tipsy Math (false paradise recreation upcoming >:3)

## 12/10/24 (3)
- Fix broken hold spacing when bpm changes

# 15/10/24
- Custom mods examples
- Modchart Examples
- More stuff im forgeting
- False paradise stuff... modchart still wip !! some modifiers are not working, dont play it yet

# 24/10/24
- Improved Infinite Modifier
- Optimization and code improvement
- Bounce Mod

# 31/10/24
- Changed List to Array in ModchartGroup (for better performance)
- Added arrow paths (need to enable by Manager.renderArrowPaths = true)
- Arrow path Sub mods
  - Alpha
  - Thickness
  - Scale (Length / Limit)

# 3/11/24
- Fixed critical memory leak in the arrow path renderer (it went from 70MB to more than 4GB in a very short time).
- Optimized a bit the arrow path renderer.
- Added X mod

# 5/11/24
- New Optimized Path Manager written by Me
- Small code improvements

# 06/12/24
- 3D Rotation for regular notes (also holds)
- AngleX, AngleY, AngleZ now are visuals components.
- Custom 3D Camera (Matrix3D)

# 08/12/24
- Skew Mods
- Stealth mods (alpha, glows) now are smoother on holds (depending of your hold subdivition).

# 17/12/24
- Centered2 (also known as centered path)
- Improvements

# 31/12/24
- Tornado Mod (from OpenITG)
- Hold Rotation can be cancelled (via rotateHoldX, rotateHoldY, rotateHoldZ, can be 0-1)
- Better Readme
- Improvements

# 4/01/25
- Moved renderers from Manager.hx to separate classes (ModchartGraphics.hx)
- Cleaned and improved a lot of code

# 06/01/25 (penultimate commit)
- Multiple Playfield support (each one can have his own modifiers and percents)
- Plugin-based Standalone System (TESTING PHASE, NOT FINISHED)
- No more rewriting of any flixel class, now all code is added using Macros.

# 06/01/25 #2
- Fixed arrow animation issue

-- Many changes were not indexed here --

# 11/02/2025
- New 3D Camera (using View Matrix)
- Fix Projection on Arrow rotation. (Perspective correction)
- Switching from Euler Angles to Quanterions.
- Fix typos and refactoring.
- Huge optimizations.

# 12/02/25
- Fixed 3D Camera Offsets (was breaking some stuff)
- Optimized `ModifierGroup` percent management (now uses `haxe.ds.Vector` instead of `IntMap`)
- Optimized a lot of stuff (added preallocation on most stuff possible)
- Fixed `Rotate` (base) modifier (the rotation origin was 'wrong')
- Fixed a oopsie i did (X Rotation was not applied cus a mistake i did lol)
- Addition on `Codename` adapter: Now it read the strum real position (so u can position them without using modchart things)

# 13/02/25
- Added properly support for Sprite Sheet Packed (i just added frame angles lol)
- New Adapter: FPS Plus

# 18/08/25
- Tons of optimization and code improvements
- Added longHolds modifier (nneds fix)
- Z-Sorting was Fixed

# 18/08/25 #2
- Fix receptor, arrow, hold draw order.

# 19/02/25
- Scripted Modifier (again)

# 3/03/25
- Fixed longHolds modifier, now it looks good.
- Added Hold Rotation Mods (Rotation with the parent note position as origin)
- DizzyHolds modifier was added.
- Added more customizable stuff on Config.hx (not everything works for now)

# 10/03/25
- New Modififier percents management system.
- Optimizations.
- WIP Cache System (Discarted for now)

# 10/03/25 (#2)
- WIP Documentation
- ScriptedModifier -> DynamicModifier
- Support for Flixel 5.1 and below (no color transform :/)