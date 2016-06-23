package
{
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class Test extends Sprite
	{
		public function Test()
		{
			var text:TextField = new TextField();
			text.text = "aaa";
			addChild(text);
			
			var playerType:String = Capabilities.playerType;
			trace(playerType);
			
			var obj:Object = stage.root.loaderInfo.parameters;
			
			var contextMenu:ContextMenu = new ContextMenu();
			
			var versionItem:ContextMenuItem = new ContextMenuItem("xxxx");
			var insideVersionItem:ContextMenuItem = new ContextMenuItem("aaaa");
			insideVersionItem.separatorBefore = true;
			
			contextMenu.customItems.push(versionItem, insideVersionItem);
			contextMenu.hideBuiltInItems();
			
			this.contextMenu = contextMenu;
		}
	}
}