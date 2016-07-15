package com.sh.game.util
{
	import com.core.utils.StringUtil;

	public class CSVDataUtil
	{
		public static function listData(str:String):Array
		{
			var list:Array = [];
			var columns:Array = [];
			var lines:Array = str.split("\n");
			var line0:String = lines[0];
			columns = StringUtil.trim(line0).split(",");
			var columnsCount:int = columns.length;
			var row:Array = null;
			for(var i:int=1;i<lines.length;i++){
				var line:String = lines[i];
				if(line){
					row = StringUtil.trim(line).split(',');
					var rowObj:Object = {};
					for(var j:int=0;j<columnsCount;++j){
						rowObj[columns[j]] = row[j];
					}
					list.push(rowObj);
				}
			}
			return list;
		}
	}
}