package com.gestureworks.managers {
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.utils.collections.LinkedList;
	
	/**
	 * Manages object pooling to recycle objects opposed to performance intensive allocation (instantiation)
	 * and deallocation (garbage collection)
	 * @author Ideum
	 */
	public class PoolManager {
		
		private static var instance:PoolManager
		
		public static function getInstance():PoolManager {
			if (!instance) {
				instance = new PoolManager;
			}
			return instance;
		}
		
		//cluster object pool
		private var cPool:LinkedList = new LinkedList();
		//frame object pool
		private var fPool:LinkedList = new LinkedList();
		//number of registered touch objects
		private  var objCnt:int;		
		//variable to store the pool sizes
		private  var poolSize:int;
		
		/**
		 * Populate object pools based on object count
		 */
		public  function registerPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
			updateFramePool();
		}
		
		/**
		 * Decrease the sizes of the object pools
		 */
		public  function unregisterPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
			updateFramePool();
		}

		/********************ClusterObject********************/
		/**
		 * Updates the queue of the pool by shifting the top object to the bottom
		 * @return  The next object on top of the queue
		 */		
		private  function updateCOPool():void {
			poolSize = objCnt * GestureGlobals.clusterHistoryCaptureLength;
			
			for (var i:int = cPool.length; i < poolSize; i++)
				cPool.push(new ClusterObject());
				
			if (poolSize < cPool.length)
				cPool.shrinkBy(poolSize-cPool.length);
		}
		
		/**
		 * Retrurn ClusterObject from pool
		 * @return the top ClusterObject
		 */
		public  function get clusterObject():ClusterObject {
			var cO:ClusterObject = cPool.cycle() as ClusterObject;
			cO.reset();
			return cO;
		}
		
		
		/********************FrameObject********************/		
		/**
		 * Updates the queue of the pool by shifting the top object to the bottom
		 * @return  The next object on top of the queue
		 */				
		private  function updateFramePool():void {
			poolSize = objCnt * GestureGlobals.timelineHistoryCaptureLength;
			
			for (var i:int = fPool.length; i < poolSize; i++)
				fPool.push(new FrameObject());
				
			if (poolSize < fPool.length)
				fPool.shrinkBy(fPool.length - poolSize);
		}
		
		/**
		 * Return FrameObject from pool
		 * @return the top FrameObject
		 */
		public  function get frameObject():FrameObject {
			var frame:FrameObject = fPool.cycle() as FrameObject;
			frame.reset();
			return frame;
		}
		
	}

}