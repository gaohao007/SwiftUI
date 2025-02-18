import { Log } from "@abner/log";
import { webview } from "@kit.ArkWeb";
import { geoLocationManager } from "@kit.LocationKit";
import { mapCommon,map } from "@kit.MapKit";


export class WebSdkClass{
  static webController:webview.WebviewController | null = null

  async setCurrentLocation(){
    try {
          //页面加载玩,调用js
          const res = await geoLocationManager.getCurrentLocation()
          Log.info(JSON.stringify(res))
          //坐标的纠正：将wgs84标准转换成gcj02标准
          let wgs84Position: mapCommon.LatLng = {
            latitude: res.latitude,
            longitude: res.longitude
          };
          let gcj02Position: mapCommon.LatLng =
            await map.convertCoordinate(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02,wgs84Position);
           Log.info(JSON.stringify(gcj02Position))
     await WebSdkClass.webController!.runJavaScript(`setLocation(${gcj02Position.longitude}, ${gcj02Position.latitude})`)
    } catch (err) {
      AlertDialog.show({ message: JSON.stringify(err) })
    }
  }

}







