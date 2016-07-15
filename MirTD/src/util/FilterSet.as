package util
{
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class FilterSet
	{
		public static const miaobian:GlowFilter = new GlowFilter(0x000000, 1.0, 2.0, 2.0, 10, 1, false, false);
		/** 灰色滤镜 */
		public static const GrayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,
			0.3086,0.6094,0.082,0,0,
			0.3086,0.6094,0.082,0,0,
			0,0,0,1,0 ]);
		
		/**人物高光*/
		public static const bmpLightFilter:ColorMatrixFilter = new ColorMatrixFilter([1.5,0,0,0,40,0,1.5,0,0,40,0,0,1.2,0,40,0,0,0,1,0]);
		/**人物灰色，石化效果*/
		public static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,-20,0.3086,0.6094,0.082,0,-20,0.3086,0.6094,0.082,0,-20,0,0,0,1,0]);
		/**人物变绿，中毒效果*/
		public static const greenFilter:ColorMatrixFilter = new ColorMatrixFilter([0,0,0,0,0,0,0.8,0,0,0,0,0,0,0,0,0,0,0,1,0]);
		/**人物变绿，冰冻效果*/
		public static const blueFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0,0,0,0  ,0,0.6,0,0,0  ,0,0,1,0,0  ,0,0,0,1,0]);
		//public static const blueFilter:ColorMatrixFilter = new ColorMatrixFilter([0,0,0.1,0,0  ,0,0,0.5,0,0  ,0,0,1,0,0  ,0,0,0,1,0]);
		/**人物变绿，灼烧效果*/
		public static const redFilter:ColorMatrixFilter = new ColorMatrixFilter([0.8,0,0,0,0  ,0,0.4,0,0,0  ,0,0,0.3,0,0,  0,0,0,1,0]);
		
		/**npc光圈变绿*/
		public static const greenFocusFilter:ColorMatrixFilter = new ColorMatrixFilter([-0.599030763463664 , 1.2949790963718733 , 0.30405166709179066 , 0 , 80 ,
			0.44759574079797143 , 0.45864053526489096 , 0.09376372393713758 , 0 , 80 , 0.28610293556772587 , 1.5432959904355843 , -0.8293989260033101 , 0 , 80 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 1 ]);
		
		/**怪物高光*/
		public static const mouseGlowFilter:GlowFilter = new GlowFilter(0xff0000,1,8,8);
		/**人物高光*/
		public static const mouseGlowFilter2:GlowFilter = new GlowFilter(0xffffff,1,8,8);
		/**npc高光*/
		public static const mouseGlowFilter3:GlowFilter = new GlowFilter(0x6aa71b,1,8,8);
		
		/**城主发光*/
		public static const chengzhuFilter:GlowFilter = new GlowFilter(0xffd700,1,16,16);
		/**
		 * 影子模糊滤镜 
		 */
		public static const blurFilter:BlurFilter = new BlurFilter(7,7);
		
		/**关卡选中高光*/
		public static const lvSelectFilter:GlowFilter = new GlowFilter(0xffd700,1,10,10,5);
	}
}