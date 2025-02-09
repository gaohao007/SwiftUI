import { app_top_Height, SUB_WINDOWN_NAME } from '../../constants';
import { AdvertiseClass } from '../../model';
import { UserSettingClass } from '../../utils/setting';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct Start {
aboutToDisappear(): void {
clearInterval(this.timer)
}

userSetting:UserSettingClass = new UserSettingClass(getContext(this))
  @State
    adObj:AdvertiseClass ={showAd:true,adTime:0,adImg:""}
  //从首选项取数据
    @StorageProp(app_top_Height)
    headHeight:number=0;
    //定时器
    timer:number =-1
  async aboutToAppear() {
     this.adObj =await this.userSetting.getUserAd()
  this.timer =   setInterval(()=>{
    if (this.adObj.adTime === 0) {
      clearInterval(this.timer)
      //杀死子窗口
      window.findWindow(SUB_WINDOWN_NAME).destroyWindow()
    }
    this.adObj.adTime--
    },1000)
    }
  build() {
    Stack({alignContent:Alignment.TopEnd}){
    Image(this.adObj?.adImg)
      .objectFit(ImageFit.Cover)
      Text(`${this.adObj?.adTime}秒后跳转`)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r('app.color.background_page'))
        .padding(10)
        .margin({right:20,top:this.headHeight})
        .onClick(()=>{
          window.findWindow(SUB_WINDOWN_NAME).destroyWindow()
        })
    }
    .height('100%')
    .width('100%')
  }
}