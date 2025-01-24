package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Bumpy extends Modifier {

	function applyBumpy(curPos:Vector3D, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.receptor);
		final field = params.field;
		var hDiff = params.hDiff;

		var shift = 0.;

		var bumpyMath = (40 * sin(
				(hDiff + (100.0 * (getPercent('bumpy'+axis+'Offset', field) + getPercent('bumpy'+axis+receptorName+'Offset', field)))) 
				/ (((getPercent('bumpy'+axis+'Period', field) + getPercent('bumpy'+axis+receptorName+'Period', field))
				* ((getPercent('bumpy'+axis+'Mult', field) + getPercent('bumpy'+axis+receptorName+'Mult', field))*24.0)) + 24.0)
			));

		shift += bumpyMath * (getPercent('bumpy'+axis, field) + getPercent('bumpy'+axis+receptorName, field));

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

		var shift = 0.;

		var bumpyMath = (40 * sin(
			(hDiff + (100.0 * (getPercent('bumpyAngle'+axis+'Offset', field) + getPercent('bumpyAngle'+axis+receptorName+'Offset', field)))) 
			/ (((getPercent('bumpyAngle'+axis+'Period', field) + getPercent('bumpyAngle'+axis+receptorName+'Period', field))
			* ((getPercent('bumpyAngle'+axis+'Mult', field) + getPercent('bumpyAngle'+axis+receptorName+'Mult', field))*24.0)) + 24.0)
		));
	
		shift += bumpyMath * (getPercent('bumpyAngle'+axis, field) + getPercent('bumpyAngle'+axis+receptorName, field));

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
