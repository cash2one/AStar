package com.core.utils
{
    import flash.utils.*;

    public class Vertex extends Object
    {
        public var words:int;
        public var prefixes:int;
        public var edges:Object;

        public function Vertex()
        {
            this.words = 0;
            this.prefixes = 0;
            this.edges = new Dictionary();
            return;
        }// end function

    }
}
