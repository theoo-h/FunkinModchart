package modchart.backend.standalone.adapters.pslice;

import flixel.FlxSprite;
import modchart.backend.standalone.adapters.psych.Psych;
import objects.NoteSplash;
import objects.SustainSplash;
import states.PlayState;

class Pslice extends Psych {
	override public function onModchartingInitialization() {
		super.onModchartingInitialization();

		PlayState.instance.grpNoteSplashes.visible = false;
		PlayState.instance.grpHoldSplashes.visible = false;
	}

	override public function getLaneFromArrow(arrow:FlxSprite) {
		if (arrow is NoteSplash) {
			var splash:NoteSplash = cast arrow;
			@:privateAccess
			return splash.babyArrow.noteData;
		} else if (arrow is SustainSplash) {
			var splash:SustainSplash = cast arrow;
			@:privateAccess
			return splash.strumNote.noteData;
		}

		return super.getLaneFromArrow(arrow);
	}

	override public function getPlayerFromArrow(arrow:FlxSprite) {
		if (arrow is NoteSplash) {
			var splash:NoteSplash = cast arrow;
			@:privateAccess
			return splash.babyArrow.player;
		} else if (arrow is SustainSplash) {
			var splash:SustainSplash = cast arrow;
			@:privateAccess
			return splash.strumNote.player;
		}

		return super.getPlayerFromArrow(arrow);
	}

	// this code looks so bad
	override public function getArrowItems() {
		var pspr:Array<Array<Array<FlxSprite>>> = [[[], [], [], []], [[], [], [], []]];

		var counts:Array<Array<Int>> = [[0, 0, 0, 0], [0, 0, 0, 0]];
		var indices:Array<Array<Int>> = [[0, 0, 0, 0], [0, 0, 0, 0]];

		@:privateAccess
		PlayState.instance.grpNoteSplashes.forEachAlive(splash -> {
			if (splash.babyArrow != null && splash.active) {
				counts[splash.babyArrow.player][3]++;
			}
		});

		@:privateAccess
		PlayState.instance.grpHoldSplashes.forEachAlive(splash -> {
			if (splash.strumNote != null && splash.active) {
				counts[splash.strumNote.player][3]++;
			}
		});

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			counts[strumNote.player][0]++;
		});

		@:privateAccess
		PlayState.instance.notes.forEachAlive(strumNote -> {
			final player = Adapter.instance.getPlayerFromArrow(strumNote);
			counts[player][strumNote.isSustainNote ? 2 : 1]++;
		});

		for (player in 0...2) {
			for (i in 0...4) {
				pspr[player][i].resize(counts[player][i]);
			}
		}

		@:privateAccess
		PlayState.instance.grpNoteSplashes.forEachAlive(splash -> {
			if (splash.babyArrow != null && splash.active) {
				var player = splash.babyArrow.player;
				pspr[player][3][indices[player][3]++] = splash;
			}
		});

		@:privateAccess
		PlayState.instance.grpHoldSplashes.forEachAlive(splash -> {
			if (splash.strumNote != null && splash.active) {
				var player = splash.strumNote.player;
				pspr[player][3][indices[player][3]++] = splash;
			}
		});

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			var player = strumNote.player;
			pspr[player][0][indices[player][0]++] = strumNote;
		});

		@:privateAccess
		PlayState.instance.notes.forEachAlive(strumNote -> {
			final player = Adapter.instance.getPlayerFromArrow(strumNote);
			var index = strumNote.isSustainNote ? 2 : 1;
			pspr[player][index][indices[player][index]++] = strumNote;
		});

		return pspr;
	}
}
