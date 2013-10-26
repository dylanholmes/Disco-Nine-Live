package PhysicsEngine.Math {
	import flash.geom.Point;
	
	public class Vector2 {
		// fields
		public var x:Number;
		public var y:Number;
		// Constructor
		function Vector2(x:Number=0, y:Number=0) {
			this.x = x;
			this.y = y;
		}
		public function setVector2FromPoints(from:Point, to:Point):Vector2 {
			this.x = to.x - from.x;
			this.y = to.y - from.y;
			return this;
		}
		public function multiply(a:Number):Vector2 {
			this.x *= a;
			this.y *= a;
			return this;
		}
		public function add(v:Vector2):Vector2 {
			this.x += v.x;
			this.y += v.y;
			return this;
		}
		public function normalize():Vector2 {
			x /= Math.sqrt(x*x+y*y);
			y /= Math.sqrt(x*x+y*y);
			return this;
		}
		public function clone():Vector2 {
			return new Vector2(this.x, this.y);
		}
		public function rotate(rad:Number):Vector2 {
			var old_x:Number = x;
			x = x * Math.cos(rad) + y * Math.sin(rad);
			y = -old_x * Math.sin(rad) + y * Math.cos(rad);
			return this;
		}
		// class methods
		public static function dot(u:Vector2, v:Vector2):Number {
			return u.x * v.x + u.y * v.y;
		}

		public static function Vector2FromVector2s(from:Vector2, to:Vector2):Vector2 {
			return new Vector2(to.x - from.x, to.y - from.y);
		}

	}
}