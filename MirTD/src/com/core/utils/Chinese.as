package com.core.utils
{
    import flash.utils.*;

    public class Chinese extends Object
    {

        public function Chinese()
        {
            throw new Error("单例...");
        }// end function

        public static function convertString(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:String = "";
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = _loc_3 + convertChar(param1.charAt(_loc_4));
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public static function convertChar(param1:String) : String
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeMultiByte(param1.charAt(0), "cn-gb");
            var _loc_3:* = _loc_2[0] << 8;
            _loc_3 = _loc_3 + _loc_2[1];
            if (isIn(45217, 45252, _loc_3))
            {
                return "a";
            }
            if (isIn(45253, 45760, _loc_3))
            {
                return "b";
            }
            if (isIn(45761, 46317, _loc_3))
            {
                return "c";
            }
            if (isIn(46318, 46825, _loc_3))
            {
                return "d";
            }
            if (isIn(46826, 47009, _loc_3))
            {
                return "e";
            }
            if (isIn(47010, 47296, _loc_3))
            {
                return "f";
            }
            if (isIn(47297, 47613, _loc_3))
            {
                return "g";
            }
            if (isIn(47614, 48118, _loc_3))
            {
                return "h";
            }
            if (isIn(48119, 49061, _loc_3))
            {
                return "j";
            }
            if (isIn(49062, 49323, _loc_3))
            {
                return "k";
            }
            if (isIn(49324, 49895, _loc_3))
            {
                return "l";
            }
            if (isIn(49896, 50370, _loc_3))
            {
                return "m";
            }
            if (isIn(50371, 50613, _loc_3))
            {
                return "n";
            }
            if (isIn(50614, 50621, _loc_3))
            {
                return "o";
            }
            if (isIn(50622, 50905, _loc_3))
            {
                return "p";
            }
            if (isIn(50906, 51386, _loc_3))
            {
                return "q";
            }
            if (isIn(51387, 51445, _loc_3))
            {
                return "r";
            }
            if (isIn(51446, 52208, _loc_3))
            {
                return "s";
            }
            if (isIn(52218, 52697, _loc_3))
            {
                return "t";
            }
            if (isIn(52698, 52979, _loc_3))
            {
                return "w";
            }
            if (isIn(52980, 53640, _loc_3))
            {
                return "x";
            }
            if (isIn(53689, 54480, _loc_3))
            {
                return "y";
            }
            if (isIn(54481, 55289, _loc_3))
            {
                return "z";
            }
            return "0";
        }// end function

        private static function isIn(param1:int, param2:int, param3:int) : Boolean
        {
            if (param3 >= param1)
            {
            }
            return param3 <= param2;
        }// end function

        public static function isChinese(param1:String) : Boolean
        {
            if (convertChar(param1) == "0")
            {
                return false;
            }
            return true;
        }// end function

        public static function sort(param1:Array, param2:String = "") : Array
        {
            var _loc_6:* = undefined;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Object = null;
            var _loc_3:* = new ByteArray();
            var _loc_4:Array = [];
            var _loc_5:Array = [];
            for each (_loc_6 in param1)
            {
                
                if (param2 == "")
                {
                    _loc_3.writeMultiByte(String(_loc_6).charAt(0), "gb2312");
                    continue;
                }
                _loc_3.writeMultiByte(String(_loc_6[param2]).charAt(0), "gb2312");
            }
            _loc_3.position = 0;
            _loc_7 = _loc_3.length / 2;
            _loc_8 = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_4[_loc_4.length] = {a:_loc_3[_loc_8 * 2], b:_loc_3[_loc_8 * 2 + 1], c:param1[_loc_8]};
                _loc_8 = _loc_8 + 1;
            }
            _loc_4.sortOn(["a", "b"], [Array.DESCENDING | Array.NUMERIC]);
            for each (_loc_9 in _loc_4)
            {
                
                _loc_5[_loc_5.length] = _loc_9.c;
            }
            return _loc_5;
        }// end function

    }
}
