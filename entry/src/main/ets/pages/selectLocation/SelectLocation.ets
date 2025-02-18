import { Card, CardItem, NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { webview } from '@kit.ArkWeb';
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { PermissionAuth } from '../../utils';
import { promptAction } from '@kit.ArkUI';


/**
 * 实现定位：
 * 1.获取当前的经纬度（当前位置），根据手机的具体位置来确定--》获取当前位置
 *      1.1 使用LocationKit，需要添加定位权限：权限的级别、授权方式
 *          ohos.permission.APPROXIMATELY_LOCATION  normal/user_grant
 *          ohos.permission.LOCATION normal/user_grant
 *      1.2 具体使用
 * 2.传递给网页端（location.html），然后进行具体定位--》如何传递
 *
 */

@Entry
@Component
struct SelectLocation {

  webController: webview.WebviewController = new webview.WebviewController()

  peemission:Permissions[]=["ohos.permission.LOCATION","ohos.permission.APPROXIMATELY_LOCATION"]



  aboutToAppear(): void {
    // this.checkPermisson()
    this.checkPermissionByUtil()
  }
  
  async checkPermissionByUtil(){
    try {
      if (PermissionAuth.getInstance().checkPermission(this.peemission)) {
        //已经授权
        this.getLocation()
      }else {
        //没有授权
        await PermissionAuth.getInstance().requestPermission(this.peemission)
      }
    } catch (err) {

      promptAction.showDialog({
        title:"权限提示",
        message:"定位功能需要权限,请在系统设置中打开定位权限",
        alignment:DialogAlignment.Center,
        buttons:[
          {text:"取消",color:$r("app.color.primary_disabled")},
          {text:"打开",color:$r("app.color.primary")}
        ]
      }).then(res=>{
        if (res.index ==1) {
          PermissionAuth.getInstance().openPermissionSettingPage()
        }
      })
    }
  }
  
  
  
  
  
  
  
  
  

  //检查权限
  async checkPermisson(){
    const  manager = abilityAccessCtrl.createAtManager()
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const  status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId,this.peemission[0])
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      //没有权限
      const  res = await manager.requestPermissionsFromUser(getContext(),this.peemission)
      if (res.authResults[0] !==0 ) {
        //二次授权
        const context = getContext() as common.UIAbilityContext
        context.startAbility({
          bundleName:"com.huawei.hmos.settings",
          abilityName: "com.huawei.hmos.settings.MainAbility",
          uri: "application_info_entry",
          parameters:{
            pushParams:appInfo.name
          }
        })
      }
      else {
        this.getLocation()
      }


    }else {
      this.getLocation()
    }
  }

async   getLocation(){
  try {
    const res = await geoLocationManager.getCurrentLocation()
    AlertDialog.show({message:JSON.stringify(res)})
  } catch (err) {
    AlertDialog.show({message:JSON.stringify(err)})
  }
}

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