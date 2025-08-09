## August 10, 2021
- Hold note quad rework (from Schmovin’)
- Added modifiers (PathModifier, Bumpy, Infinite)
- Fixed note positions
- Improved code structure
- Fixed hold size (`+= 6`)

## August 10, 2021 (2)
- Hold scale fix

## October 12, 2024
- Hold graphic subdivision system (from Schmovin’)
  - A subdivision system was already in, but hold notes were literally split, causing gameplay imbalance and visual issues
  - New system reduces lag and avoids health drain/exploit issues
  - No need to modify source code when using in CNE
- Fixed hold note position and scale when using zoom
- Code improvements and optimizations

## October 12, 2024 (2)
- Schmovin Drunk & Tipsy Math (False Paradise recreation WIP)

## October 12, 2024 (3)
- Fixed hold spacing bug when BPM changes

## October 15, 2024
- Custom mod examples
- Modchart examples
- False Paradise content (modchart still WIP, not fully functional)
- Other minor additions

## October 24, 2024
- Improved Infinite modifier
- General optimization and code improvements
- Added Bounce mod

## October 31, 2024
- Switched `List` to `Array` in `ModchartGroup` for performance
- Added arrow paths (toggle via `Manager.renderArrowPaths = true`)
- Submods for arrow paths:
  - Alpha
  - Thickness
  - Scale (length/limit)

## November 3, 2024
- Fixed critical memory leak in arrow path renderer (from 70MB to 4GB+)
- Renderer optimization
- Added X mod

## November 5, 2024
- Rewrote Path Manager (optimized version)
- Minor code improvements

## December 6, 2024
- 3D rotation for regular notes (and hold notes)
- `AngleX`, `AngleY`, `AngleZ` now used as visual components
- Custom 3D camera using `Matrix3D`

## December 8, 2024
- Added Skew mods
- Improved Stealth mods (glow/alpha) on hold notes (smoother with subdivision)

## December 17, 2024
- Added `Centered2` path (centered path mod)
- General improvements

## December 31, 2024
- Added Tornado mod (ported from OpenITG)
- Hold rotation now can be toggled via `rotateHoldX/Y/Z` (0 to 1)
- Improved README
- Further improvements

## January 4, 2025
- Renderer classes moved from `Manager.hx` to `ModchartGraphics.hx`
- Major code cleanup and structural improvements

## January 6, 2025
- Multiple playfield support (each with own modifiers and percents)
- Plugin-based standalone system (testing phase)
- Removed rewriting of Flixel classes (now uses macros)

## January 6, 2025 (2)
- Fixed arrow animation issue

(*Many changes were not indexed between commits*)

## February 11, 2025
- New 3D camera using View Matrix
- Fixed projection issues with arrow rotation (perspective correction)
- Switched from Euler angles to Quaternions
- Fixes and refactors
- Major optimizations

## February 12, 2025
- Fixed 3D camera offsets (was breaking visuals)
- Optimized `ModifierGroup` percent handling (`Vector` instead of `IntMap`)
- General prealloc optimizations
- Fixed `Rotate` base modifier (wrong rotation origin)
- Fixed missing X rotation
- Codename adapter now reads real strum position (no modchart offset needed)

## February 13, 2025
- Proper support for Sprite Sheet Packed (angle support)
- New Adapter: FPS Plus

## February 19, 2025
- Re-added Scripted Modifiers system

## March 3, 2025
- Fixed `longHolds` modifier visuals
- Added Hold Rotation mods (rotation based on parent note position)
- Added `DizzyHolds` modifier
- Expanded `Config.hx` customization options (WIP)

## March 10, 2025
- New modifier percent system
- General optimizations
- WIP cache system (later discarded)

## March 10, 2025 (2)
- Started documentation (WIP)
- Renamed `ScriptedModifier` to `DynamicModifier`
- Compatibility with Flixel 5.1 and below (no color transform)
- Fixes for Psych Engine 0.6 support

## March 31, 2025
- Major code cleanup
- Reorganized source files
- Massive optimization pass

## August 4, 2025
- Flixel 6 compatibility ([#18](https://github.com/TheoDevelops/FunkinModchart/pull/18))
- Codename adapter enhancement ([#26](https://github.com/TheoDevelops/FunkinModchart/pull/26))
- New arrow path renderer (more efficient)
- Rewritten event manager for better performance
- `Add` event works correctly now
- Multiple optimizations and enhancements

## August 6, 2025
- Added CSV Paths to Assets for `ArrowShape` and `EyeShape` mods.
- Small improvements.

## August, 8, 2025
- Fixed crash caused by Arrow Path when alpha is 0.
- Fixed `ADD` event (again).