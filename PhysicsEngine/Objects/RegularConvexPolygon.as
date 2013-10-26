package PhysicsEngine.Objects {
	import flash.display.Sprite;
	import PhysicsEngine.Math.Vector2;

	public class RegularConvexPolygon extends Sprite {

		/* Geometric Data */
		private var center:Vector2;
		private var radius:Number;
		private var vertices:Vector.<Vector2>;
		private var normals:Vector.<Vector2>;

		/* Asthetic Data */
		private var color:Number;

		/* Constraint Data */
			// Draggable Constraint
			public var dragging:Boolean;		

		/* * * * * * * *
		 * Constructor *
		 * * * * * * * */
		function RegularConvexPolygon(center:Vector2, radius:Number, numberOfVertices:Number, color:Number) {
			/*	Geometric Data	*/
			/*		->	center		*/
			this.center = center;
			/*		->	radius 			*/
			this.radius = radius;
			/*		->	vertices
									Compute -> Start with top vetrex
									then rotate that vector by 2pi/numberOfVertices rad numberOfVertices times */
			vertices = new Vector.<Vector2>;
			vertices.push( new Vector2(0, -radius) ); // up
			var i:Number;
			for(i=1; i<numberOfVertices; i++)
				vertices.push( (new Vector2(vertices[i-1].x, vertices[i-1].y)).rotate(2 * Math.PI / numberOfVertices) );
			/*		->	normals
									Compute -> Start with top vetrex
									then rotate that vector by 2pi/numberOfVertices rad numberOfVertices times 
									Note: Normals are 'Normalized'... duh	*/
			normals = new Vector.<Vector2>;
			normals.push( (new Vector2(0, -1)).rotate(Math.PI / numberOfVertices) ); // up
			for(i=1; i<numberOfVertices; i++)
				normals.push( (new Vector2(normals[i-1].x, normals[i-1].y)).rotate(2 * Math.PI / numberOfVertices) );

			/*	Asthetic Data		*/
			this.color = color;
		}

		/* Geometric Methods */
		public function getCenter():Vector2 { return center; }
		public function setCenter(v:Vector2):void { center = v; }
		public function getRadius():Number {
			return radius;
		}
		public function getVertices():Vector.<Vector2> {
			return vertices;
		}
		public function getNormals():Vector.<Vector2> {
			return normals;
		}
		/* Asthetic Methods */
		public function getColor():Number {
			return color;
		}

		/* Constraint Methods */

		// Private Methods
		public function draw():void {
			graphics.clear();
			// draw square
			//   fill: light 'color'
			//   stroke: 'color'
			graphics.beginFill(color, 1);
			graphics.lineStyle(0.1, color, 1);
			graphics.moveTo(center.x + vertices[0].x, center.y + vertices[0].y);
			var i:Number;
			for(i=1; i<vertices.length; i++)
				graphics.lineTo(center.x + vertices[i].x, center.y + vertices[i].y);
			graphics.endFill();

			// draw center point
			graphics.beginFill(color, 1);
			graphics.lineStyle();
			graphics.drawCircle(center.x, center.y, 0.5);
			graphics.endFill();

		}
	}
}