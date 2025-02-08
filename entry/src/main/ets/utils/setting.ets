import { Context } from "@kit.AbilityKit"
import { preferences } from "@kit.ArkData"
import { setting_key, setting_key_ad, USER_TOKEN_KEY } from "../constants"
import { AdvertiseClass } from "../model"


const defaultAd:AdvertiseClass={
  showAd:true,
  adTime:5,
  adImg:$r("app.media.start")
}



//   存取用户设置的数据
export class UserSettingClass{
  context:Context

  constructor(context:Context) {
    this.context = context
  }
  getStore(){
    return preferences.getPreferences(this.context,setting_key)
  }

 async  setUserAd(ad:AdvertiseClass){
    const store = await this.getStore()
    store.put(setting_key_ad,JSON.stringify(ad))
   store.flush()
  }

  async getUserAd():Promise<AdvertiseClass>{
    const store = await this.getStore()
    const  str = await store.get(setting_key_ad,JSON.stringify(defaultAd))
    return JSON.parse(str as string) as AdvertiseClass
  }

// 针对token
  async setUserToken(token:string){
    const store = await this.getStore()
    store.put(USER_TOKEN_KEY,token)
    store.flush()
  }
  async  getUserToken():Promise<string>{
    const store = await this.getStore()
    const  str = await store.get(USER_TOKEN_KEY,'') as string
    return  str
  }
}
