import { abilityAccessCtrl, bundleManager, common, Permissions } from "@kit.AbilityKit";

//授权封装
export class PermissionAuth{

  private  static  permissionAuth:PermissionAuth

  static getInstance(){
    if (!PermissionAuth.permissionAuth) {
      PermissionAuth.permissionAuth = new PermissionAuth()
    }
    return PermissionAuth.permissionAuth
  }
     checkPermission(permission:Permissions[]){
    //创建一个授权管理器对象
    const manager = abilityAccessCtrl.createAtManager()
    const  appInfo =bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
 const authResults = permission.map((per:Permissions)=>{
   return manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId,per)
 })
    return authResults.every((result:abilityAccessCtrl.GrantStatus)=>{
      return  result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
  }
//   授权
   async requestPermission(permission:Permissions[]):Promise<boolean>{
     const  manager = abilityAccessCtrl.createAtManager()
    const  results = await manager.requestPermissionsFromUser(getContext(),permission)
    const isAuth = results.authResults.every((res:abilityAccessCtrl.GrantStatus)=>{
      return res === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    return isAuth ? Promise.resolve(true):Promise.reject(false)
  }

//二次授权
   openPermissionSettingPage(){
     const context = getContext() as common.UIAbilityContext
    const  appInfo =bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    context.startAbility({
      bundleName: "com.huawei.hmos.settings",
      abilityName: "com.huawei.hmos.settings.MainAbility",
      uri: "application_info_entry",
      parameters: {
        pushParams: appInfo.name
      }
    })
  }
}