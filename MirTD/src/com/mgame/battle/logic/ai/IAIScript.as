package com.mgame.battle.logic.ai
{
	import com.mgame.battle.Zone;
	import com.rpg.framework.GameTime;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.Role;
	

	public interface IAIScript
	{
		function update(gameTime:GameTime):void;
		function init(zone:Zone,monster:Monster,player:Role):void;
		function stop():void;
		function start():void;
		function dispose():void;
		function setData(key:int,value:Object):void;
	}
}