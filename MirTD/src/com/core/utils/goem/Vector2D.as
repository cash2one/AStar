package com.core.utils.goem
{
    import flash.display.*;

    public class Vector2D extends Object
    {
        private var _x:Number;
        private var _y:Number;

        public function Vector2D(param1:Number = 0, param2:Number = 0)
        {
            this._x = param1;
            this._y = param2;
            return;
        }// end function

        public function draw(param1:Graphics, param2:uint = 0, param3:Number = 0, param4:Number = 0) : void
        {
            param1.lineStyle(0, param2);
            param1.moveTo(0 + param3, 0 + param4);
            param1.lineTo(this._x + param3, this._y + param4);
            return;
        }// end function

        public function clone() : Vector2D
        {
            return new Vector2D(this.x, this.y);
        }// end function

        public function zero() : Vector2D
        {
            this._x = 0;
            this._y = 0;
            return this;
        }// end function

        public function isZero() : Boolean
        {
            if (this._x == 0)
            {
            }
            return this._y == 0;
        }// end function

        public function set length(param1:Number) : void
        {
            var _loc_2:* = this.angle;
            this._x = Math.cos(_loc_2) * param1;
            this._y = Math.sin(_loc_2) * param1;
            return;
        }// end function

        public function get length() : Number
        {
            return Math.sqrt(this.lengthSQ);
        }// end function

        public function get lengthSQ() : Number
        {
            return this._x * this._x + this._y * this._y;
        }// end function

        public function set angle(param1:Number) : void
        {
            var _loc_2:* = this.length;
            this._x = Math.cos(param1) * _loc_2;
            this._y = Math.sin(param1) * _loc_2;
            return;
        }// end function

        public function get angle() : Number
        {
            return Math.atan2(this._y, this._x);
        }// end function

        public function normalize() : Vector2D
        {
            if (this.length == 0)
            {
                this._x = 1;
                return this;
            }
            var _loc_1:* = this.length;
            this._x = this._x / _loc_1;
            this._y = this._y / _loc_1;
            return this;
        }// end function

        public function truncate(param1:Number) : Vector2D
        {
            this.length = Math.min(param1, this.length);
            return this;
        }// end function

        public function reverse() : Vector2D
        {
            this._x = -this._x;
            this._y = -this._y;
            return this;
        }// end function

        public function isNormalized() : Boolean
        {
            return this.length == 1;
        }// end function

        public function dotProd(param1:Vector2D) : Number
        {
            return this._x * param1.x + this._y * param1.y;
        }// end function

        public function crossProd(param1:Vector2D) : Number
        {
            return this._x * param1.y - this._y * param1.x;
        }// end function

        public function sign(param1:Vector2D) : int
        {
            return this.perp.dotProd(param1) < 0 ? (-1) : (1);
        }// end function

        public function signQuickly(param1:Vector2D) : int
        {
            return (-this._y) * param1.x + this._x * param1.y < 0 ? (-1) : (1);
        }// end function

        public function get perp() : Vector2D
        {
            return new Vector2D(-this.y, this.x);
        }// end function

        public function dist(param1:Vector2D) : Number
        {
            return Math.sqrt(this.distSQ(param1));
        }// end function

        public function distSQ(param1:Vector2D) : Number
        {
            var _loc_2:* = param1.x - this.x;
            var _loc_3:* = param1.y - this.y;
            return _loc_2 * _loc_2 + _loc_3 * _loc_3;
        }// end function

        public function add(param1:Vector2D) : Vector2D
        {
            return new Vector2D(this._x + param1.x, this._y + param1.y);
        }// end function

        public function subtract(param1:Vector2D) : Vector2D
        {
            return new Vector2D(this._x - param1.x, this._y - param1.y);
        }// end function

        public function multiply(param1:Number) : Vector2D
        {
            return new Vector2D(this._x * param1, this._y * param1);
        }// end function

        public function divide(param1:Number) : Vector2D
        {
            return new Vector2D(this._x / param1, this._y / param1);
        }// end function

        public function equals(param1:Vector2D) : Boolean
        {
            if (this._x == param1.x)
            {
            }
            return this._y == param1.y;
        }// end function

        public function set x(param1:Number) : void
        {
            this._x = param1;
            return;
        }// end function

        public function get x() : Number
        {
            return this._x;
        }// end function

        public function set y(param1:Number) : void
        {
            this._y = param1;
            return;
        }// end function

        public function get y() : Number
        {
            return this._y;
        }// end function

        public function toString() : String
        {
            return "[Vector2D (x:" + this._x + ", y:" + this._y + ")]";
        }// end function

        public static function angleBetween(param1:Vector2D, param2:Vector2D) : Number
        {
            if (!param1.isNormalized())
            {
                param1 = param1.clone().normalize();
            }
            if (!param2.isNormalized())
            {
                param2 = param2.clone().normalize();
            }
            return Math.acos(param1.dotProd(param2));
        }// end function

    }
}
