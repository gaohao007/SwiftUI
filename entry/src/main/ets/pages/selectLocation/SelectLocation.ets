import { Card, CardItem, NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct SelectLocation {
  @State message: string = 'Hello World';
  webController: webview.WebviewController = new webview.WebviewController()
  build() {
    Column(){
      Row().width('100%').height(AppStorage.get(app_top_Height))
        .backgroundColor($r("app.color.white"))

      NavBar({title:"当前位置"})
     Web({src:$rawfile("location.html"),controller:this.webController})
      Column(){
        Card(){
          CardItem({leftTitle:'人民广场',rightValue:"100m以内"})
          CardItem({leftTitle:'步行街',rightValue:"100m以内"})
          CardItem({leftTitle:'长征医院',rightValue:"100m以内"})
          CardItem({leftTitle:'内环高架',rightValue:"100m以内"})
        }
      }.position({ y: "100%" })
        .translate({ y: -280})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}