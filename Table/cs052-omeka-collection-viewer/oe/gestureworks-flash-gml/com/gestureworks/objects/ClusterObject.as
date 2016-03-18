﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ClusterObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	//import com.gestureworks.objects.InteractionPointObject;
	//import flash.geom.Vector3D;
	
	public class ClusterObject extends Object 
	{		
		// ID
		public var id:int;
		// cluster type
		public var type:String;

		// cluster properties//////////////////
		// number of points
		public var n:int = 0;
		// number of touch points
		public var tpn:int = 0;
		// number of motion points
		public var mpn:int = 0;
		//number of sensor points
		public var spn:int=0;
		
		
		// number of hands
		public var hn:int=0;
		// number of fingers
		public var fn:int=0;

		// number of derived interactive points
		public var ipn:int = 0;
		public var ipnk:Number = 0;
		public var ipnk0:Number = 0;
		// CHANGE IN NUMBER OF TOUCH POINTS
		public var dn:int=0;
		// CHANGE IN NUMBER OF INTERACTION POINTS
		public var dipn:int = 0;
		
		
		/////////////////////////////////
		// frame count
		public var count:int = 0;
		
		// x---------------------
		public var x:Number=0;
		// y---------------------
		public var y:Number=0;
		// z---------------------
		public var z:Number=0;

		// width----------------------
		public var width:Number=0;
		// height---------------------
		public var height:Number=0;
		// length---------------------
		public var length:Number=0;
		// radius---------------------
		public var radius:Number=0;
		
		// separation------------------
		public var separation:Number=0;
		// separation------------------
		public var separationX:Number=0;
		// separationY------------------
		public var separationY:Number=0;
		// separationZ------------------
		public var separationZ:Number=0;
		
		// rotation---------------------
		public var rotation:Number=0;
		// rotationX---------------------
		public var rotationX:Number=0;
		// rotation---------------------
		public var rotationY:Number=0;
		// rotationZ---------------------
		public var rotationZ:Number=0;

		
		// mean position
		// mx---------------------
		public var mx:Number=0;
		// my---------------------
		public var my:Number=0;
		// mz---------------------
		public var mz:Number=0;
		
		/////////////////////////////////////////////////
		// velocities
		/////////////////////////////////////////////////
		// dx---------------------
		public var dx:Number=0;
		// dy---------------------
		public var dy:Number=0;
		// dz---------------------
		public var dz:Number=0;
		
		// size veloctiy
		// dw---------------------
		public var dw:Number=0;
		// dh---------------------
		public var dh:Number=0;
		// dr---------------------
		public var dr:Number=0;

		
		///////////////////////////////////////////////////////////////////////////////
		// scale velocity
		///////////////////////////////////////////////////////////////////////////////
		// dsx---------------------
		public var ds:Number=0;
		// dsx---------------------
		public var dsx:Number=0;
		// dsy---------------------
		public var dsy:Number=0;
		// dsz---------------------
		public var dsz:Number=0;

		
		///////////////////////////////////////////////////////////////////////////////
		//rotational velocity
		///////////////////////////////////////////////////////////////////////////////
		// dtheta ------------------
		public var dtheta:Number=0;
		// dthetax ------------------
		public var dthetaX:Number=0;
		// dthetay ------------------
		public var dthetaY:Number=0;
		// dthetaZ ------------------
		public var dthetaZ:Number=0;
		// pivot_dtheta ------------------
		public var pivot_dtheta:Number=0;

	
		///////////////////////////////////////////////////////////////////////////////
		//mean velocity
		///////////////////////////////////////////////////////////////////////////////
		// mdx---------------------
		public var mdx:Number=0;
		// mdy---------------------
		public var mdy:Number=0;
		// mdz---------------------
		public var mdz:Number=0;
		
		//////////////////////////////////////////////
		// accelerations
		//////////////////////////////////////////////
		// ddx ------------------
		public var ddx:Number=0;
		// ddy ------------------
		public var ddy:Number=0;
		// ddz ------------------
		public var ddz:Number=0;
		
		///////////////////////////////////////////////////////////////////////////////
		// rotational acceleration
		///////////////////////////////////////////////////////////////////////////////
		// ddtheta ------------------
		public var ddtheta:Number=0;
		
		////////////////////////////////////////////////////////////////////////////////
		// separation acceleration
		////////////////////////////////////////////////////////////////////////////////
		// ddsx ------------------
		public var ddsx:Number=0;
		// ddsy ------------------
		public var ddsy:Number=0;
		// ddsz ------------------
		public var ddsz:Number=0;
		// dds ------------------
		public var dds:Number=0;
		// dds3d ------------------
		public var dds3d:Number=0;

		
		///////////////////////////////////////////////////////////////////////////////
		// estimated total mean acceleration
		///////////////////////////////////////////////////////////////////////////////
		// etm_ddx ------------------
		public var etm_dx:Number=0;
		// etm ddy ------------------
		public var etm_dy:Number=0;
		// etm ddz ------------------
		public var etm_dz:Number=0;
		// etm_ddx ------------------
		public var etm_ddx:Number=0;
		// etm_ddy ------------------
		public var etm_ddy:Number=0;
		// etm_ddz ------------------
		public var etm_ddz:Number=0;
		
		
		///////////////////////////////////////////////////////////////////////////////
		// 2d/3d hand surface profile / data structure
		///////////////////////////////////////////////////////////////////////////////
		
		// become handList //NO NEED AS ANY CLUSTER CAN BE A HAND 2D OR 3D
		// ANY CLUSTER CAN SUBCLUSTER INTO TWO HANDS OR SUBLISTS OF PREANALYZED POINTS
		//public var handList:Vector.<HandObject> = new Vector.<HandObject>;

			/// INSIDE 3D HAND Object
				//--width
				//--length
				//--thumb
				//--fingerlist
				//-- handednes / left /right :uint 0-left 1-right 2-bimanual
				//-- orientation vector :Vector3D
				//-- orintationAngle 
				//-- thumb id/x/yz
				//-- hand finger list id/x/y/z
				//-- fingers id :int
				//-- mean finger velocity :Vector3D
				//-- mean finger acceleration :Vector3D
				//-- palm radius :Number
				//-- palm center :Vector3D
				//-- palm velocity :Vector3D
		
		/// 
		// thumbID ------------------ FOR 2D STUFF (NEEDS TO MOVE TO 2D HAND OBJECT)
		public var thumbID:int = 0;
		//handednes-------------------- //left//right
		public var handednes:String = "none";
		// orientationAngle---------------------
		public var orientation:Number = 0;
		// orient_dx---------------------
		public var orient_dx:Number = 0;
		// orient_dy---------------------
		public var orient_dy:Number = 0;
		// orient_dz---------------------
		public var orient_dz:Number = 0;

		
		// public var holdPoint:Vector3D = new Vector3D(); 
		// hold_x---------------------//remove
		public var hold_x:Number = 0;
		// hold_y---------------------remove
		public var hold_y:Number = 0;
		// hold_z---------------------remove
		public var hold_z:Number = 0;
		// c_locked---------------------remove
		public var hold_n:int = 0;

		

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// simplified data structure ----------------------------------------------------------------------------------------------
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////
		//ABSOLUTE PROPS
		//inst position//////////////////////////////////////////////x,y,z
		//public var position:Vector3D = new Vector3D ();
		//inst direction/orientation //////////////////////////////////////////////x,y,z
		//public var direction:Vector3D = new Vector3D ();
		//inst scale //////////////////////////////////////////////scaleX,scaleY,scaleZ
		//public var scale :Vector3D = new Vector3D ();
		//inst scale change //////////////////////////////////////////////rotationX,rotationY,rotationZ
		//public var rotation:Vector3D = new Vector3D ();
		
		/////////////////////////////////////////////////////////////////////////////
		// DELTA PROPS
		//inst scale change//////////////////////////////////////////////dsx,dsy,dsz
		//public var scaleDelta :Vector3D = new Vector3D ();
		//inst scale change //////////////////////////////////////////////dthetax,dthetay,dthetaz
		//public var rotationDelta:Vector3D = new Vector3D ();
		//inst velocity//////////////////////////////////////////////dx,dy,dz
		//public var velocity:Vector3D = new Vector3D ();
		//inst acceleration//////////////////////////////////////////////ddx,ddy,ddz
		///public var acceleration:Vector3D = new Vector3D ();
		//inst jolt//////////////////////////////////////////////ddx,ddy,ddz
		//public var jolt:Vector3D = new Vector3D ();
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// refactor out ----------------------------------------------------------------------------------------------
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// path_data
		// need to update to vector 
		//public var path_data:Array = new Array();
		//public function get path_data():Array{return _path_data;}
		//public function set path_data(value:Array):void{_path_data = value;}	
		
		// 3Dpath_data
		//public var path_data3d:Vector.<Vector3d> = new Vector.<Vector3d>();
		//public function get path_data3d():Vector.<Vector3d>{return _path_data3d;}
		//public function set path_data3d(value:Vector.<Vector3d>):void{_path_data3d = value;}
		
		///////////////////////////////////////////////
		// CLUSTER EVENT LOGIC
		///////////////////////////////////////////////
		// add point
		public var point_add:Boolean = false;
		// remove point
		public var point_remove:Boolean = false;
		// add cluster
		public var add:Boolean = false;
		// remove cluster
		public var remove:Boolean = false;
		
		
		
		
		// PRIME MULTIMODAL POINT ARRAY COPIED FROM CLOBAL REGISTERED CACHE
		//public var mmPointArray:Array = new Array();

		/////////////////////////////////////////////////////////////////////////
		//default cluster level RAW data structures
		/////////////////////////////////////////////////////////////////////////
		// surface point data list----------------
		public var pointArray:Vector.<PointObject> = new Vector.<PointObject>();
		// motion point data list
		//public var motionArray:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		// motion point data list
		//public var motionArray2D:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		// sensor point data list----------------
		//public var sensorArray:Vector.<Number> = new Vector.<Number>();//<SensorPointObject>();
		
		
		/////////////////////////////////////////////////////////////////////////////
		// cluster Interaction Point list
		/////////////////////////////////////////////////////////////////////////////
		// DERIVED POINT LIST BASED ON PRIMARY INTERACTION CRITERIA
		// GENERATED FROM PRIMARY CLUSTER ANALYSIS FROM RAW POINT DATA
		// CLASIFIED BY TYPE INTO SINGLE LIST
		// type // PINCH POINT // TAP POINT// HOLD POINT // TRIGGER POINT // PALM POINT
		//public var iPointArray:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		//public var iPointArray2D:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		
			
		//TOUCH PARENT CLUSTER ///////////////////////////////////////
		public var tcO:ipClusterObject = new ipClusterObject ();
		//TOUCH SUBCLUSTER ARRAY
		//public var tsubClusterArray:Vector.<ipClusterObject> = new Vector.<ipClusterObject>();
		
		//MOTION PARENT CLUSTER///////////////////////////////////////
		//public var mcO:ipClusterObject = new ipClusterObject ();
		//MOTION SUBCLUSTER ARRAY
		//TODO: CHANGE NAME TO mSubCluster
		//public var subClusterArray:Vector.<ipClusterObject> = new Vector.<ipClusterObject>();
		
		// SENSOR PARENT CLUSTER//////////////////////////////////////
		//public var scO:ipClusterObject = new ipClusterObject ();
		//TOUCH SUBCLUSTER ARRAY
		//public var ssubClusterArray:Vector.<ipClusterObject> = new Vector.<ipClusterObject>();
		
		///////////////////////////////////////////////////////////////////////////////////
		// GESTURE POINTS
		//public var gPointArray:Vector.<GesturePointObject> = new Vector.<GesturePointObject>();
		
	
		/////////////////////////////////////////////////////////////////////////
		// cluster history
		/////////////////////////////////////////////////////////////////////////
		public var history:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		
		
		/**
		 * Reset attributes to initial values
		 */
		public function reset():void {
			id = NaN;
			type = null;
			n = 0;
			tpn = 0;
			mpn = 0;
			spn=0;
			hn=0;
			fn=0;
			ipn = 0;
			ipnk = 0;
			ipnk0 = 0;
			dn=0;
			dipn = 0;
			count = 0;
			x=0;
			y=0;
			z=0;
			width=0;
			height=0;
			length=0;
			radius=0;		
			separation=0;
			separationX=0;
			separationY=0;
			separationZ=0;
			rotation=0;
			rotationX=0;
			rotationY=0;
			rotationZ=0;
			mx=0;
			my=0;
			mz=0;
			dx=0;
			dy=0;
			dz=0;
			dw=0;
			dh=0;
			dr=0;
			ds=0;
			dsx=0;
			dsy=0;
			dsz=0;
			dtheta=0;
			dthetaX=0;
			dthetaY=0;
			dthetaZ=0;
			pivot_dtheta=0;
			mdx=0;
			mdy=0;
			mdz=0;
			ddx=0;
			ddy=0;
			ddz=0;
			ddtheta=0;
			ddsx=0;
			ddsy=0;
			ddsz=0;
			dds=0;
			dds3d=0;
			etm_dx=0;
			etm_dy=0;
			etm_dz=0;
			etm_ddx=0;
			etm_ddy=0;
			etm_ddz=0;
			//handList.length = 0;
			thumbID = 0;
			handednes = "none";
			orientation = 0;
			orient_dx = 0;
			orient_dy = 0;
			orient_dz = 0;
			hold_x = 0;
			hold_y = 0;
			hold_z = 0;
			hold_n = 0;		
			
			point_add = false;
			point_remove = false;
			add = false;
			remove = false;
			
			pointArray.length = 0;
			//gPointArray.length = 0;
			history.length = 0;
			
			tcO.reset();
			
			
		}
	}
}