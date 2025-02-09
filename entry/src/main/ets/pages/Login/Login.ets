import { app_top_Height } from '../../constants';

@Entry
@Component
struct Login {

  build() {
    Column({space:15}){
        Image($r("app.media.icon"))
          .height(200)
          .width(200)
          .borderRadius(100)
          .margin({top:20})
      Text('顺风速达').fontSize(40).fontWeight(700)
      Row(){
        Text('账号登录')
          .fontSize(24)
          .fontWeight(800)
        Blank()
        Text('账号登录')
          .fontColor('#ff0000')
          Image($r("app.media.ic_angle")).width(12).height(12)
            .fillColor('#ff0000')
      }.width('100%')
      .padding({left:20,right:20})
       TextInput({placeholder:"请输入账号"})
         .backgroundColor('#0588e0')
         .width('80%')
         .margin({top:20})
         .type(InputType.Normal)
         .borderRadius(0)
         .border({width:{bottom:1},color:"#c1c1c1"})

      TextInput({placeholder:"请输入密码"})
        .backgroundColor('#0588e0')
        .width('80%')
        .margin({top:20})
        .type(InputType.Password)
        .borderRadius(0)
        .border({width:{bottom:1},color:"#c1c1c1"})

      Button("登 录").width('80%')
        .margin({top:20})
        .backgroundColor('#f20600')

    }
    .height('100%')
    .width('100%')

    .backgroundColor('#0588e0')

  }
}