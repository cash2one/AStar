/**Created by the Morn,do not modify.*/
package game.ui.test {
	import morn.core.components.*;
	import game.ui.test.ListItemUI;
	public class MyPageUI extends View {
		public function MyPageUI(){}
		override protected function createChildren():void {
			viewClassMap["game.ui.test.ListItemUI"] = ListItemUI;
			super.createChildren();
			loadUI("test/MyPage.xml");
		}
	}
}