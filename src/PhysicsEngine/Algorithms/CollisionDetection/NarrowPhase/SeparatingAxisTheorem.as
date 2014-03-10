package PhysicsEngine.Algorithms.CollisionDetection.NarrowPhase {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import PhysicsEngine.Math.Vector2;
	import PhysicsEngine.Objects.RegularConvexPolygon;

	public class SeparatingAxisTheorem extends Sprite {
		/* * * * * * * * * *
		 *   Constructor   *
		 * * * * * * * * * */
		public function SeparatingAxisTheorem() {}
		/* * * * * * * * * *
		 * Public Methods  *
		 * * * * * * * * * */
		public function drawProjectionAxesOfRegularConvexPolygons(polygons:Vector.<RegularConvexPolygon>):void {
			var normals:Vector.<Vector2>, center:Vector2, axis:Vector2, length:Number, distance:Number;
			var i:int, j:int, k:int;

			graphics.clear();

			// for each polygon
			for(i=0; i<polygons.length; i++) {
				normals 	= polygons[i].getNormals();
				center 		= polygons[i].getCenter();
				length		= 100 * polygons[i].getRadius();
				distance	= 4 * polygons[i].getRadius();

				//	for each normal:
				for(j=0; j<normals.length; j++) {

					//	calculate the projection axis
					axis = normals[j].clone();
					//	draw the projection axis
					drawProjectionAxis(axis, center, normals[j], length, distance);

					//	for each polygon
					for( k = 0; k < polygons.length; k++ ) {
						// draw the polygon's projection onto the projection axis
						drawProjectionOfRegularConvexPolygonOnAxis(polygons[k], axis, center, normals[j], distance);
					}
				}
			}
		}

		public function isCollisionRegularConvexPolygons(polygons:Vector.<RegularConvexPolygon>):Boolean {
			var normalsI:Vector.<Vector2>, centerI:Vector2, normalsJ:Vector.<Vector2>, centerJ:Vector2,
				axis:Vector2, length:Number, distance:Number;
			var i:int, j:int, k:int;
			for(i=0; i<polygons.length; i++) {
				normalsI 	= polygons[i].getNormals();
				centerI 	= polygons[i].getCenter();
				//	for each polygon
				for(j=0; j<polygons.length; j++) {
					// that is not the same polygon
					if (j != i) {
						normalsJ 	= polygons[j].getNormals();
						centerJ 	= polygons[j].getCenter();

						// if all polygons[i] and polygons[j] projections overlap
						// on both polygons[i]'s and polygons[j]'s projection axis
						// then there is a collision

						// So, instead let's look for one projection that doesn't
						// overlap.

						var collision:Boolean = true;
						// for each normal: Check polygons[i] on polygons[j]
						for( k = 0; k < normalsI.length; k++ ) {
							// calculate the projection axis
							axis = normalsI[k].clone();
							//
							if(!doRegularConvexPolygonsOverlapOnAxis(axis, centerI, polygons[i].getVertices(), centerJ, polygons[j].getVertices())) {
								collision = false;
								break;
							}
							
						}
						// do not need to check polygons[j] on polygons[i] if there's no collision
						if (collision) {
							// for each normal: Check polygons[j] on polygons[i]
							for( k = 0; k < normalsJ.length; k++ ) {
								// calculate the projection axis
								axis = normalsJ[k].clone();
								//
								if(!doRegularConvexPolygonsOverlapOnAxis(axis, centerI, polygons[i].getVertices(), centerJ, polygons[j].getVertices())) {
									collision = false;
									break;
								}
							}

							// if there is still a collision, short circuit -> we only need a boolean answer
							if (collision) return true;
						}
						
					}
				}
			}
			// if we haven't found a collision by now, there's nothing left to check, there is no collision
			return false;
		}

		public function resolveCollisionOfRegularConvexPolygonsByProjection(polygons:Vector.<RegularConvexPolygon>):Vector2 {
			var debugVec:Vector2 = new Vector2();
			var normalsI:Vector.<Vector2>, centerI:Vector2, normalsJ:Vector.<Vector2>, centerJ:Vector2,
				axis:Vector2, length:Number, distance:Number;
			var i:int, j:int, k:int;
			// for each pair of polygons
			for(i=0; i<polygons.length; i++) {
				normalsI 	= polygons[i].getNormals();
				centerI 	= polygons[i].getCenter();
				for(j=0; j<polygons.length; j++) {
					// polygon and it self is not a pair
					if (j != i) {
						normalsJ 	= polygons[j].getNormals();
						centerJ 	= polygons[j].getCenter();

						// If there is collision between to polygons
						//   i.e. : (if all the projection axis overlap)
						// We will choose the shortest displacement vector
						// and move the polygon, who's axis is not the basis
						// of the displacement vector, along the displacement
						// vector.

						// Find the smallest displacement vector
						// If no vector is <= 0
						//   resolve

						var displacement:Vector2 = new Vector2();
						var temp_dis:Vector2 = new Vector2();
						var collision:Boolean = true; // assume true, prove false
						var shortestIsI:Boolean = true;
						// for each normal: Check polygons[i] on polygons[j]
						for( k = 0; k < normalsI.length; k++ ) {
							// calculate the projection axis
							axis = normalsI[k].clone();
							// if displacement is the 0 vector, no collision
							temp_dis = displacement;
							displacement = displacementRegularConvexPolygonsOverlapOnAxis(axis, centerI, polygons[i].getVertices(), centerJ, polygons[j].getVertices());
							if(!Vector2.dot(displacement,displacement)) {
								collision = false;
								break;
							} else {
								if(Vector2.dot(temp_dis,temp_dis) < Vector2.dot(displacement,displacement)) {
									if (Vector2.dot(temp_dis,temp_dis)) // !0
											displacement = temp_dis;
								}
							}
							
						}
						// do not need to check polygons[j] on polygons[i] if there's no collision
						if (collision) {
							// for each normal: Check polygons[j] on polygons[i]
							for( k = 0; k < normalsJ.length; k++ ) {
								// calculate the projection axis
								axis = normalsJ[k].clone();
								// if displacement is not zero
								temp_dis = displacement;
								displacement = displacementRegularConvexPolygonsOverlapOnAxis(axis, centerI, polygons[i].getVertices(), centerJ, polygons[j].getVertices());
								if(!Vector2.dot(displacement,displacement)) {
									collision = false;
									break;
								} else {
									if(Vector2.dot(temp_dis,temp_dis) < Vector2.dot(displacement,displacement)) {
										if (Vector2.dot(temp_dis,temp_dis)) {// !0
											displacement = temp_dis;
											shortestIsI = false;
										}
									}
								}
							}

							// if there is still a collision, resolve using displacemt
							if (collision) {
								debugVec = displacement;
								if (polygons[i].getMass() < polygons[j].getMass()) {
									if (!shortestIsI) 
										polygons[i].setCenter(centerI.add(displacement));
									else
										polygons[i].setCenter(centerI.add(displacement.multiply(-1)));
								} else {
									if (shortestIsI) 
										polygons[j].setCenter(centerJ.add(displacement));
									else
										polygons[j].setCenter(centerJ.add(displacement.multiply(-1)));
								}
							}								
						}
						
					}
				}
			}
			return debugVec;
			// if we haven't found a collision by now, there's nothing left to check, there is no collision
			//return false;
		}

		/* * * * * * * * * *
		 * Private Methods  *
		 * * * * * * * * * */
		private function projectionAxisFromNormal(normal:Vector2):Vector2 {
			// rotate the axis pi/2 rad to make it perpendicular to the normal
			return normal.clone().rotate(Math.PI/2);
		}

		private function displacementRegularConvexPolygonsOverlapOnAxis(axis:Vector2, center1:Vector2, vertices1:Vector.<Vector2>, center2:Vector2, vertices2:Vector.<Vector2>):Vector2 {
			var displacement:Vector2 = new Vector2();
			// Project this polygon onto the axis
			// Create vectors that point from the center of the box to each of the box's vertices
			// Take the dot product of each of theses vectors with the  projection axis vector
			// The vectors that produce the min and max dot products are what we need.
			// Project 
			var max1:Number = Number.NEGATIVE_INFINITY, 
				min1:Number = Number.POSITIVE_INFINITY,
				max2:Number = Number.NEGATIVE_INFINITY,
				min2:Number = Number.POSITIVE_INFINITY;
			var i:int, dot:Number;
			for(i = 0; i < vertices1.length; i++) {
				dot = Vector2.dot(vertices1[i].clone().add(center1), axis);
				if (dot > max1) max1 = dot;
				if (dot < min1) min1 = dot;
			}

			for(i = 0; i < vertices2.length; i++) {
				dot = Vector2.dot(vertices2[i].clone().add(center2), axis);
				if (dot > max2) max2 = dot;
				if (dot < min2) min2 = dot;
			}

			if (max1 > min2 && min1 < min2) {
				// do overlap, calculate the displacement vector
				displacement = axis.clone().multiply( min2 - max1);
			} else if (max1 > max2 && min1 < max2) {
				// do overlap, calculate the displacement vector
				displacement = axis.clone().multiply(max2 - min1);
			}

			return displacement;
		}

		private function doRegularConvexPolygonsOverlapOnAxis(axis:Vector2, center1:Vector2, vertices1:Vector.<Vector2>, center2:Vector2, vertices2:Vector.<Vector2>):Boolean {
			// Project this polygon onto the axis
			// Create vectors that point from the center of the box to each of the box's vertices
			// Take the dot product of each of theses vectors with the  projection axis vector
			// The vectors that produce the min and max dot products are what we need.
			// Project 
			var max1:Number = Number.NEGATIVE_INFINITY, 
				min1:Number = Number.POSITIVE_INFINITY,
				max2:Number = Number.NEGATIVE_INFINITY,
				min2:Number = Number.POSITIVE_INFINITY;
			var i:int, dot:Number;
			for(i = 0; i < vertices1.length; i++) {
				dot = Vector2.dot(vertices1[i].clone().add(center1), axis);
				if (dot > max1) max1 = dot;
				if (dot < min1) min1 = dot;
			}

			for(i = 0; i < vertices2.length; i++) {
				dot = Vector2.dot(vertices2[i].clone().add(center2), axis);
				if (dot > max2) max2 = dot;
				if (dot < min2) min2 = dot;
			}

			if (	(max1 > min2 && min1 < min2) || (max1 > max2 && min1 < max2) )
				return true;
			return false;
		}

		private function drawProjectionAxis(axis:Vector2, center:Vector2, normal:Vector2, length:Number, distance:Number):void {
			// pick two points along the axis to form a line, above, we've choosen a length related to the polygon's radius
			var p0:Vector2 = axis.clone().multiply(-length/2);
			var p1:Vector2 = axis.clone().multiply( length/2);
			
			// then translate the line's 'origin' be the same as the polygon's
			p0.add(center);
			p1.add(center);

			// then translate the line (made by the two points) along the normal away from the polygon
			p0.add(normal.clone().rotate(Math.PI/2).multiply(distance));
			p1.add(normal.clone().rotate(Math.PI/2).multiply(distance));
			
			// draw the line!
			graphics.lineStyle(0.1, 0xFFFFFF, 0.2);
			graphics.moveTo(p0.x, p0.y);
			graphics.lineTo(p1.x, p1.y);
		}

		private function drawProjectionOfRegularConvexPolygonOnAxis(polygon:RegularConvexPolygon, axis:Vector2, center:Vector2, normal:Vector2, distance:Number):void {
			var vertices:Vector.<Vector2> = polygon.getVertices();
			var newcolor:Number = polygon.getColor();
			var newCenter:Vector2 = polygon.getCenter();

			
			// Project this polygon onto the axis
			// Create vectors that point from the center of the box to each of the box's vertices
			// Take the dot product of each of theses vectors with the  projection axis vector
			// The vectors that produce the min and max dot products are what we need.
			// Project 
			var max:Number = 0, min:Number = 0, minIndex:int, maxIndex:int;
			var k:int, dot:Number;
			for(k = 0; k < vertices.length; k++) {
				dot = Vector2.dot(vertices[k], axis);
				if (dot > max) {
					max = dot;
					maxIndex = k;
				}
				if (dot < min) {
					min = dot;
					minIndex = k;
				}
			}
			// (I think) using min & max like this works because axis is normlized
			// current polygon's coordinate system
			var p0:Vector2 = axis.clone().multiply(min);
			var p1:Vector2 = axis.clone().multiply(max);

			dot = Vector2.dot( Vector2.Vector2FromVector2s(center, newCenter), axis);
			var translatedCenter:Vector2 = axis.clone().multiply(dot);

			// translate along the projection axis to appropriate location 
			p0.add(translatedCenter);
			p1.add(translatedCenter);
			
			// then translate the line's 'origin' be the same as the polygon's
			p0.add(center);
			p1.add(center);
			
			// then translate the line (made by the two points) along the normal away from the polygon
			p0.add(normal.clone().rotate(Math.PI/2).multiply(distance));
			p1.add(normal.clone().rotate(Math.PI/2).multiply(distance));
			
			
			// plot the points
			graphics.lineStyle(0.1, newcolor, 1);
			graphics.moveTo(p0.x, p0.y);
			graphics.lineTo(p1.x, p1.y);
			
			// plot the points
			
			graphics.beginFill(newcolor, 0.05);
			graphics.lineStyle();
			graphics.moveTo(newCenter.x + vertices[minIndex].x, newCenter.y + vertices[minIndex].y);
			graphics.lineTo(p0.x, p0.y);
			graphics.lineTo(p1.x, p1.y);
			graphics.lineTo(newCenter.x + vertices[maxIndex].x, newCenter.y + vertices[maxIndex].y);
			graphics.endFill();
		}
	}
}