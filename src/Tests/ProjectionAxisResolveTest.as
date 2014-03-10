package Tests {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.*;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	import PhysicsEngine.PhysicsEngine;
	import PhysicsEngine.Math.Vector2;
	import PhysicsEngine.Objects.RegularConvexPolygon;

	import Vendor.Stats;

	[SWF(backgroundColor="0x000000")]
	public class ProjectionAxisResolveTest extends Sprite {
		/* UI */
		private var collisionLabel:TextField;
		private var collisionLabelFormat:TextFormat;
		private var frameRateLabel:TextField;

		/* Physics Engine */
		private var physicsEngine:PhysicsEngine;
		

		function ProjectionAxisResolveTest() {

			/* Setup UI */
			//setupUI();
			addChild(new Stats());

			physicsEngine = new PhysicsEngine('resolve');
			// center the physics engine, centers physics engine's coordinate system too, which makes calculations easier
			physicsEngine.x = stage.stageWidth/2;
			physicsEngine.y = stage.stageHeight/2;
			addChild(physicsEngine);

			physicsEngine.addPolygon(new RegularConvexPolygon( new Vector2(-100, 50), 20, 3,  0xFF0000 ));
			physicsEngine.addPolygon(new RegularConvexPolygon( new Vector2(-50, 50), 20, 4, 0xFF8800 ));

			
		}

		private function setupUI():void {
			stage.frameRate = 24; // 24 is the default

			collisionLabelFormat = new TextFormat();
			collisionLabelFormat.font = 'Helvetica';
			collisionLabelFormat.size = 8;
			collisionLabelFormat.color = 0x000000;

			collisionLabel = new TextField();
			collisionLabel.defaultTextFormat = collisionLabelFormat;
			collisionLabel.autoSize = TextFieldAutoSize.LEFT;
			collisionLabel.text = 'No Collision';
			collisionLabel.x = 0;
			collisionLabel.y = 0;
			addChild(collisionLabel);

			frameRateLabel = new TextField();
			frameRateLabel.defaultTextFormat = collisionLabelFormat;
			frameRateLabel.autoSize = TextFieldAutoSize.LEFT;
			frameRateLabel.text = '0';
			frameRateLabel.x = 0;
			frameRateLabel.y = 20;
			addChild(frameRateLabel);
		}
	}
}