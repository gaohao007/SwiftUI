import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertiseClass } from "../model";
import { UserSettingClass } from '../utils/setting';

import { app_bottom_height, app_top_Height, SUB_WINDOWN_NAME } from '../constants';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {


    //读取窗口头部的高度
    const  mainWin= windowStage.getMainWindowSync()
    //头部高度(px2vp 将像素转为vp)
 const topHeight =  px2vp(mainWin.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
    AppStorage.setOrCreate<number>(app_top_Height,topHeight)

    const bottomHegith=px2vp(mainWin.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
   AppStorage.setOrCreate<number>(app_bottom_height,bottomHegith)

    // 显示广告页: 模拟广告页
    const result = await new Promise<AdvertiseClass>((resolve,reject)=>{
      setTimeout(()=>{
        resolve({
          showAd:true,
            adTime:10,
            adImg:$r("app.media.start")
        } as AdvertiseClass)
      },500)
    })

    const  userSetting =new UserSettingClass(this.context)
    await userSetting.setUserAd(result)

    if ( result.showAd){
    //  创建广告的窗口
      const  win = await windowStage.createSubWindow(SUB_WINDOWN_NAME)
      await win.showWindow()
      win.setUIContent('pages/Start/Start')
    }
      windowStage.loadContent('pages/Index', (err) => {

      });


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
