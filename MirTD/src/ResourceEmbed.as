package
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-31 下午5:43:12
	 * 
	 */
	public class ResourceEmbed
	{
		[Embed(source="/assets/gameres.swf",mimeType="application/octet-stream")]
		public  static var AllRes:Class;
		
		[Embed(source="/assets/data/cfg_levels.csv",mimeType="application/octet-stream")]
		public  static var levelsCfg:Class;
		
		[Embed(source="/assets/data/cfg_model_info.csv",mimeType="application/octet-stream")]
		public  static var modelResCfg:Class;
		
		[Embed(source="/assets/data/cfg_monsters.csv",mimeType="application/octet-stream")]
		public  static var monstersCfg:Class;
		
		[Embed(source="/assets/data/cfg_level_monster.csv",mimeType="application/octet-stream")]
		public  static var levelMonstersCfg:Class;
		
		[Embed(source="/assets/data/cfg_skill_effects.csv",mimeType="application/octet-stream")]
		public  static var skillEffects:Class;
		
		[Embed(source="/assets/data/cfg_skills.csv",mimeType="application/octet-stream")]
		public  static var skills:Class;
		
		[Embed(source="/assets/data/cfg_effects.csv",mimeType="application/octet-stream")]
		public  static var effectsCfg:Class;
		
		[Embed(source="/assets/data/cfg_tianfu_level.csv",mimeType="application/octet-stream")]
		public  static var tianfuCfg:Class;
		
		[Embed(source="/assets/models/tdres.dat",mimeType="application/octet-stream")]
		public  static var TDresDat:Class;
		
		[Embed(source="/assets/models/tdres.res",mimeType="application/octet-stream")]
		public  static var TDresRes:Class;
	}
}