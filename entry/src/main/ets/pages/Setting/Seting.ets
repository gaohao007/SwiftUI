import { Card, CardItem, Confirmdelete, NavBar } from '../../components';
import { TOKEN_KEY } from '../../constants';
import { UserSettingClass } from '../../utils/setting';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Seting {

  logout(){
    AppStorage.set(TOKEN_KEY,"")
    new UserSettingClass(getContext(this)).setUserToken('')
    router.clear()
    router.replaceUrl({
      url:"pages/Login/Login"
    })
  }

  confirm:CustomDialogController = new CustomDialogController({
    builder:Confirmdelete({message:"确定退出登录吗?",
      buttonList:[
        {
      title:"取消",
        fontsize:14,
        fontColor:$r("app.color.text_secondary")
      },
        {
          title:"退出",
          fontsize:14,
          fontColor:$r("app.color.primary"),
          action:()=>{
              this.logout()
          }
        }
      ],
    }),
    customStyle:true,
    alignment:DialogAlignment.Center,
    autoCancel:false
  })
  build() {
    Column(){
      NavBar({title:"系统设置"})

      Card(){
        CardItem({
          leftTitle:"换绑手机"
        })

        CardItem({
          leftTitle:"修改密码"
        })


        CardItem({
          leftTitle:"消息通知设置"
        })


        CardItem({
          leftTitle:"清理缓存",
          showBottomBorder:false
        })


      }
      Row(){
        Button('退出')
          .width('100%')
          .backgroundColor('#fff')
          .fontColor($r("app.color.text_primary"))
          .onClick(()=>{
            this.confirm.open()
          })
      }.width('100%')
      .padding({left:15,right:15})
      .margin({top:20})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}