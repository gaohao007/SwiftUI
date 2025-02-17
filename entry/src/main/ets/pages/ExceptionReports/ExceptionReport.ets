import { NavBar } from '../../components';
import { app_top_Height } from '../../constants';

@Entry
@Component
struct ExceptionReport {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Row().width('100%')
        .height(AppStorage.get(app_top_Height))
        .backgroundColor($r("app.color.white"))
      NavBar({title:"上报异常"})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}