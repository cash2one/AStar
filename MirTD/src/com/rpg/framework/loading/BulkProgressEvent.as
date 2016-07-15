package com.rpg.framework.loading
{
	import flash.events.*;

	public class BulkProgressEvent extends ProgressEvent 
	{
		public static const PROGRESS  : String = "progress";
		public static const COMPLETE  : String = "complete";
    	public static const ERROR     : String = "error";
		public static const OPEN      : String = "open";
		
		public var itemsLoaded        : uint;			// 已加载完成数
	    public var itemsTotal         : uint;			// 下载项目总数
	    public var itemBytesLoaded    : uint;			// 当前项已加载完成数
 	    public var itemBytesTotal     : uint;			// 当前项加载总数
	    public var itemsSpeed         : Number;			// 项目下载速度
 	    public var item			      : LoadingItem;
 	    public var errorMessage		  : String;
		public var sender			  : Object;
		private var _weightPercent    : Number;

		public function get weightPercent() : Number
		{
			return validateNumber(_weightPercent);
		}

		public function set weightPercent(value : Number) : void
		{
			_weightPercent = value;
		}

		public function get percentLoaded() : Number
		{
			return validateNumber(bytesTotal > 0 ? (bytesLoaded / bytesTotal) : 0)
		}

		public function BulkProgressEvent(name : String, bubbles : Boolean = true, cancelable : Boolean = false)
		{
			super(name, bubbles, cancelable);
		}

		public override function toString() : String
		{
		    var names : Array = [];
		    names.push("ItemBytesLoaded: "    + itemBytesLoaded);
		    names.push("ItemBytesTotal: "     + itemBytesTotal);
            names.push("BytesLoaded: "        + bytesLoaded);
		    names.push("BytesTotal: "         + bytesTotal);
            names.push("ItemsLoaded: "        + itemsLoaded);
            names.push("ItemsTotal: "         + itemsTotal);
		    names.push("ItemsSpeed: "         + itemsSpeed);
		    names.push("PercentLoaded: "      + BulkLoader.truncateNumber(percentLoaded));
		    names.push("WeightPercent: "      + BulkLoader.truncateNumber(weightPercent));
		    return "BulkProgressEvent "	      + names.join(", ") + ";"
		}

		private function validateNumber(value : Number) : Number
		{
			if (isNaN(value) || !isFinite(value))
				return 0;
			return value;
		}
	}
}
