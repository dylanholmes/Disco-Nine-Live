package {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.Graphics;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	import flash.events.*;
	import flash.ui.*;

	public class ProjectionAxis extends Sprite {
				/* UI */
		private var label:TextField;
		private var labelFormat:TextFormat;

		private var box:Sprite;
		private var handle:Sprite;
		private var axis:Sprite;
		private var dragging:Boolean;
		private var radius:Number;


		function ProjectionAxis() {

			/* Setup UI */
			setupUI();

			radius = 50;

			var center:Point = new Point(stage.stageWidth/2, stage.stageHeight/2);

			var size:Number = 30;
			var points:Vector.<Point> = new Vector.<Point>;
			points.push(new Point(-size/2, -size/2));
			points.push(new Point( size/2, -size/2));
			points.push(new Point( size/2,  size/2));
			points.push(new Point(-size/2,  size/2));

			box = new Sprite();
			box.x = stage.stageWidth/2;
			box.y = stage.stageHeight/2;
			box.graphics.beginFill(0x0000FF, 0.3);
			box.graphics.lineStyle(0.1, 0x0000FF, 0.5);
			box.graphics.drawRect(-size/2, -size/2, size, size);

			// for fun (not part of box)
			box.graphics.beginFill(0x000000, 0);
			box.graphics.lineStyle(0.1, 0x000000, 0.1);
			box.graphics.drawCircle(0, 0, radius-10);
			addChild(box);

			

			handle = new Sprite();
			handle.x = stage.stageWidth/2;
			handle.y = stage.stageHeight/2;
			handle.graphics.beginFill(0xFF0000);
			handle.graphics.lineStyle();
			handle.graphics.drawCircle(0, -radius, 5);
			addChild(handle);

			

			axis = new Sprite();
			axis.x = stage.stageWidth/2;
			axis.y = stage.stageHeight/2;
			axis.graphics.lineStyle(0.1, 0x000000, 0.1);
			axis.graphics.moveTo(-stage.stageWidth, -(radius-10));
			axis.graphics.lineTo( stage.stageWidth, -(radius-10));
			addChild(axis);

			



			handle.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { Mouse.cursor = MouseCursor.HAND });
			handle.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { if(!dragging) Mouse.cursor = MouseCursor.AUTO });
			handle.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { dragging = true;  });

			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { dragging = false; Mouse.cursor = MouseCursor.AUTO; });
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void { 
					var v:Point = new Point(
						(e.stageX - stage.stageWidth/2),
						(e.stageY - stage.stageHeight/2)
					);

					var n:Point = new Point(
						v.x / Math.sqrt(v.x*v.x+v.y*v.y),
						v.y / Math.sqrt(v.x*v.x+v.y*v.y)
					);

					label.text = 
						"Mouse Position on Stage w.r.t. center: \n\tx: " + v.x + "\n\ty:" + v.y + 
						"\n Normalize: \n\tx:" + n.x + "\n\ty:" + n.y;

					if (dragging) {
						handle.graphics.clear();
						handle.graphics.beginFill(0xFF0000);
						handle.graphics.lineStyle();
						handle.graphics.drawCircle(radius * n.x, radius * n.y, 5);

						axis.graphics.clear();
						

						// axis represented as a vector -> perpendicular to axis from center to mouse
						// just rotate the normalized mouse direction vector -pi/2 rad 
						// then pick two point along that vector
						// then translate them along the mouse direction vector
						var length:Number = stage.stageWidth;
						var distance:Number = radius-10;
						var angle:Number = -Math.PI/2;
						var axisVec:Point = new Point(
							n.x * Math.cos(angle) + n.y * Math.sin(angle),
							n.x * -Math.sin(angle) + n.y * Math.cos(angle)
						);
						var p1:Point = new Point( -length * axisVec.x, -length * axisVec.y);
						var p2:Point = new Point( length * axisVec.x, length * axisVec.y);
						p1.x += distance * n.x;
						p1.y += distance * n.y;
						p2.x += distance * n.x;
						p2.y += distance * n.y;
						// plot the points
						axis.graphics.lineStyle(0.1, 0x000000, 0.1);
						axis.graphics.moveTo(p1.x, p1.y);
						axis.graphics.lineTo(p2.x, p2.y);

						// Project the box onto the axis
						// Create vectors that point from the center of the box to each of the box's vertices
						// Take the dot product of each of theses vectors with the  projection axis vector
						// The vectors that produce the min and max dot products are what we need.
						// Project 
						var max:Number = 0, min:Number = 0, minIndex:Number, maxIndex:Number;
						for(var i:int = 0; i < points.length; i++) {
							var dot:Number = points[i].x * axisVec.x + points[i].y * axisVec.y;
							if (dot > max) {
								max = dot;
								maxIndex = i;
							} else if (dot < min) {
								min = dot;
								minIndex = i;
							}
						}
						// (I think) using min & max like this works because axisVec is normlized
						p1 = new Point( min * axisVec.x, min * axisVec.y);
						p2 = new Point( max * axisVec.x, max * axisVec.y);
						p1.x += distance * n.x;
						p1.y += distance * n.y;
						p2.x += distance * n.x;
						p2.y += distance * n.y;
						// plot the points
						axis.graphics.lineStyle(1, 0x0000FF, 0.5);
						axis.graphics.moveTo(p1.x, p1.y);
						axis.graphics.lineTo(p2.x, p2.y);

						label.appendText('\nmin:' + min + '\nmax: ' + max);




					}

			});

			

			
		}
		private function setupUI():void {
			stage.frameRate = 24; // 24 is the default

			labelFormat = new TextFormat();
			labelFormat.font = 'Helvetica';
			labelFormat.size = 8;
			labelFormat.color = 0x000000;

			label = new TextField();
			label.defaultTextFormat = labelFormat;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = 'Nther';
			label.x = 0;
			label.y = 0;
			addChild(label);
		}
	}
}