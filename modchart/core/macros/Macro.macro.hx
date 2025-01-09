package modchart.core.macros;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr;

class Macro {
	public static function includeFiles() {
		Compiler.include('modchart', true, ['modchart.standalone.adapters']);
		Compiler.include("modchart.standalone.adapters." + haxe.macro.Context.definedValue("FM_ENGINE").toLowerCase());
	}

	public static function addProperty_z():Array<Field> {
		var fields = Context.getBuildFields();

		// uses _z to prevent collisions with other classes
		fields.push({
			name: "_z",
			access: [APublic],
			kind: FieldType.FVar(macro :Float, macro $v{0}),
			pos: Context.currentPos()
		});

		return fields;
	}

	public static function buildFlxCamera():Array<Field> {
		var fields = Context.getBuildFields();

		for (f in fields) {
			if (f.name == 'startTrianglesBatch') {
				switch (f.kind) {
					case FFun(fun):
						// we're just removing a if statement cuz causes some color issues
						fun.expr = macro {
							return getNewDrawTrianglesItem(graphic, smoothing, isColored, blend, hasColorOffsets, shader);
						};
					default:
						// do nothing
				}
			}
		}

		return fields;
	}

	public static function buildFlxDrawTrianglesItem():Array<Field> {
		var fields = Context.getBuildFields();
		var newField:Field = {
			name: 'addGradientTriangles',
			pos: Context.currentPos(),
			access: [APublic],
			kind: FieldType.FFun({
				args: [
					{
						name: 'vertices',
						type: macro :DrawData<Float>
					},
					{
						name: 'indices',
						type: macro :DrawData<Int>
					},
					{
						name: 'uvtData',
						type: macro :DrawData<Float>
					},
					{
						name: 'colors',
						type: macro :DrawData<Int>,
						opt: true
					},
					{
						name: 'position',
						type: macro :FlxPoint,
						opt: true
					},
					{
						name: 'cameraBounds',
						type: macro :FlxRect,
						opt: true
					},
					{
						name: 'transforms',
						type: macro :Array<ColorTransform>,
						opt: true
					}
				],
				expr: macro {
					if (position == null)
						position = point.set();

					if (cameraBounds == null)
						cameraBounds = rect.set(0, 0, FlxG.width, FlxG.height);

					var verticesLength:Int = vertices.length;
					var prevVerticesLength:Int = this.vertices.length;
					var numberOfVertices:Int = Std.int(verticesLength / 2);
					var prevIndicesLength:Int = this.indices.length;
					var prevUVTDataLength:Int = this.uvtData.length;
					var prevColorsLength:Int = this.colors.length;
					var prevNumberOfVertices:Int = this.numVertices;

					var tempX:Float, tempY:Float;
					var i:Int = 0;
					var currentVertexPosition:Int = prevVerticesLength;

					while (i < verticesLength) {
						tempX = position.x + vertices[i];
						tempY = position.y + vertices[i + 1];

						this.vertices[currentVertexPosition++] = tempX;
						this.vertices[currentVertexPosition++] = tempY;

						if (i == 0) {
							bounds.set(tempX, tempY, 0, 0);
						} else {
							inflateBounds(bounds, tempX, tempY);
						}

						i += 2;
					}

					var indicesLength:Int = indices.length;
					if (!cameraBounds.overlaps(bounds)) {
						this.vertices.splice(this.vertices.length - verticesLength, verticesLength);
					} else {
						var uvtDataLength:Int = uvtData.length;
						for (i in 0...uvtDataLength) {
							this.uvtData[prevUVTDataLength + i] = uvtData[i];
						}

						for (i in 0...indicesLength) {
							this.indices[prevIndicesLength + i] = indices[i] + prevNumberOfVertices;
						}

						if (colored) {
							for (i in 0...numberOfVertices) {
								this.colors[prevColorsLength + i] = colors[i];
							}

							colorsPosition += numberOfVertices;
						}

						verticesPosition += verticesLength;
						indicesPosition += indicesLength;
					}

					position.putWeak();
					cameraBounds.putWeak();

					final indDiv = (1 / indicesLength);

					for (_ in 0...indicesLength) {
						final possibleTransform = transforms[Std.int(_ * indDiv * transforms.length)];

						var alphaMultiplier = 1.;

						if (possibleTransform != null)
							alphaMultiplier = possibleTransform.alphaMultiplier;

						alphas.push(alphaMultiplier);
					}

					if (colored || hasColorOffsets) {
						if (colorMultipliers == null)
							colorMultipliers = [];

						if (colorOffsets == null)
							colorOffsets = [];

						for (_ in 0...indicesLength) {
							final transform = transforms[Std.int(_ * indDiv * transforms.length)];
							if (transform != null) {
								colorMultipliers.push(transform.redMultiplier);
								colorMultipliers.push(transform.greenMultiplier);
								colorMultipliers.push(transform.blueMultiplier);

								colorOffsets.push(transform.redOffset);
								colorOffsets.push(transform.greenOffset);
								colorOffsets.push(transform.blueOffset);
								colorOffsets.push(transform.alphaOffset);
							} else {
								colorMultipliers.push(1);
								colorMultipliers.push(1);
								colorMultipliers.push(1);

								colorOffsets.push(0);
								colorOffsets.push(0);
								colorOffsets.push(0);
								colorOffsets.push(0);
							}

							colorMultipliers.push(1);
						}
					}
				}
			}),
		};

		fields.push(newField);

		return fields;
	}
	/*
		public static function generateModList()
		{
			Context.onAfterInitMacros(() -> {
				final modifierList:Array<Class<Modifier>> = Type.resolveClass('CompileTime').getClassList('modchart.modifiers', true, modchart.Modifier);
				final mappedModifiers:Map<String, Class<Modifier>> = [];

				for (i in 0...modifierList.length)
				{
					final modifierClass = modifierList[i];

					final meta = Meta.getType(modifierClass);
					if (meta != null)
					{
						Context.info('$meta', Context.currentPos());
					}

					var modifierName = Type.getClassName(modifierClass);
					modifierName = modifierName.substring(modifierName.lastIndexOf('.') + 1);
					mappedModifiers[modifierName.toLowerCase()] = modifierClass;
				}

				Constants.MODIFIER_LIST = mappedModifiers;

				Context.info('---- Modifiers Founded ----\n$mappedModifiers');
			});
	}*/
}
