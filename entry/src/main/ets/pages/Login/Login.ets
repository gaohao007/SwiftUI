import { promptAction, router } from '@kit.ArkUI';
import { LoginForm, LoginFormModel } from '../../model';
import { TOKEN_KEY, } from '../../constants';
import {Log} from "@abner/log"
import { UserSettingClass } from '../../utils/setting';
import { login } from '../../api/user';



PersistentStorage.persistProp(TOKEN_KEY,"")
@Entry
@Component
struct Login {
@State isShow:boolean = false


  @State
  accountForm: LoginForm = new LoginFormModel({
    account: "",
    password:''
  })

  build() {
    Column({space:15}){
        Image($r("app.media.icon"))
          .height(200)
          .width(200)
          .borderRadius(100)
          .margin({top:20})
      Text('顺风速达').fontSize(40).fontWeight(700)
        .fontColor('#fff')

        Row() {
          Text('账号登录')
            .fontSize(24)
            .fontWeight(800)
            .fontColor('#fff')
          Blank()
          Text('手机号登录')
            .fontColor('#ff0000')
          Image($r("app.media.ic_angle")).width(12).height(12)
            .fillColor('#ff0000')
        }.width('100%')
        .padding({ left: 20, right: 20 })

        TextInput({ placeholder: "请输入账号" })
          .backgroundColor('#0588e0')
          .width('80%')
          .margin({ top: 20 })
          .type(InputType.Normal)
          .borderRadius(0)
          .border({ width: { bottom: 1 }, color: "#c1c1c1" })
          .onChange((value: string) => {
            this.accountForm.account = value
          })

        TextInput({ placeholder: "请输入密码" })
          .backgroundColor('#0588e0')
          .width('80%')
          .margin({ top: 20 })
          .type(InputType.Password)
          .borderRadius(0)
          .border({ width: { bottom: 1 }, color: "#c1c1c1" })
          .onChange((value: string) => {
            this.accountForm.password = value
          })

        Button({ type: ButtonType.Capsule, stateEffect: this.getFormValidate() }) {
          Row({ space: 10 }) {
            if (this.isShow) {
              LoadingProgress().width(20)
                .color($r("app.color.white"))
                .height(30)
            }
            Text('登录')
          }
        }
        .width('80%')
        .height(50)
        .margin({ top: 20 })
        .backgroundColor(this.getFormValidate() ? $r("app.color.primary") : $r("app.color.primary_disabled"))
        .enabled(this.getFormValidate())
        .onClick(async () => {
          this.isShow = true
          promptAction.showToast({ message: "登录成功!" })
        // http请求
          this.login(this.accountForm)

          //  const token = await instance.post<null,string>('/login/account',this.accountForm)
        //   Log.info(token)
        })


    }
    .height('100%')
    .width('100%')

    .backgroundColor('#0588e0')

  }
  // 显示按钮是否可用
  getFormValidate(){
    if (this.accountForm.account!=="" && this.accountForm.password !=="") {
      return true
    }
    return false
  }



  async login(data:LoginForm){

    try {
      this.isShow=true
      const token = await login(data)
      Log.info(token)
      AppStorage.set(TOKEN_KEY,token)
      new UserSettingClass(getContext(this)).setUserToken(token)
      this.isShow = false
      router.replaceUrl({url:"pages/Index/Index"})
    }catch (err){
      promptAction.showToast({message:"登录失败"})
    } finally {
      this.isShow = false
    }

  }
}