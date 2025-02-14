import { Card, CardItem, Confirmdelete, NavBar } from '../../components';
import { app_top_Height, TOKEN_KEY } from '../../constants';
import { UserSettingClass } from '../../utils/setting';
import { router } from '@kit.ArkUI';

import { Log } from '@abner/log';
import { fileIo } from '@kit.CoreFileKit';

PersistentStorage.persistProp(TOKEN_KEY,'')
@Entry
@Component
struct Seting {

  @State files:string[]=[]
aboutToAppear(): void {
    //模块下的文件
    const  context =  getContext(this)
    const cacheDir = context.cacheDir
    this.files = this.getFileByPath(cacheDir)
    const filesDir =context.filesDir
    this.files = [...this.files,...this.getFileByPath(filesDir)]
  const preferencesDir = context.preferencesDir
  this.files = [...this.files, ...this.getFileByPath(preferencesDir)]
  //应用下的文件
  const application = context.getApplicationContext()
  const cacheAppDir = application.cacheDir //缓存目录
  this.files = [...this.files, ...this.getFileByPath(cacheAppDir)]
  const filesAppDir = application.filesDir //file目录
  this.files = [...this.files, ...this.getFileByPath(filesAppDir)]
  const preferencesAppDir = application.preferencesDir
  this.files = [...this.files, ...this.getFileByPath(preferencesAppDir)]
  Log.info(JSON.stringify(this.files))
  }

getFileByPath(path:string):string[]{
    let files:string[]=[]
  fileIo.listFileSync(path,{recursion:true}).forEach((item:string)=>{
    if (fileIo.accessSync(path+item)) {
      if (fileIo.statSync(path+item).isDirectory()) {
        this.getFileByPath(path+item)
      }else {
        files.push(path+item)
      }
    }
  })
    return files
}






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
        fontColor:$r("app.color.text_secondary"),
          action:()=>{
            this.confirm.close()
          }
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

  clearOutRemomery:CustomDialogController = new CustomDialogController({
    builder:Confirmdelete({message:"确定清除缓存吗?",
    buttonList:[
      {
        title:"取消",
        fontsize:14,
        fontColor:$r("app.color.text_secondary"),
        action:()=>{
          this.confirm.close()
        }
      },
      {
        title:"确定",
        fontsize:14,
        fontColor:$r("app.color.primary"),
        action:()=>{
          this.clearAndDeleteRemoneryFiles()
        }
      },
    ]
    }),
    customStyle:true,
    alignment:DialogAlignment.Center,
    autoCancel:false
  })


  build() {
    Column(){

      Row().width('100%')
        .height(AppStorage.get(app_top_Height))
        .backgroundColor($r('app.color.white'))
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
          showBottomBorder:false,
          onRightClick:()=>{
                this.clearOutRemomery.open()
          }
        })


      }
      Row(){
        Button('退出')
          .type(ButtonType.Normal)
          .borderRadius(10)
          .height(36)
          .width('100%')
          .backgroundColor($r("app.color.white"))
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
  clearAndDeleteRemoneryFiles(){
    this.files.forEach((item:string)=>{
      fileIo.unlinkSync(item)
    })
    this.files=[];
    router.replaceUrl({url:"pages/Login/Login"})
  }
}