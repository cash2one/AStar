package com.core.destroy
{
    import flash.display.*;
    import flash.utils.*;

    public class DestroyUtil extends Object
    {
        public static var destroyMethodName:String = "destroy";

        public function DestroyUtil()
        {
            return;
        }// end function

        public static function destroyObject(param1:Object) : void
        {
            if (param1 != null)
            {
                if (param1 is IDestroy)
                {
                    param1.destroy();
                }
                else if (param1 is Loader)
                {
                    try
                    {
                        param1.close();
                    }
                    catch (error:Error)
                    {
                    }
                    param1.unloadAndStop();
                }
                else if (param1 is Bitmap)
                {
                    if (param1.bitmapData != null)
                    {
                        param1.bitmapData.dispose();
                        param1.bitmapData = null;
                    }
                }
                else if (param1 is BitmapData)
                {
                    param1.dispose();
                }
                else if (param1 is MovieClip)
                {
                    param1.stop();
                }
                else if (param1 is ByteArray)
                {
                    param1.length = 0;
                }
                else if (destroyMethodName in param1)
                {
                    var _loc_2:* = param1;
                    _loc_2.param1[destroyMethodName]();
                }
            }
            return;
        }// end function

        public static function destroyArray(param1:Array) : Array
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = _loc_2 - 1;
                while (_loc_3 >= 0)
                {
                    
                    destroyObject(param1[_loc_3]);
                    param1[_loc_3] = null;
                    _loc_3 = _loc_3 - 1;
                }
                param1.length = 0;
            }
            return param1;
        }// end function

        public static function destroyMap(param1:Object) : Object
        {
            var _loc_2:Object = null;
            if (param1 != null)
            {
                for (_loc_2 in param1)
                {
                    
                    destroyObject(param1[_loc_2]);
                    destroyObject(_loc_2);
                    delete param1[_loc_2];
                }
            }
            return param1;
        }// end function

        public static function breakArray(param1:Array) : Array
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    param1[_loc_3] = null;
                    _loc_3 = _loc_3 + 1;
                }
                param1.length = 0;
            }
            return param1;
        }// end function

        public static function breakMap(param1:Object) : Object
        {
            var _loc_2:Object = null;
            if (param1 != null)
            {
                for (_loc_2 in param1)
                {
                    
                    delete param1[_loc_2];
                }
            }
            return param1;
        }// end function

        public static function removeDestroyChildren(param1:DisplayObjectContainer) : DisplayObjectContainer
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 != null)
            {
                _loc_2 = param1.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    destroyObject(param1.removeChildAt(0));
                    _loc_3 = _loc_3 + 1;
                }
            }
            return param1;
        }// end function

        public static function removeChildren(param1:DisplayObjectContainer,from:int = 0,to:int = int.MAX_VALUE) : DisplayObjectContainer
        {
            var num:int = 0;
            var cur:int = from;
            if (param1 != null)
            {
				num = param1.numChildren;
				if(from >= num)
					return null;
                while (cur < num && cur < to)
                {
                    
                    param1.removeChildAt(from);
					cur = cur + 1;
                }
            }
            return param1;
        }// end function

        public static function breakVector(param1:Object) : Object
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    param1[_loc_3] = null;
                    _loc_3 = _loc_3 + 1;
                }
                param1.length = 0;
                return param1;
            }
            else
            {
                return null;
            }
        }// end function

        public static function destroyVector(param1:Object) : Object
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    destroyObject(param1[_loc_3]);
                    param1[_loc_3] = null;
                    _loc_3 = _loc_3 + 1;
                }
                param1.length = 0;
                return param1;
            }
            else
            {
                return null;
            }
        }// end function

    }
}
