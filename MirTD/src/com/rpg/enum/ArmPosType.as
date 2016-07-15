package com.rpg.enum
{
	public class ArmPosType
	{
		public static const PosWeapon:int = 1;
		public static const PosRing1:int = 2;
		public static const PosHand1:int = 3;
		public static const PosHead:int = 4;
		public static const PosClothes:int = 5;
		public static const PosShoes:int = 6;
		public static const PosYaodai:int = 7;
		public static const PosNecklace:int = 8;
		
		public static const PosRing2:int = 9;
		public static const PsoHand2:int = 10;
		
		public static const Wing:int = 101;
		public static const Horse:int = 102;
		
		public static const FPosClothes:int = 1;
		public static const FPosWeapon:int = 2;
		public static const FPosHead:int = 3;
		public static const FPosPet:int = 5;
		public static const FPosFoot:int = 4;
		public static const FPosHorse:int = 6;
		
		public static const roleArms:Array = [PosWeapon,PosHead,PosClothes];
		
		public static function equals(armcls:int ,fashion:int):Boolean{
			switch(fashion){
				case FPosClothes:if(armcls == PosClothes)return true;break;
				case FPosWeapon:return true;break;
				case FPosHead:return true;break;
			}
			return false;
		}
		
		public static function armToFashionPos(armcls:int):int{
			var fs:int = 0;
			switch(armcls){
				case PosClothes:fs = FPosClothes;break;
				case PosWeapon:fs = FPosWeapon;break;
				case PosHead:fs = FPosHead;break;
			}
			return fs;
		}
	}
}