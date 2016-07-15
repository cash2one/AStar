package com.sh.game.util
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-4 上午10:29:57
	 * 
	 */
	public class ModelName
	{
		public function ModelName()
		{
		}
		
		public static function getSource(model:String,action:int,dir:int):int{
			return int(model) * 1000 + action *10 + dir;
		}
	}
}