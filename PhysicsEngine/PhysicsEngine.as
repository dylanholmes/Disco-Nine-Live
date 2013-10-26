package PhysicsEngine {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.events.*;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	import PhysicsEngine.Algorithms.CollisionDetection.NarrowPhase.SeparatingAxisTheorem;
	import PhysicsEngine.Objects.RegularConvexPolygon;
	import PhysicsEngine.Math.Vector2;

	public class PhysicsEngine extends Sprite{
		/* UI */
		private var label:TextField;
		private var labelFormat:TextFormat;

		/* Object Data */
		private var polygons:Vector.<RegularConvexPolygon>;

		/* Algorithm Data */
		private var SAT:SeparatingAxisTheorem;

		/* * * * * * * *
		 * Constructor *
		 * * * * * * * */
		function PhysicsEngine() {
			setupUI();

			/* Object Data */
			polygons = new Vector.<RegularConvexPolygon>;

			/* Algorithm Data */
			SAT = new SeparatingAxisTheorem();
			addChild(SAT);

		}

		public function stageMouseUp(e:MouseEvent):void { 
				var i:int;
				for( i = 0; i < polygons.length; i++ ) {
					polygons[i].dragging = false;				
				}
		}
		public function stageMouseMove(e:MouseEvent):void {
			// find the polygon that is being dragged
			// move the dragged polygon to the mouse position
			var i:int;
			for( i = 0; i < polygons.length; i++ ) {
				if (polygons[i].dragging)
					polygons[i].setCenter(new Vector2(e.stageX - x,e.stageY -  y));
			}
		}
		public function stageEnterFrame(e:Event):void {
			draw();
			label.text = "Collision? " + SAT.isCollisionRegularConvexPolygons(polygons);
		}



		/* * * * * * * * * * *
		 * Stepping Methods  *  Simulate using chosen algorithms
		 * * * * * * * * * * */
		public function forces():void {}
		public function integrate():void {}
		/* 
			Satisfy all contstraints here.
			Contstraints may include:
				- Rigid Body Collisions
		*/
		public function constraints():void {}

		/* * * * * * * * * * * * * *
		 * Setup/Configure Methods *
		 * * * * * * * * * * * * * */
		public function addPolygon(polygon:RegularConvexPolygon):void {
			polygons.push(polygon);
			addChild(polygon);
			polygon.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { Mouse.cursor = MouseCursor.HAND });
			polygon.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { Mouse.cursor = MouseCursor.AUTO });
			polygon.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { polygon.dragging = true; });
		}

		/* * * * * * * * * * * * * *
		 * Private Helper Methods  *
		 * * * * * * * * * * * * * */

		private function draw():void {
			drawPolygons();
			//SAT.drawProjectionAxesOfRegularConvexPolygons(polygons);				
		}

		private function drawPolygons():void {
			var i:int;
			for( i = 0; i < polygons.length; i++ )
					polygons[i].draw();

		}

		private function setupUI():void {
			labelFormat = new TextFormat();
			labelFormat.font = 'Helvetica';
			labelFormat.size = 8;
			labelFormat.color = 0xFFFFFF;

			label = new TextField();
			label.defaultTextFormat = labelFormat;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = -300;
			label.y = 0;
			addChild(label);
		}


	}
}

/*
 Later -> Interface for Algorithms e.g. : CollisionDetectionAlgorithm Interface, CollisionResponseAlgorithm Interface
 */