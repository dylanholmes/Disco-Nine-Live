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


		function LineTangetToCircleUsingGeometry() {

			/* Setup UI */
			setupUI();

			radius = 50;

			var center:Point = new Point(stage.stageWidth/2, stage.stageHeight/2);

			var size:Number = 30;
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
			axis.graphics.lineStyle(0.1, 0xFF0000, 0.5);
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
						axis.graphics.lineStyle(0.1, 0xFF5555, 0.4);
						var r:Number = radius-10;
						var b:Number = stage.stageWidth;
						var a:Number = Math.sqrt(b*b + r*r);
						var alpha:Number = Math.atan(n.y/n.x) + Math.atan(b/r) + Math.PI/2;
						var beta:Number = Math.atan(n.y/n.x) - Math.atan(b/r)  + Math.PI/2;
						if(n.x < 0) {
							alpha += Math.PI;
							beta += Math.PI;
						}
						axis.graphics.moveTo(a * Math.sin(alpha), -a*Math.cos(alpha));
						axis.graphics.lineTo(a * Math.sin(beta),  -a*Math.cos(beta));
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