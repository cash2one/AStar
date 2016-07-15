package com.core.utils
{

    public class StringUtil extends Object
    {
        public static const YYYY:int = 1;
        public static const MM:int = 2;
        public static const DD:int = 4;
        public static const HH:int = 8;
        public static const MIN:int = 16;
        public static const SS:int = 32;

        public function StringUtil()
        {
            return;
        }// end function

        public static function stringsAreEqual(param1:String, param2:String, param3:Boolean) : Boolean
        {
            if (param3)
            {
                return param1 == param2;
            }
            return param1.toUpperCase() == param2.toUpperCase();
        }// end function

        public static function trim(param1:String) : String
        {
            return ltrim(rtrim(param1));
        }// end function

        public static function ltrim(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (param1.charCodeAt(_loc_3) > 32)
                {
                    return param1.substring(_loc_3);
                }
                _loc_3 = _loc_3 + 1;
            }
            return "";
        }// end function

        public static function rtrim(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:* = _loc_2;
            while (_loc_3 > 0)
            {
                
                if (param1.charCodeAt((_loc_3 - 1)) > 32)
                {
                    return param1.substring(0, _loc_3);
                }
                _loc_3 = _loc_3 - 1;
            }
            return "";
        }// end function

        public static function beginsWith(param1:String, param2:String) : Boolean
        {
            return param2 == param1.substring(0, param2.length);
        }// end function

        public static function endsWith(param1:String, param2:String) : Boolean
        {
            return param2 == param1.substring(param1.length - param2.length);
        }// end function

        public static function remove(param1:String, param2:String) : String
        {
            return replace(param1, param2, "");
        }// end function

        public static function replace(param1:String, param2:String, param3:String) : String
        {
            return param1.split(param2).join(param3);
        }// end function

        public static function stringHasValue(param1:String) : Boolean
        {
            if (param1 != null)
            {
            }
            return param1.length > 0;
        }// end function

        public static function isEmpty(param1:String) : Boolean
        {
            return param1 == "";
        }// end function

        public static function toBoolean(param1:String) : Boolean
        {
            return param1 == "true" ? (true) : (false);
        }// end function

        public static function mayBeBoolean(param1:String) : Boolean
        {
            if (param1 != "true")
            {
            }
            return param1 == "false";
        }// end function

        public static function mayBeNumber(param1:String) : Boolean
        {
            var _loc_2:Number = NaN;
            if (param1 == "")
            {
                return false;
            }
            _loc_2 = Number(param1);
            return !isNaN(_loc_2);
        }// end function

        public static function mayBePositiveNumber(param1:String) : Boolean
        {
            if (mayBeNumber(param1))
            {
                mayBeNumber(param1);
            }
            return Number(param1) > 0;
        }// end function

        public static function mayBeNegativeNumber(param1:String) : Boolean
        {
            if (mayBeNumber(param1))
            {
                mayBeNumber(param1);
            }
            return Number(param1) < 0;
        }// end function

        public static function mayBeZero(param1:String) : Boolean
        {
            if (mayBeNumber(param1))
            {
                mayBeNumber(param1);
            }
            return Number(param1) == 0;
        }// end function

        public static function mayBeInteger(param1:String) : Boolean
        {
            var _loc_2:Number = NaN;
            if (mayBeNumber(param1))
            {
                _loc_2 = Number(param1);
                return _loc_2 == int(_loc_2);
            }
            return false;
        }// end function

        public static function mayBePositiveInteger(param1:String) : Boolean
        {
            if (mayBeInteger(param1))
            {
                mayBeInteger(param1);
            }
            return int(param1) > 0;
        }// end function

        public static function mayBeNegativeInteger(param1:String) : Boolean
        {
            if (mayBeInteger(param1))
            {
                mayBeInteger(param1);
            }
            return int(param1) < 0;
        }// end function

        public static function mayBeUnsignedInteger(param1:String) : Boolean
        {
            var _loc_2:int = 0;
            if (mayBeInteger(param1))
            {
                _loc_2 = int(param1);
                return _loc_2 >= 0;
            }
            return false;
        }// end function

        public static function mayBeNULL(param1:String) : Boolean
        {
            return param1 == "null";
        }// end function

        public static function formatMillisecond(param1:Number, param2:Number = 63, param3:String = " ", param4:Boolean = true, param5:String = "Year", param6:String = "Month", param7:String = "Day", param8:String = "Hour", param9:String = "Minute", param10:String = "Second") : String
        {
            var _loc_14:Number = NaN;
            var _loc_11:* = new Date(param1);
            var _loc_12:String = "";
            var _loc_13:Boolean = true;
            if (param3 == null)
            {
                param3 = "";
            }
            if (param2 & SS)
            {
                _loc_14 = _loc_11.getSeconds();
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param10 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            if (param2 & MIN)
            {
                _loc_14 = _loc_11.getMinutes();
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param9 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            if (param2 & HH)
            {
                _loc_14 = _loc_11.getHours();
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param8 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            if (param2 & DD)
            {
                _loc_14 = _loc_11.getDate();
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param7 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            if (param2 & MM)
            {
                _loc_14 = _loc_11.getMonth() + 1;
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param6 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            if (param2 & YYYY)
            {
                _loc_14 = _loc_11.getFullYear();
                _loc_12 = (_loc_14 < 10 ? ("0" + _loc_14) : (_loc_14)) + param5 + (_loc_13 ? (_loc_12) : (param3 + _loc_12));
                _loc_13 = false;
            }
            return _loc_12;
        }// end function

        public static function isIPv4(param1:String) : Boolean
        {
            return new RegExp("\\A^((25[0-5]|2[0-4]\\d|[0-1]?\\d\\d?)\\.){3}(25[0-5]|2[0-4]\\d|[0-1]?\\d\\d?)$\\Z", "").test(param1);
        }// end function

        public static function isIPv6(param1:String) : Boolean
        {
            return new RegExp("\\A^\\s*((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}(:|((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})|(:[0-9A-Fa-f]{1,4})))|(([0-9A-Fa-f]{1,4}:){5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)(:[0-9A-Fa-f]{1,4}){0,4}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(:(:[0-9A-Fa-f]{1,4}){0,5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})))(%.+)?\\s*$\\Z", "").test(param1);
        }// end function

        public static function unserialize(param1:String) : Object
        {
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_7:Object = null;
            var _loc_8:String = null;
            var _loc_9:Object = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_6:* = param1.length;
            if (param1 == "N")
            {
                return null;
            }
            _loc_4 = param1.substr(_loc_2, 1);
            switch(_loc_4)
            {
                case "a":
                {
                    _loc_3 = param1.indexOf(":", 2) - 2;
                    _loc_5 = int(param1.substr(2, _loc_3));
                    _loc_2 = 3 + _loc_3;
                    _loc_7 = new Object();
                    _loc_9 = {value:true};
                    unarray(param1.substr(_loc_2), _loc_7, _loc_5, _loc_9);
                    if (_loc_9.value)
                    {
                        _loc_7 = changeToArray(_loc_7);
                    }
                    break;
                }
                case "i":
                case "d":
                {
                    _loc_3 = param1.indexOf(":");
                    _loc_7 = Number(param1.substr((_loc_3 + 1)));
                    break;
                }
                case "s":
                {
                    _loc_3 = param1.indexOf(":", 2) - 2;
                    _loc_5 = int(param1.substr(2, _loc_3));
                    _loc_2 = 4 + _loc_3;
                    _loc_7 = param1.substring(_loc_2, (_loc_6 - 1));
                    break;
                }
                case "b":
                {
                    _loc_3 = param1.indexOf(":");
                    _loc_7 = Boolean(int(param1.substr((_loc_3 + 1))));
                    break;
                }
                default:
                {
                    _loc_7 = param1;
                    break;
                    break;
                }
            }
            return _loc_7;
        }// end function

        private static function unarray(param1:String, param2:Object, param3:int, param4:Object) : int
        {
            var _loc_8:String = null;
            var _loc_10:String = null;
            var _loc_11:Object = null;
            var _loc_12:String = null;
            var _loc_13:Object = null;
            var _loc_5:int = 1;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_9:int = 0;
            while (_loc_9 < param3)
            {
                
                _loc_6 = param1.indexOf(";", _loc_5);
                _loc_10 = param1.substring(_loc_5, _loc_6);
                _loc_11 = unserialize(_loc_10);
                if (_loc_11 is String)
                {
                    param4.value = false;
                }
                else
                {
                    if (_loc_9 == 0)
                    {
                    }
                    if (_loc_11 > 0)
                    {
                        param4.value = false;
                    }
                }
                _loc_5 = _loc_6 + 1;
                _loc_8 = param1.substr(_loc_5, 1);
                switch(_loc_8)
                {
                    case "a":
                    {
                        _loc_6 = param1.indexOf(":", _loc_5 + 2) - _loc_5 - 2;
                        _loc_7 = int(param1.substr(_loc_5 + 2, _loc_6));
                        _loc_5 = _loc_5 + (3 + _loc_6);
                        _loc_13 = new Object();
                        param4 = {value:true};
                        _loc_5 = _loc_5 + unarray(param1.substr(_loc_5), _loc_13, _loc_7, param4);
                        if (param4.value)
                        {
                            _loc_13 = changeToArray(_loc_13);
                        }
                        break;
                    }
                    default:
                    {
                        if (_loc_8 == "s")
                        {
                            _loc_6 = param1.indexOf("\";", _loc_5) + 1;
                        }
                        else
                        {
                            _loc_6 = param1.indexOf(";", _loc_5);
                        }
                        _loc_12 = param1.substring(_loc_5, _loc_6);
                        _loc_13 = unserialize(_loc_12);
                        if (_loc_13 is String)
                        {
                        }
                        if (mayBeInteger(_loc_13.toString()))
                        {
                            _loc_13 = Number(_loc_13);
                        }
                        _loc_5 = _loc_5 + (_loc_12.length + 1);
                        break;
                        break;
                    }
                }
                param2[_loc_11] = _loc_13;
                _loc_9 = _loc_9 + 1;
            }
            return (_loc_5 + 1);
        }// end function

        public static function changeToArray(param1:Object) : Array
        {
            var _loc_3:Object = null;
            var _loc_2:* = new Array();
            for each (_loc_3 in param1)
            {
                
                _loc_2.push(_loc_3);
            }
            return _loc_2;
        }// end function

    }
}
