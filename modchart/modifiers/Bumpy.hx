package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Bumpy extends Modifier {

	public function new(pf) {
		super(pf);

		var stuff = ['','Angle'];
		for (i in 0...stuff.length){
			setPercent('bumpy'+stuff[i]+'Mult', 1, -1);
			setPercent('bumpy'+stuff[i]+'XMult', 1, -1);
			setPercent('bumpy'+stuff[i]+'YMult', 1, -1);
			setPercent('bumpy'+stuff[i]+'ZMult', 1, -1);
		}
	}

	function applyBumpy(curPos:Vector3D, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.receptor);
		final field = params.field;
		var hDiff = params.hDiff;

		var offset = getPercent('bumpy'+axis+'Offset', field) + getPercent('bumpy'+axis+receptorName+'Offset', field);
		var period = getPercent('bumpy'+axis+'Period', field) + getPercent('bumpy'+axis+receptorName+'Period', field);
		var mult = getPercent('bumpy'+axis+'Mult', field) + getPercent('bumpy'+axis+receptorName+'Mult', field);

		var shift = 0.;

		var scrollSpeed = getScrollSpeed();

		var bumpyMath = 40 * sin(((hDiff*0.01) + (100.0 * offset) / ((period * (mult*24.0)) + 24.0)) / ((scrollSpeed * mult)/2)) * (getKeyCount()/2.0);

		//var bumpyMath = (40 * sin((hDiff + (100.0 * offset)) / ((period * (mult*24.0)) + 24.0)));

		shift += (getPercent('bumpy'+axis, field) + getPercent('bumpy'+axis+receptorName, field)) * bumpyMath;

		switch (realAxis) {
			case 'x':
				curPos.x += shift;
			case 'y':
				curPos.y += shift;
			case 'z':
				curPos.z += shift;
		}
	}

	public function applyAngle(vis:Visuals, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.receptor);
		final field = params.field;
		var hDiff = params.hDiff;

		var offset = getPercent('bumpyAngle'+axis+'Offset', field) + getPercent('bumpyAngle'+axis+receptorName+'Offset', field);
		var period = getPercent('bumpyAngle'+axis+'Period', field) + getPercent('bumpyAngle'+axis+receptorName+'Period', field);
		var mult = getPercent('bumpyAngle'+axis+'Mult', field) + getPercent('bumpyAngle'+axis+receptorName+'Mult', field);

		var shift = 0.;

		var scrollSpeed = getScrollSpeed();

		var bumpyMath = 40 * sin(((hDiff*0.01) + (100.0 * offset) / ((period * (mult*24.0)) + 24.0)) / ((scrollSpeed * mult)/2)) * (getKeyCount()/2.0);
	
		shift += (getPercent('bumpyAngle'+axis, field) + getPercent('bumpyAngle'+axis+receptorName, field)) * bumpyMath;

		switch (realAxis) {
			case 'x':
				vis.angleX += shift;
			case 'y':
				vis.angleY += shift;
			case 'z':
				vis.angleZ += shift;
		}
	}

	override public function render(curPos:Vector3D, params:RenderParams) {
		// var field = params.field;
		// var hDiff = params.hDiff;
		// var bumpyX = (40 * sin((hDiff + (100.0 * getPercent('bumpyXOffset', field))) / ((getPercent('bumpyXPeriod', field) * 24.0) + 24.0)));
		// var bumpyY = (40 * sin((hDiff + (100.0 * getPercent('bumpyYOffset', field))) / ((getPercent('bumpyYPeriod', field) * 24.0) + 24.0)));
		// var bumpyZ = (40 * sin((hDiff + (100.0 * getPercent('bumpyZOffset', field))) / ((getPercent('bumpyZPeriod', field) * 24.0) + 24.0)));

		// curPos.x += bumpyX * getPercent('bumpyX', field);
		// curPos.y += bumpyY * getPercent('bumpyY', field);
		// curPos.z += bumpyZ * (getPercent('bumpy', field) + getPercent('bumpyZ', field));

		applyBumpy(curPos, params, '', 'z');
		applyBumpy(curPos, params, 'x', 'x');
		applyBumpy(curPos, params, 'y', 'y');
		applyBumpy(curPos, params, 'z', 'z');

		return curPos;
	}

	override public function visuals(data:Visuals, params:RenderParams) {
		applyAngle(data, params, '', 'z');
		applyAngle(data, params, 'x', 'x');
		applyAngle(data, params, 'y', 'y');
		applyAngle(data, params, 'z', 'z');

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
