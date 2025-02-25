import { NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { router } from '@kit.ArkUI';
import { CommonRouterParams } from '../../model';

@Entry
@Component
struct NoticeDetail {
 @State content:string=""
  @State createTime:string=""
aboutToAppear() {
    const params  = router.getParams() as CommonRouterParams
  if (params && params.createdTime) {
    this.createTime = params.createdTime
  }
  if (params && params.noticeContent) {
    this.content=params.noticeContent
  }
}
  build() {
    Column(){
      Row().width('100%')
        .height(AppStorage.get(app_top_Height))
        .backgroundColor($r("app.color.white"))
      NavBar({ title: '详情'})

      Text('系统公告').fontSize(23)
        .fontWeight(600).width('100%')
        .margin({top:20,bottom:20})
      Text(this.createTime).width('100%')
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
      Text(this.content)
        .width('100%')
        .margin({top:20})
    }
    .height('100%')
    .width('100%')
    .padding({left:20,right:20})
  }
}