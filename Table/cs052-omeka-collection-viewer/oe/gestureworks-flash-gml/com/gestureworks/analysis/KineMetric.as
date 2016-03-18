////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    clusterKinemetric.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.analysis 
{
	/**
 * @private
 */
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.interfaces.ITouchObject3D;
	import com.gestureworks.objects.PointObject;
	//import com.gestureworks.objects.MotionPointObject;
	//import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.GesturePointObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.managers.PointPairHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	
	//import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	
	import com.gestureworks.core.TouchSprite; 
	import com.gestureworks.core.TouchMovieClip; 
	
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
	import flash.utils.*;
		
	public class KineMetric
	{
		//////////////////////////////////////
		// ARITHMETIC CONSTANTS
		//////////////////////////////////////
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		
		private var touchObjectID:int;
		private var ts:Object;//private var ts:TouchSprite;
		private var cO:ClusterObject;
		//private var mcO:ipClusterObject = new ipClusterObject(); 	//MOTION SUPER
		private var tcO:ipClusterObject = new ipClusterObject(); 	//TOUCH SUPER
		//private var scO:ipClusterObject = new ipClusterObject(); 	//SENSOR SUPER
		
		private var i:uint = 0;
		private var j:uint = 0;
		
		///////////////////////////////////////////////////////////
		//SUPER CLUSTER POINT TOTALS
		public var N:uint = 0;
		private var N1:uint = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		
		////////////////////////////////////////////////////////////
		// TOUCH POINT TOTALS
		public var tpn:uint = 0;
						//public var LN:uint = 0; //locked touch points
		private var tpn1:uint = 0;
		private var tpnk0:Number  = 0;
		private var tpnk1:Number  = 0;
		private var mc:uint = 0; //MOVE COUNT
		
		private var rk:Number = 0.4; // rotation const
		private var sck:Number = 0.0044;// separate base scale const
		private var pvk:Number = 0.00004;//pivot base const
		
		///////////////////////////////////////////////////////
		// INTERACTION POINT TOTALS
		private var ipn:uint = 0;
		private var dipn:int = 0;
		private var ipnk:Number = 0;
		private var ipnk0:Number = 0;
		
		//TAP COUNTS TO BE MOVED
		private var mxTapID:uint = 0;
		private var myTapID:uint = 0;
		private var mzTapID:uint = 0;
		
		private var mHoldID:uint = 0;
		
		private var gms:ITouchObject;
		private var sw:int
		private var sh:int
		
		//hand config object
		private var handConfig:Object = new Object();
		
		// min max leap raw values
		// NOTE MOTION POINT SENSITIVITY TO PINCH/TRIGGER/ CONSTS AS SHOULD BE RELATIVE??????
		// AND HIT TEST
		private var minX:Number //=-220//180 
		private var maxX:Number //=220//180
		private var minY:Number //=350//270 
		private var maxY:Number //=120//50//-75
		private var minZ:Number //=350//270 
		private var maxZ:Number //=120//50//-75
		
		public static var hitTest3D:Function;	
		
		public function KineMetric(_id:int) 
		{
			//trace("KineMetric::constructor");
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			//trace("KineMetric::init");
			
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = ts.cO; // super cluster
			
			tcO = cO.tcO; //parent touch cluster
			//mcO = cO.mcO; // parent motion cluster
			//scO = ts.scO; // parent sensor cluster
			
			
			//gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];
			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			
			
			minX = GestureGlobals.gw_public::leapMinX;
			maxX = GestureGlobals.gw_public::leapMaxX;
			minY = GestureGlobals.gw_public::leapMinY;
			maxY = GestureGlobals.gw_public::leapMaxY;
			minZ = GestureGlobals.gw_public::leapMinZ;
			maxZ = GestureGlobals.gw_public::leapMaxZ;
			
			// CREATE INTERACTION POINT SUBCLUSTERS
			//if (ts.motionEnabled)initSubClusters();
			
			if (ts.traceDebugMode) trace("init cluster kinemetric");
		}
		
		
		
		
		public function initSensorSubClusters():void
		{
			//SENSOR SUBCLUSTERS
			// accelerometer
			// myo
			// watch
			// wii remote
		}
		
		
		public function findRootClusterConstants():void
		{
			//trace("KineMetric::findRootClusterConstants");
			
				//if (ts.traceDebugMode) trace("find cluster..............................",N);
				
				///////////////////////////////////////////////
				// get number of touch points in cluster
				N = ts.cO.tpn + ts.cO.ipn;
				cO.n = N;
				
				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) N1 = 0;
				}
		}
		
		public function resetRootCluster():void 
		{
			//trace("KineMetric::resetRootCluster");
			
			cO.x = 0;
			cO.y = 0;
			cO.z = 0;//-3D
			cO.width = 0;
			cO.height = 0;
			cO.length = 0;//-3D
			cO.radius = 0;
			
			//cO.separation
			cO.separationX = 0;
			cO.separationY = 0;
			cO.separationZ = 0;//-3D
			
			cO.rotation = 0;
			cO.rotationX = 0;//-3D
			cO.rotationY = 0;//-3D
			cO.rotationZ = 0;//-3D
			
			cO.orientation =  0;
			//cO.thumbID = 0;
			//cO.hand_normal = 0;
			//cO.hand_radius = 0;
			
			cO.mx = 0;
			cO.my = 0;
			cO.mz = 0;//-
			
			//////////////////////////////////
			////////////////////////////////////
			cO.orient_dx = 0;
			cO.orient_dy = 0;
			cO.orient_dz = 0;//-3D
			cO.pivot_dtheta = 0;
		
			/////////////////////////
			// first diff
			/////////////////////////
			cO.dtheta = 0;
			cO.dthetaX = 0;
			cO.dthetaY = 0;
			cO.dthetaZ = 0;
			cO.dtheta = 0;
			cO.dx = 0;
			cO.dy = 0;
			cO.dz = 0;//-3D
			cO.ds = 0;
			cO.dsx = 0;
			cO.dsy = 0;
			cO.dsz = 0;//-
			cO.etm_dx = 0;
			cO.etm_dy = 0;
			cO.etm_dz = 0;//-3D
			
			////////////////////////
			// second diff
			////////////////////////
			cO.ddx = 0;
			cO.ddy = 0;
			cO.ddz = 0;//-
			
			cO.etm_ddx = 0;
			cO.etm_ddy = 0;
			cO.etm_ddz = 0;//-3D
			
			////////////////////////////
			// sub cluster analysis
			// NEED TO MOVE INTO IPOINTARRAY
			////////////////////////////
			cO.hold_x = 0;
			cO.hold_y = 0;
			cO.hold_z = 0;//-3D
			cO.hold_n = 0;
			
			//accelerometer
			//SENSOR
			//cO.ax =0
			//cO.ay =0
			//cO.az =0
			//cO.atheta =0
			//cO.dax =0
			//cO.day =0
			//cO.daz =0
			//cO.datheta =0
			
			//cO.gPointArray = new Vector.<GesturePointObject>;
		}
		
		

		/////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		// TOUCH CLUSTER ANALYSIS
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		public function findTouchClusterConstants():void
		{
			//trace("KineMetric::findTouchClusterConstants");

				//if (ts.traceDebugMode) trace("find cluster..............................",N);
				
				///////////////////////////////////////////////
				// get number of touch points in cluster
				//tpn = ts.cO.tcO.pointArray.length;
				tpn = ts.cO.pointArray.length;
				
				ts.tpn = tpn;
				ts.cO.tpn = tpn;
				ts.cO.tcO.tpn = tpn;
				
				//TODO: NEED TO FIX lock number
				//LN = ts.tcO.hold_n // will need to move to interaction point structure or temporal metric mgmt
				
				// derived point totals
				if (tpn) 
				{
					tpn1 = tpn - 1;
					tpnk0 = 1 / tpn;
					tpnk1 = 1 / tpn1;
					if (tpn == 0) tpnk1 = 0;
					//pointList = cO.pointArray; // copy most recent point array data
					mc = cO.pointArray[0].moveCount; // get sample move count value
				}
		}
		
		
		
		public function resetTouchCluster():void 
		{
			//trace("KineMetric::resetTouchCluster");

			tcO.x = 0;
			tcO.y = 0;
			tcO.z = 0;//-3D
			tcO.width = 0;
			tcO.height = 0;
			tcO.length = 0;//-3D
			tcO.radius = 0;
			
			//cO.separation
			tcO.separationX = 0;
			tcO.separationY = 0;
			tcO.separationZ = 0;//-3D
			
			tcO.rotation = 0;
			tcO.rotationX = 0;//-3D
			tcO.rotationY = 0;//-3D
			tcO.rotationZ = 0;//-3D
			
			tcO.orientation =  0;
			//cO.thumbID = 0;
			//cO.hand_normal = 0;
			//cO.hand_radius = 0;
			
			tcO.mx = 0;
			tcO.my = 0;
			tcO.mz = 0;//-
			
			//////////////////////////////////
			////////////////////////////////////
			tcO.orient_dx = 0;
			tcO.orient_dy = 0;
			cO.orient_dz = 0;//-3D
			tcO.pivot_dtheta = 0;
		
			/////////////////////////
			// first diff
			/////////////////////////
			tcO.dtheta = 0;
			tcO.dthetaX = 0;
			tcO.dthetaY = 0;
			tcO.dthetaZ = 0;
			tcO.dx = 0;
			tcO.dy = 0;
			tcO.dz = 0;//-3D
			tcO.ds = 0;
			tcO.dsx = 0;
			tcO.dsy = 0;
			tcO.dsz = 0;//-
			tcO.etm_dx = 0;
			tcO.etm_dy = 0;
			tcO.etm_dz = 0;//-3D
			
			////////////////////////
			// second diff
			////////////////////////
			tcO.ddx = 0;
			tcO.ddy = 0;
			tcO.ddz = 0;//-
			
			tcO.etm_ddx = 0;
			tcO.etm_ddy = 0;
			tcO.etm_ddz = 0;//-3D
			
			////////////////////////////
			// sub cluster analysis
			// NEED TO MOVE INTO IPOINTARRAY
			////////////////////////////
			tcO.hold_x = 0;
			tcO.hold_y = 0;
			tcO.hold_z = 0;//-3D
			tcO.hold_n = 0;
		}
		
		
		public function findTouchInstDimention():void
		{
			//trace("KineMetric::findTouchInstDimention");

			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster width, height and radius // OPERATION
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// basic cluster property values 
			// uses the current position of the points in the cluster to find the spread of the cluster and its current dims
					
					tcO.x = 0; 
					tcO.y = 0;
					tcO.z = 0;
					tcO.radius = 0;
					tcO.width = 0;
					tcO.height = 0;
					tcO.length = 0;
					
					tcO.separationX = 0;
					tcO.separationY = 0;
					tcO.separationZ = 0;
					tcO.rotation = 0;
					tcO.dtheta = 0;
					tcO.dthetaX = 0;
					tcO.dthetaY = 0;
					tcO.dthetaZ = 0;
					tcO.mx = 0;
					tcO.my = 0;
					tcO.mz = 0;
					
					
					
					if (tpn == 1)
					{
						tcO.x = cO.pointArray[0].x;
						tcO.y = cO.pointArray[0].y;
						tcO.z = cO.pointArray[0].z;
						tcO.mx = cO.pointArray[0].x;
						tcO.my = cO.pointArray[0].y;
						tcO.mz = cO.pointArray[0].z;
					}
					
					else if (tpn > 1)
						{	
						for (i = 1; i < tpn; i++)
						{
							for (var j1:uint = 0; j1 < tpn; j1++)
							{
								if ((i != j1) && (cO.pointArray[i]) && (cO.pointArray[j1]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock))//edit
									{
										//trace("dim",N);
										var dx:Number = cO.pointArray[i].x - cO.pointArray[j1].x;
										var dy:Number = cO.pointArray[i].y - cO.pointArray[j1].y;
										var dz:Number = cO.pointArray[i].z - cO.pointArray[j1].z;
										var ds:Number  = Math.sqrt(dx * dx + dy * dy + dz * dz);
											
										// diameter, radius of group
										if (ds > tcO.radius)
										{
											tcO.radius = ds *0.5;
										}
										// width of group
										var abs_dx:Number = Math.abs(dx);
										if (abs_dx > tcO.width)
										{
											tcO.width = abs_dx;
											tcO.x = cO.pointArray[i].x -(dx*0.5);
										}
										// height of group
										var abs_dy:Number = Math.abs(dy);
										if (abs_dy > tcO.height)
										{
											tcO.height = abs_dy;
											tcO.y = cO.pointArray[i].y -(dy* 0.5);
										} 
										// length of group
										var abs_dz:Number = Math.abs(dz);
										if (abs_dz > tcO.length)
										{
											tcO.length = abs_dz;
											tcO.z = cO.pointArray[i].z -(dz* 0.5);
										} 										
										// NOTE NEED TO FIX AS CO.X CAN BE SAME AS CO.MX
										
										
										// mean point position
										tcO.mx += cO.pointArray[i].x;
										tcO.my += cO.pointArray[i].y;
										tcO.mz += cO.pointArray[i].z;
									}
							}
							
							
							// inst separation and rotation
							if ((cO.pointArray[0]) && (cO.pointArray[i]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
							{
								var dxs:Number = cO.pointArray[0].x - cO.pointArray[i].x;
								var dys:Number = cO.pointArray[0].y - cO.pointArray[i].y;
								var dzs:Number = cO.pointArray[0].z - cO.pointArray[i].z;
								//var ds:Number  = Math.sqrt(dx * dx + dy * dy);

								// separation of group
								tcO.separationX += Math.abs(dxs);
								tcO.separationY += Math.abs(dys);
								tcO.separationZ += Math.abs(dzs);
								
								
								// rotation of group
								//tcO.rotation += (calcAngle(dxs, dys)) //|| 0 // TODO: ADD 3D 
								//tcO.dthetaX = tcO.rotation; //|| 0 // TODO: ADD 3D


								//tcO.dtheta += dtheta;
								tcO.dthetaX += calcAngle(dys, dzs);
								tcO.dthetaY += calcAngle(dxs, dzs);
								tcO.dthetaZ += calcAngle(dxs, dys);
								
								tcO.rotation = tcO.dthetaZ;								
								//tcO.dtheta = tcO.dthetaX + tcO.dthetaY + tcO.dthetaZ;																

							}
						}
						/*
						//c_s *= k0;
						c_sx *= k0;
						c_sy *= k0;
						c_theta *= k0;
						c_emx *= k0;
						c_emy *= k0;
						*/
						tcO.separationX *= tpnk0;
						tcO.separationY *= tpnk0;
						tcO.separationZ *= tpnk0;
						tcO.rotation *= tpnk0;
						tcO.dthetaX *= tpnk0;
						tcO.dthetaY *= tpnk0;
						tcO.dthetaZ *= tpnk0;
						tcO.mx *= tpnk0;
						tcO.my *= tpnk0;
						tcO.mz *= tpnk0;
					}
					
				//trace("kinemetric inst dims", cO.x,cO.y);
		}
		
		
		public function findSimpleMeanInstTransformation():void
		{
			//trace("KineMetric::findSimpleMeanInstTransformation");
			
			
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// cluster tranformation // OPERATION
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (tpn == 1) 
			{
				// DO NOT SET OTHER DELTAS TO ZERO IN OPERATOR
				tcO.dx = cO.pointArray[0].DX;
				tcO.dy = cO.pointArray[0].DY;
				tcO.dz = cO.pointArray[0].DZ;
				//trace("cluster- porcessing", c_dx,c_dy);
			}
			else if (tpn > 1)
				{
					for (i = 0; i < tpn; i++) 
						{	
							// translate	
							tcO.dx += cO.pointArray[i].DX;
							tcO.dy += cO.pointArray[i].DY;
							tcO.dz += cO.pointArray[i].DZ;
						}
						//var theta0:Number = calcAngle(sx, sy);
						//var theta1:Number = calcAngle(sx_mc, sy_mc); // could eliminate in point pair

						tcO.dx *= tpnk0;
						tcO.dy *= tpnk0;
						tcO.dz *= tpnk0;
								
						if (tcO.history[1])
								{
									//////////////////////////////////////////////////////////
									// CHANGE IN SEPARATION
									if ((tcO.history[1].radius != 0) && (tcO.rotation != 0)) 
									{
										tcO.ds = (tcO.radius - tcO.history[1].radius) * sck;
									}
									//trace(cO.radius, cO.history[mc].radius);
									
									//////////////////////////////////////////////////////////
									// CHANGE IN ROTATION
									if ((tcO.history[1].rotation != 0) && (tcO.rotation != 0)) 
									{
										if (Math.abs(tcO.rotation - tcO.history[1].rotation) > 90) tcO.dtheta = 0
										else tcO.dtheta = (tcO.rotation - tcO.history[1].rotation);	
									}
									//trace(cO.rotation, cO.history[1].rotation, cO.dtheta);
								}
				}
		}
		
		public function findMeanInstTransformation():void
		{
			
			//trace("KineMetric::findMeanInstTransformation");

			// these values required reset for manipulate
			tcO.dthetaX = 0;
			tcO.dthetaY = 0;
			tcO.dthetaZ = 0;
			tcO.dtheta = 0;
			
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// cluster tranformation // OPERATION
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (tpn == 1) 
			{
				// DO NOT SET OTHER DELTAS TO ZERO IN OPERATOR
				tcO.dx = cO.pointArray[0].DX;
				tcO.dy = cO.pointArray[0].DY;
				tcO.dz = cO.pointArray[0].DZ;
				//trace("cluster- porcessing", c_dx,c_dy);
			}
				else if (tpn > 1)
							{
							//cO.ds = 0;	
							//cO.dsx = 0;	
							//cO.dsy = 0;	
							
							var sx:Number = 0;
							var sy:Number = 0;
							var sz:Number = 0;
							var sx_mc:Number = 0;
							var sy_mc:Number = 0;
							var sz_mc:Number = 0;
						//	var ds:Number = 0;
								
						
								for (i = 0; i < tpn; i++) 
								{	
									/////////////////////////////////////////////
									// translate
									tcO.dx += cO.pointArray[i].DX;
									tcO.dy += cO.pointArray[i].DY;
									tcO.dz += cO.pointArray[i].DZ;

									if ((tpn > i + 1) && (cO.pointArray[0].history.length > mc) && (cO.pointArray[i + 1].history.length > mc))
										{
										////////////////////////////////////////
										// scale 
										sx += cO.pointArray[0].x - cO.pointArray[i + 1].x;
										sy += cO.pointArray[0].y - cO.pointArray[i + 1].y;
										sz += cO.pointArray[0].z - cO.pointArray[i + 1].z;
										sx_mc += cO.pointArray[0].history[mc].x - cO.pointArray[i + 1].history[mc].x;// could eliminate in point pair
										sy_mc += cO.pointArray[0].history[mc].y - cO.pointArray[i + 1].history[mc].y;// could eliminate in point pair
										sz_mc += cO.pointArray[0].history[mc].z - cO.pointArray[i + 1].history[mc].z;// could eliminate in point pair
										
										////////////////////////////////////////////
										// rotate
										//var dtheta:Number = 0;
										var dthetax:Number = 0;
										var dthetay:Number = 0;
										var dthetaz:Number = 0;
										
										//var theta0:Number = calcAngle(sx, sy);
										//var theta1:Number = calcAngle(sx_mc, sy_mc); // could eliminate in point pair
										var theta0x:Number = calcAngle(sy, sz);
										var theta1x:Number = calcAngle(sy_mc, sz_mc);
										var theta0y:Number = calcAngle(sx, sz);
										var theta1y:Number = calcAngle(sx_mc, sz_mc); 
										var theta0z:Number = calcAngle(sx, sy);
										var theta1z:Number = calcAngle(sx_mc, sy_mc); 
										
										//if ((theta0 != 0) && (theta1 != 0)) 
											//{
											//if (Math.abs(theta0 - theta1) > 180) dtheta = 0
											//else dtheta = (theta0 - theta1);
											//}
										//else dtheta = 0;
												
										if ((theta0x != 0) && (theta1x != 0)) 
											{
											if (Math.abs(theta0x - theta1x) > 180) dthetax = 0
											else dthetax = (theta0x - theta1x);
											}
										else dthetax = 0;
												
										if ((theta0y != 0) && (theta1y != 0)) 
											{
											if (Math.abs(theta0y - theta1y) > 180) dthetay = 0
											else dthetay = (theta0y - theta1y);
											}
										else dthetay = 0;
		
										if ((theta0z != 0) && (theta1z != 0)) 
											{
											if (Math.abs(theta0z - theta1z) > 180) dthetaz = 0
											else dthetaz = (theta0z - theta1z);
											}
										else dthetaz = 0;
		
										//tcO.dtheta += dtheta;
										tcO.dthetaX += dthetax;
										tcO.dthetaY += dthetay;
										tcO.dthetaZ += dthetaz;
										tcO.dtheta = tcO.dthetaX + tcO.dthetaY + tcO.dthetaZ;

										}	
								}
								
								// FIND C_DSX AND C_DSY AGGREGATE THEN AS A LAST STEP FIND THE SQUARE OF THE DISTANCE BETWEEN TO GET C_DS
								//c_ds = Math.sqrt(c_dsx*c_dsx + c_dsy*c_dsy)
								
								tcO.dx *= tpnk0;
								tcO.dy *= tpnk0;
								tcO.dz *= tpnk0;
								
								//tcO.dtheta *= tpnk1;
								tcO.dthetaX *= tpnk1;
								tcO.dthetaY *= tpnk1;
								tcO.dthetaZ *= tpnk1;
								tcO.dtheta = tcO.dthetaX + tcO.dthetaY + tcO.dthetaZ;
								
								
								tcO.ds = (Math.sqrt(sx * sx + sy * sy + sz * sz) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc + sz_mc * sz_mc)) * tpnk1 * sck;

			}
		//trace("transfromation",tcO.dx,tcO.dy, tcO.ds,tcO.dtheta)
		}
		
		public function findMeanInstTranslation():void
		{
			//trace("KineMetric::findMeanInstTranslation");

			
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster translation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// translation values 
					// finds how far the cluster has moved between the current frame and a frame in history
						tcO.dx = 0;
						tcO.dy = 0;
						tcO.dz = 0;
					
					if (tpn == 1) 
						{
							if (cO.pointArray[0])
								{
								tcO.dx = cO.pointArray[0].DX;
								tcO.dy = cO.pointArray[0].DY;
								tcO.dz = cO.pointArray[0].DZ;
								}
						}
					else if (tpn > 1)
					{
						for (i = 0; i < tpn; i++) 
						{
								if (cO.pointArray[i])//&&(!pointList[i].holdLock))// edit
								{
									// SIMPLIFIED DELTa
									tcO.dx += cO.pointArray[i].DX;
									tcO.dy += cO.pointArray[i].DY;
									tcO.dz += cO.pointArray[i].DZ;
								}	
						}
						tcO.dx *= tpnk0;
						tcO.dy *= tpnk0;
						tcO.dz *= tpnk0;
					}
					//	trace("drag calc kine",c_dx,c_dy);
		}
		
		public function findSimpleMeanInstSeparation():void
		{
			//trace("KineMetric::findSimpleMeanInstSeparation");

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster separation //OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			// finds the change in the separation of the cluster between the current frame and a previous frame in history
			tcO.ds = 0;
			tcO.dsx = 0;
			tcO.dsy = 0;
			tcO.dsz = 0;
					
					if (tpn > 1)
					{	
						if (tcO.history[1])
						{
							if (tcO.history[1].radius != 0) tcO.ds = (tcO.radius - tcO.history[1].radius) * sck;
							if (tcO.history[1].width != 0) tcO.dsx = (tcO.width - tcO.history[1].width) * sck;
							if (tcO.history[1].height != 0) tcO.dsy = (tcO.height - tcO.history[1].height) * sck;
							if (tcO.history[1].length != 0) tcO.dsz = (tcO.length - tcO.history[1].length) * sck;
						} 
					}
		}
		
		public function findMeanInstSeparation():void
		{
			//trace("KineMetric::findMeanInstSeparation");

			
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
					tcO.ds = 0;
					tcO.dsx = 0;
					tcO.dsy = 0;
					tcO.dsz = 0;
					
					if (tpn > 1)
					{	
						var sx:Number = 0;
						var sy:Number = 0;
						var sz:Number = 0;
						var sx_mc:Number = 0;
						var sy_mc:Number = 0;
						var sz_mc:Number = 0;
						
						for (i = 0; i < tpn; i++) 
						{
							//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
							if ((tpn>i+1)&&(cO.pointArray[0].history.length>mc) && (cO.pointArray[i + 1].history.length>mc))
							{		
								sx = Math.abs(cO.pointArray[0].x - cO.pointArray[i + 1].x);
								sy = Math.abs(cO.pointArray[0].y - cO.pointArray[i + 1].y);
								sz = Math.abs(cO.pointArray[0].z - cO.pointArray[i + 1].z);
								sx_mc = Math.abs(cO.pointArray[0].history[mc].x - cO.pointArray[i + 1].history[mc].x);
								sy_mc = Math.abs(cO.pointArray[0].history[mc].y - cO.pointArray[i + 1].history[mc].y);
								sz_mc = Math.abs(cO.pointArray[0].history[mc].z - cO.pointArray[i + 1].history[mc].z);
								
								//c_ds += (Math.sqrt((pointList[0].history[0].x - pointList[i + 1].history[0].x) * (pointList[0].history[0].x - pointList[i + 1].history[0].x) + (pointList[0].history[0].y - pointList[i + 1].history[0].y) * (pointList[0].history[0].y - pointList[i + 1].history[0].y)) - Math.sqrt((pointList[0].history[mc].x - pointList[i + 1].history[mc].x) * (pointList[0].history[mc].x - pointList[i + 1].history[mc].x) + (pointList[0].history[mc].y - pointList[i + 1].history[mc].y) * (pointList[0].history[mc].y - pointList[i + 1].history[mc].y)))
								tcO.ds += (Math.sqrt(sx * sx + sy * sy + sz * sz) - Math.sqrt(sx_mc * sx_mc + sy_mc * sy_mc + sz_mc * sz_mc));
								tcO.dsx += (sx - sx_mc)//Math.sqrt(sx * sx - sx_mc * sx_mc);
								tcO.dsy += (sy - sy_mc)//Math.sqrt(sy * sy - sy_mc * sy_mc);
								tcO.dsz += (sz - sz_mc)//Math.sqrt(sz * sz - sz_mc * sz_mc);
							}
						}
					
					//c_dsx = (sx - sx_mc)*k1;
					//c_dsy = (sy - sy_mc)*k1;	
						
					//c_ds *= k1;	
					tcO.ds *= tpnk1 * sck;//(Math.sqrt(sx * sx + sy * sy) - Math.sqrt(sx_mc * sx_mc + sy_mc * sy_mc))*k1 * sck;
					tcO.dsx *= tpnk1 * sck; //(sx - sx_mc)*k1 * sck;//(Math.sqrt((sx * sx) - (sx_mc * sx_mc)))*k1 * sck;//cO.ds;
					tcO.dsy *= tpnk1 * sck; //(sy - sy_mc)*k1 * sck;//(Math.sqrt((sy * sy) - (sy_mc * sy_mc)))*k1 * sck;//cO.ds;
					tcO.dsz *= tpnk1 * sck; //(sy - sy_mc)*k1 * sck;//(Math.sqrt((sy * sy) - (sy_mc * sy_mc)))*k1 * sck;//cO.ds;
					//trace("mean inst separation");
					}
					
					
		}	
		
		public function findSimpleMeanInstRotation():void
		{
			//trace("KineMetric::findSimpleMeanInstRotation");			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster roation // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// finds the change in the rotation of the cluster between the current frame and a previous frame in history
			tcO.dtheta = 0;
						
			if(tpn>1)
				{	
				if (tcO.history[1])
					{
						if (tcO.history[1].rotation!=0) tcO.dtheta =(tcO.rotation - tcO.history[1].rotation)	 
					}					
				}
			//trace(cO.dtheta);
		}
		
		public function findMeanInstRotation():void
		{
			//trace("KineMetric::findMeanInstRotation");						
			
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster roation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the rotation of the cluster between the current frame and a previous frame in history

						tcO.dtheta = 0;
						tcO.dthetaX = 0;
						tcO.dthetaY = 0;
						tcO.dthetaZ = 0;
						
						if(tpn>1)
						{
						for (i = 0; i < tpn; i++) 
						{
								if ((tpn > i + 1)&&(cO.pointArray[0].history.length>mc) && (cO.pointArray[i + 1].history.length>mc))
								{		
									// SIMPLIFIED DELTA 
									var dtheta:Number = 0;
									var dthetaX:Number = 0;
									var dthetaY:Number = 0;
									var dthetaZ:Number = 0;

									var theta0:Number = calcAngle((cO.pointArray[0].x - cO.pointArray[i+1].x), (cO.pointArray[0].y - cO.pointArray[i+1].y));									
									var theta1:Number = calcAngle((cO.pointArray[0].history[mc].x - cO.pointArray[i+1].history[mc].x), (cO.pointArray[0].history[mc].y - cO.pointArray[i+1].history[mc].y));
								
									var theta0x:Number = calcAngle((cO.pointArray[0].y - cO.pointArray[i+1].y), (cO.pointArray[0].z - cO.pointArray[i+1].z));
									var theta1x:Number = calcAngle((cO.pointArray[0].history[mc].y - cO.pointArray[i + 1].history[mc].y), (cO.pointArray[0].history[mc].z - cO.pointArray[i + 1].history[mc].z));
									
									var theta0y:Number = -calcAngle((cO.pointArray[0].x - cO.pointArray[i+1].x), (cO.pointArray[0].z - cO.pointArray[i+1].z));
									var theta1y:Number = -calcAngle((cO.pointArray[0].history[mc].x - cO.pointArray[i+1].history[mc].x), (cO.pointArray[0].history[mc].z - cO.pointArray[i+1].history[mc].z));

									var theta0z:Number = calcAngle((cO.pointArray[0].x - cO.pointArray[i+1].x), (cO.pointArray[0].y - cO.pointArray[i+1].y));
									var theta1z:Number = calcAngle((cO.pointArray[0].history[mc].x - cO.pointArray[i+1].history[mc].x), (cO.pointArray[0].history[mc].y - cO.pointArray[i+1].history[mc].y));									
									
									if ((theta0 != 0) && (theta1 != 0)) 
										{
										if (Math.abs(theta0 - theta1) > 180) dtheta = 0
										else dtheta = (theta0 - theta1);
										}
									else dtheta = 0;
									if ((theta0x != 0) && (theta1x != 0)) 
										{
										if (Math.abs(theta0x - theta1x) > 180) dthetaX = 0
										else dthetaX = (theta0x - theta1x);
										}
									else dthetaX = 0;
									if ((theta0y != 0) && (theta1y != 0)) 
										{
										if (Math.abs(theta0y - theta1y) > 180) dthetaY = 0
										else dthetaY = (theta0y - theta1y);
										}
									else dthetaY = 0;	
									if ((theta0z != 0) && (theta1z != 0)) 
										{
										if (Math.abs(theta0z - theta1z) > 180) dthetaZ = 0
										else dthetaZ = (theta0z - theta1z);
										}
									else dthetaZ = 0;										
									tcO.dtheta += dtheta;
									tcO.dthetaX += dthetaX;
									tcO.dthetaY += dthetaY;
									tcO.dthetaZ += dthetaZ;									
								}
						}
						tcO.dtheta *= tpnk1;
						tcO.dthetaX *= tpnk1;
						tcO.dthetaY *= tpnk1;
						tcO.dthetaZ *= tpnk1;						
						//tcO.dtheta = tcO.dthetaX + tcO.dthetaY + tcO.dthetaZ;
						}
						//trace(cO.dtheta);
		}
		
		public function findMeanInstAcceleration():void
		{
			//trace("KineMetric::findMeanInstAcceleration");									
			
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster acceleration x y // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////

						tcO.ddx = 0;
						tcO.ddy = 0;
						tcO.ddz = 0;
						
						for (i = 0; i < tpn; i++) 
						{
							if (cO.pointArray[i].history[1])//&&(!pointList[i].holdLock))//edit
							{
								// SIMPLIFIED DELTAS
								// second diff of x anf y wrt t
								tcO.ddx += cO.pointArray[i].dx - cO.pointArray[i].history[1].dx;
								tcO.ddy += cO.pointArray[i].dy - cO.pointArray[i].history[1].dy;
								tcO.ddz += cO.pointArray[i].dz - cO.pointArray[i].history[1].dz;
							}
						}
						tcO.ddx *= tpnk0;
						tcO.ddy *= tpnk0;
						tcO.ddz *= tpnk0;
					
					/////////////////////////////////////////////////////////////////////////////////////	
		}
		
		public function findMeanTemporalVelocity():void
		{
			//trace("KineMetric::findMeanTemporalVelocity");	
			
		/////////////////////// mean velocity of cluster // OPERATION ////////////////////////////////////////
			tcO.etm_dx = 0;
			tcO.etm_dy = 0;
			tcO.etm_dz = 0;
			
			var t:Number = 2;
			var t0:Number = 1 /t;
					
			for (i = 0; i < tpn; i++) 
				{
					if(cO.pointArray[i].history.length>t)
					{
					for (j = 0; j < t; j++) 
						{
						tcO.etm_dx += cO.pointArray[i].history[j].dx;
						tcO.etm_dy += cO.pointArray[i].history[j].dy;
						tcO.etm_dz += cO.pointArray[i].history[j].dz;
						}
					}
			}
			//cO.etm_dx *= k0 * t0;
			//cO.etm_dy *= k0 * t0;

		} 
		
		public function findMeanTemporalAcceleration():void
		{
			//trace("KineMetric::findMeanTemporalAcceleration");	
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster acceleration x y // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			tcO.etm_ddx = 0;
			tcO.etm_ddy = 0;
			tcO.etm_ddz = 0;
			
			
				
			var t:Number = 2;
			var t0:Number = 1 /t;
						
				for (i = 0; i < tpn; i++) 
					{
					if(cO.pointArray[i].history.length>t)
						{
							// SIMPLIFIED DELTAS
							// second diff of x anf y wrt t
							for (j = 0; j < t; j++) 
							{
								tcO.etm_ddx += cO.pointArray[i].history[j + 1].dx - cO.pointArray[i].history[j].dx;
								tcO.etm_ddy += cO.pointArray[i].history[j + 1].dy -cO.pointArray[i].history[j].dy;
								tcO.etm_ddz += cO.pointArray[i].history[j + 1].dz -cO.pointArray[i].history[j].dz;
								//cO.etm_ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								//cO.etm_ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
					}
					//trace(k0, t0);
			//cO.etm_ddx *= k0 * t0;
			//cO.etm_ddy *= k0 * t0;
		}
		
		public function findInstOrientation():void 
		{
				//trace("KineMetric::findInstOrientation");			
			
				var handArray:Array = new Array();
				var maxDist:Number = 0;
				var maxAngle:Number = 0;
				var dist:Number = 0;
				var angle:Number = 180;
				
				tcO.orient_dx = 0;
				tcO.orient_dy = 0;	
						
							for (i = 0; i < tpn; i++) 
								{
									if (cO.pointArray[i].history[0])
									//if(pointList.length>i)
									{
										handArray[i] = new Array();
										handArray[i].id = cO.pointArray[i].id; // set point id
										handArray[i].touchPointID = cO.pointArray[i].touchPointID; // set point id
									
										// find distance between center of cluster and finger tip
										var dxe:Number = (cO.pointArray[i].history[0].x - cO.x);
										var dye:Number = (cO.pointArray[i].history[0].y - cO.y);
										
										// find diatance between mean center of cluster and finger tip
										var dxf:Number = (cO.pointArray[i].history[0].x - cO.mx);
										var dyf:Number = (cO.pointArray[i].history[0].y - cO.my);
										var ds1:Number = Math.sqrt(dxf * dxf + dyf * dyf)
										
										handArray[i].dist = ds1; // set distance from mean
										handArray[i].angle = 180; // init angle between vectors to radial center

										for (var q:int = 0; q < tpn; q++) 
										{
											if ((i != q)&&(cO.pointArray[q].history[0]))
												{
												var dxq:Number = (cO.pointArray[q].history[0].x - tcO.x);
												var dyq:Number = (cO.pointArray[q].history[0].y - tcO.y);
												angle = dotProduct(dxe, dye, dxq, dyq)*RAD_DEG;
												
												if (angle < handArray[i].angle) handArray[i].angle = angle;
												}
										}
									//trace("finger", handArray[i].id, handArray[i].dist, handArray[i].angle) // point list
									
									// find max angle
									if (maxAngle < handArray[i].angle) 		maxAngle = handArray[i].angle;
									// find min dist
									if (maxDist < handArray[i].dist) 	maxDist = handArray[i].dist;
								}
							}
							
							
							// calculate thumb probaility value
							for (i = 0; i < tpn; i++) 
								{
									handArray[i].prob = (handArray[i].angle/maxAngle + handArray[i].dist/maxDist)*0.5
								}
							handArray.sortOn("prob",Array.DESCENDING);
							
							///////////////////////////////////////////////////
							//NOW CORRECT UNIQUE ID
							tcO.thumbID = handArray[0].touchPointID;
							//tcO.thumbID = handArray[0].id;
							
							// BUT NEED TO FIX
							// RIGHT HAND RETURNS PINKY AS THUMB AS ANGLE INCORRECTLY CALCUKATED
							// NEED TO ALSO DETERMIN LEFT HAND AND RIGHT HAND
							//trace("hand angle",handArray[0].angle)
							
							//trace("ID", tcO.thumbID,handArray[0].id, handArray[0].touchPointID)
						
							// calc orientation vector // FIND ORIENTATION USING CLUSTER RADIAL CENTER
							for (i = 0; i < tpn; i++) 
								{
									if (cO.pointArray[i].id != handArray[0].id) 
									{	
										tcO.orient_dx += (cO.pointArray[i].history[0].x - tcO.x);
										tcO.orient_dy += (cO.pointArray[i].history[0].y - tcO.y);
									}
								}
							tcO.orient_dx *= tpnk1;
							tcO.orient_dy *= tpnk1;	
							
							
						
		}
		
		public function findInstPivot():void
		{
			//trace("KineMetric::findInstPivot");			

					//if (tpn == 1)
					if(tpn)
					{
						var x_c:Number = 0
						var y_c:Number = 0
						
						var dxh:Number = 0
						var dyh:Number = 0
						var dxi:Number = 0;
						var dyi:Number = 0;
						var pdist:Number = 0;
						var t0:Number = 0;
						var t1:Number = 0;
						var theta_diff:Number = 0
			
						tcO.pivot_dtheta = 0
					
						// CENTER OF DISPLAY OBJECT
						if (ts.trO.transAffinePoints) 
						{
							//trace("test", tO.transAffinePoints[4])
							x_c = ts.trO.transAffinePoints[4].x
							y_c = ts.trO.transAffinePoints[4].y
						}
						
								if (cO.pointArray.length==1)
								{
								if(cO.pointArray[0].history.length > 1 ) {
								//if (cO.pointArray[0].history.length>1) 
									
									// find touch point translation vector
									dxh = cO.pointArray[0].history[1].x - x_c;
									dyh = cO.pointArray[0].history[1].y - y_c;
											
									// find vector that connects the center of the object and the touch point
									dxi = cO.pointArray[0].x - x_c;
									dyi = cO.pointArray[0].y - y_c;
									pdist = Math.sqrt(dxi * dxi + dyi * dyi);
											
									t0 = calcAngle(dxh, dyh);
									t1 = calcAngle(dxi, dyi);
									if (t1 > 360) t1 = t1 - 360;
									if (t0 > 360) t0 = t0 - 360;
									
									theta_diff = t1 - t0
									
									if (theta_diff>300) theta_diff = theta_diff -360; //trace("Flicker +ve")
									if (theta_diff<-300) theta_diff = 360 + theta_diff; //trace("Flicker -ve");
									
									
									//pivot thresholds
									//if (Math.abs(theta_diff) > pivot_threshold)
									//{	
										// weighted effect
										tcO.pivot_dtheta = theta_diff*Math.pow(pdist, 2)*pvk;
										tcO.x = cO.pointArray[0].x;
										tcO.y = cO.pointArray[0].y;
									//}
									//else cO.pivot_dtheta = 0; 
									}
								}

								if (cO.pointArray.length>1) 
									{		
									//trace("hist",cO.pointArray[0].history.length,cO.pointArray[1].history.length)
									var cx1:Number = 0;
									var cy1:Number = 0;
									var cx0:Number = 0;
									var cy0:Number = 0;
									
										for (i = 0; i < cO.pointArray.length; i++) 
										{
											if (cO.pointArray[i].history.length > 1)
											{
												//trace("pivot")
												cx1 += cO.pointArray[i].history[1].x; 
												cy1 += cO.pointArray[i].history[1].y; 
												cx0 += cO.pointArray[i].history[0].x; 
												cy0 += cO.pointArray[i].history[0].y;
											}
										}
										
									cx1 *= tpnk0;
									cy1 *= tpnk0; 
									cx0 *= tpnk0; 
									cy0 *= tpnk0;	
									
									//trace(tpn, tpnk0,cx1,cy1,cx0,cy0)
									
									// find touch point translation vector
									dxh = cx1 - x_c;
									dyh = cy1 - y_c;
											
									// find vector that connects the center of the object and the touch point
									dxi = cx0 - x_c;
									dyi = cy0 - y_c;
									pdist = Math.sqrt(dxi * dxi + dyi * dyi);
											
									t0 = calcAngle(dxh, dyh);
									t1 = calcAngle(dxi, dyi);
									if (t1 > 360) t1 = t1 - 360;
									if (t0 > 360) t0 = t0 - 360;
									
									theta_diff = t1 - t0
									
									if (theta_diff>300) theta_diff = theta_diff -360; //trace("Flicker +ve")
									if (theta_diff<-300) theta_diff = 360 + theta_diff; //trace("Flicker -ve");
									
									
									//pivot thresholds
									//if (Math.abs(theta_diff) > pivot_threshold)
									//{	
										// weighted effect
										tcO.pivot_dtheta = theta_diff*Math.pow(pdist, 2)*pvk;
										tcO.x = cx0;
										tcO.y = cy0;
									//}
									//else cO.pivot_dtheta = 0; 
								}	
								
			}
		} 
		

		public function WeaveTouchClusterData():void
		{
						// each dimension / property must be merged independently
						if (tcO.tpn>0)
						{
							// recalculate cluster center
							// average over all ip subcluster subclusters 
							cO.x = tcO.x  
							cO.y = tcO.y
							cO.z = tcO.z
							
							cO.width = tcO.width;
							cO.height = tcO.height;
							cO.radius = tcO.radius;  
							
							cO.thumbID = tcO.thumbID;
							cO.handednes = tcO.handednes;
							cO.orient_dx = tcO.orient_dx; 
							cO.orient_dy = tcO.orient_dy; 
							cO.pivot_dtheta = tcO.pivot_dtheta; 
							
							
							///////////////////////////////////////////////////////////////////
							// map non zero deltas // accumulate 
							// perhaps find average 
							cO.dx += tcO.dx;
							cO.dy += tcO.dy;
							cO.dz += tcO.dz;	
								
							cO.dtheta += tcO.dtheta;
							cO.dthetaX += tcO.dthetaX;
							cO.dthetaY += tcO.dthetaY;
							cO.dthetaZ += tcO.dthetaZ;
													
							cO.ds += tcO.ds; // must not be affected by cluster change in radius
							cO.dsx += tcO.dsx;
							cO.dsy += tcO.dsy;
							cO.dsz += tcO.dsz;
							///////////////////////////////////////////////////////////////////////////////////////
							///////////////////////////////////////////////////////////////////////////////////////
						//trace("weave touch",cO.x,cO.y,cO.z, cO.width,cO.height)
						}
					//trace("touch prime to core cluster", mcO.x,mcO.y,mcO.z,cO.dx,cO.dy)
				
		}
		
			
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// helper functions
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////
		// FINDS THE ANGLE BETWEEN TWO VECTORS 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		private static function dotProduct(x0:Number, y0:Number,x1:Number, y1:Number):Number
			{	
				if ((x0!=0)&&(y0!=0)&&(x1!=0)&&(y1!=0)) return Math.acos((x0 * x1 + y0 * y1) / (Math.sqrt(x1 * x1 + y1 * y1) * Math.sqrt(x0 * x0 + y0 * y0)));
				else return 0;
				
				
		}	
			
		/////////////////////////////////////////////////////////////////////////////////////////
		// tan function with adjustments for angle wrapping
		/////////////////////////////////////////////////////////////////////////////////////////
		// NOTE NEED TO CLEAN LOGIC TO PREVENT ROTATIONS ABOVE 360 AND PREVENT ANY NEGATIVE ROTATIONS
		
		private static function calcAngle(adjacent:Number, opposite:Number):Number
			{
				if (adjacent == 0) return opposite < 0 ? 270 : 90 ;
				if (opposite == 0) return adjacent < 0 ? 180 : 0 ;
				
				if (opposite > 0) 
				{
					return adjacent > 0 ? 360 + Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				}
				else {
					return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : 180 + Math.atan( opposite / adjacent) * RAD_DEG ;
				}
				
				return 0;
		}
		
		private static function calcAngle2(opposite:Number, adjacent:Number):Number
		{
			if (adjacent > 0) return (180 + Math.atan(opposite / adjacent) * RAD_DEG);
			if ((adjacent >= 0) && (opposite < 0)) return (360 + Math.atan( opposite / adjacent) * RAD_DEG);
			else return (Math.atan( opposite / adjacent) * RAD_DEG);	
		}
		
		private static function calcAngle3(y:Number, x:Number):Number
		{
			var theta_rad:Number  = Math.atan2( y , x)
			return (theta_rad/Math.PI*180) + (theta_rad > 0 ? 0 : 360);	
		}
		
		
		private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return (value - minimum) / (maximum - minimum);
         }

        private static function limit(value : Number, min : Number, max : Number) : Number {
                        return Math.min(Math.max(min, value), max);
        }
	}
}