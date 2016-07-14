/**Created by the Morn,do not modify.*/
package game.ui.test {
	import morn.core.components.*;
	public class ListItemUI extends View {
		public function ListItemUI(){}
		override protected function createChildren():void {
			super.createChildren();
			loadUI("test/ListItem.xml");
		}
	}
}