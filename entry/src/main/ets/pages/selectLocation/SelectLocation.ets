import { Card, CardItem, NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { webview } from '@kit.ArkWeb';
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { PermissionAuth, WebSdkClass } from '../../utils';
import { promptAction, router } from '@kit.ArkUI';



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

  // webController: webview.WebviewController = new webview.WebviewController()

  peemission:Permissions[]=["ohos.permission.LOCATION","ohos.permission.APPROXIMATELY_LOCATION"]

 webSdk :WebSdkClass = new WebSdkClass()
  @State list:AddressItem[]=[]

  aboutToAppear(): void {
    // this.checkPermisson()
    this.checkPermissionByUtil()

    WebSdkClass.webController = new webview.WebviewController()
    WebSdkClass.context = getContext(this)
    WebSdkClass.context.eventHub.on('search_near_place',(json:string)=>{
      this.list = JSON.parse(json) as AddressItem[]
    })
  }
  
  async checkPermissionByUtil(){
    try {
      if (PermissionAuth.getInstance().checkPermission(this.peemission)) {
        //已经授权
        // this.getLocation()
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

         Web({src:$rawfile("location.html"),controller:WebSdkClass.webController})
           .height('100%')
           .javaScriptProxy({
             name:"swift",
             object:this.webSdk,
             methodList:["setCurrentLocation", "alert", "receiveNearPlace"],
             controller:WebSdkClass.webController
           })
           // .onPageEnd(async ()=>{
           //   try {
           //     //页面加载玩,调用js
           //     const res = await geoLocationManager.getCurrentLocation()
           //     Log.info(JSON.stringify(res))
           //     //坐标的纠正：将wgs84标准转换成gcj02标准
           //     let wgs84Position: mapCommon.LatLng = {
           //       latitude: res.latitude,
           //       longitude: res.longitude
           //     };
           //     let gcj02Position: mapCommon.LatLng =
           //       await map.convertCoordinate(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02,wgs84Position);
           //      Log.info(JSON.stringify(gcj02Position))
           //
           //     this.webController.runJavaScript(`setLocation(${gcj02Position.longitude}, ${gcj02Position.latitude})`)
           //   } catch (err) {
           //     AlertDialog.show({ message: JSON.stringify(err) })
           //   }
           // })





      Column(){
        Card(){
         ForEach(this.list,(item:AddressItem,index:number)=>{
           CardItem({
             leftTitle:item.address,rightValue:item.distance+"m以内",
             onRightClick:()=>{
               router.back({
                 url:"pages/ExceptionReports/ExceptionReport",
                 params:{
                   address:item.address
                 }
               })
             }
           })
         })
        }
      }.position({ y: "100%" })
        .translate({ y: -280})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}
class AddressItem{
  address:string=""
  distance:number=0
}
