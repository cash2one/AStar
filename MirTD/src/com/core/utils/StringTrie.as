package com.core.utils
{

    public class StringTrie extends Object
    {
        protected var root:Vertex;

        public function StringTrie()
        {
            this.root = new Vertex();
            return;
        }// end function

        public function addWords(param1:String) : void
        {
            this.addWord(this.root, param1);
            return;
        }// end function

        protected function addWord(param1:Vertex, param2:String) : void
        {
            var _loc_3:String = null;
            var _loc_4:Vertex = null;
			var _loc_5:*;
			var _loc_6:*;
            if (param2.length == 0)
            {
                _loc_5 = param1;
                _loc_6 = param1.words + 1;
                _loc_5.words = _loc_6;
            }
            else
            {
                _loc_5 = param1;
                _loc_6 = param1.prefixes + 1;
                _loc_5.prefixes = _loc_6;
                _loc_3 = param2.charAt(0);
                _loc_4 = param1.edges[_loc_3];
                if (!_loc_4)
                {
                    _loc_4 = new Vertex();
                    param1.edges[_loc_3] = _loc_4;
                }
                this.addWord(_loc_4, param2.substr(1));
            }
            return;
        }// end function

        public function replaceAll(param1:String) : String
        {
            var _loc_7:String = null;
            var _loc_2:* = param1.length;
            var _loc_3:* = this.root;
            var _loc_4:String = "";
            var _loc_5:String = "";
            var _loc_6:int = 0;
            while (_loc_6 < _loc_2)
            {
                
                _loc_7 = param1.charAt(_loc_6);
                if (_loc_7 == " ")
                {
					_loc_5 = _loc_5 + _loc_7;
                }
                else if (!_loc_3.edges[_loc_7])
                {
                    if (_loc_3.words != 0)
                    {
                        _loc_4 = "*";
                        return _loc_4 + this.replaceAll(param1.substring(_loc_6));
                    }
                    if (_loc_6 == 0)
                    {
                        return _loc_7 + this.replaceAll(param1.substring((_loc_6 + 1)));
                    }
                    return _loc_5.substr(0, 1) + this.replaceAll(param1.substring(1));
                }
                else
                {
                    _loc_5 = _loc_5 + _loc_7;
                    _loc_3 = _loc_3.edges[_loc_7];
                }
                _loc_6 = _loc_6 + 1;
            }
            if (_loc_5.length > 0)
            {
                if (_loc_3.words != 0)
                {
                    return "*";
                }
                return _loc_5;
            }
            else
            {
                return "";
            }
        }// end function

    }
}
