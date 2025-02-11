//提供接口的调用方法.//请求方法不同
import { http } from "@kit.NetworkKit";
import {TOKEN_KEY } from "../constants";
import { ResponseDate } from "../model";
import { promptAction, router } from "@kit.ArkUI";
import { UserSettingClass } from "./setting";


export  class  Request_API{
  // 'http://122.51.240.24:31007/driver/' ||
static readonly baseUrl:string ="http://124.220.148.251:8080/driver/"
static getUrl:string=''
  static async request<T>(url:string="",data?:object,method:http.RequestMethod=http.RequestMethod.GET):Promise<T>{
    const  httpRequest = http.createHttp()
    const config:http.HttpRequestOptions ={
      method:method,
      readTimeout:10000,
      header: {
        "Content-Type": "application/json", //指定数据的格式,
        "Authorization":  AppStorage.get<string>(TOKEN_KEY) ||""
      },
      extraData:method === http.RequestMethod.GET?  "":data



    }
    if (method === http.RequestMethod.GET){
      if (data && Object.keys(data).length) {
        let arr:string[]=[]
        for (let i=0;i<Object.keys(data).length;i++) {

         let key = Object.keys(data)[i]
          // 防止空值
          if (data[key]) {
            arr.push(`${key}=${data[key]}`)
          }
        }
        Request_API.getUrl= Request_API.baseUrl+"?"+arr.join('&')
      }

    }

    try {
      // 3. 发送请求
      const res = await httpRequest.request(Request_API.baseUrl+url, config)
      // 4. 解析响应
      if (res.responseCode === 401) {
        AlertDialog.show({message:"未授权或Token失效"})
      //   需要将本地token清除
        AppStorage.set<string>(TOKEN_KEY,"")
        new UserSettingClass(getContext()).setUserToken("")
        router.pushUrl({url:"pages/Login/Login"})
        return Promise.reject(new Error("未授权或Token失效"))
      } else if (res.responseCode === 404) {
        AlertDialog.show({message:"请求的地址不存在"})
        return Promise.reject(new Error("未授权或Token失效"))
      } else if(res.responseCode === 200) {
        const result = JSON.parse(res.result as string) as ResponseDate<T>
        if (result.code ===200) {
          return result.data as T
        }
        else {
          promptAction.showToast({message:"调用接口失败"+result.msg})

          return Promise.reject(new Error("调用接口失败"+result.msg))
        }
      }else {
        return Promise.reject(new Error("服务器调用接口失败!"))
      }
    } catch (error) {
      return Promise.reject(new Error("catch"+JSON.stringify(error)))
    } finally {
      httpRequest.destroy()

    }
  }



//   get请求
  /**
   *
   * @param url 接口地址
   * @param data 需要的参数
   * @returns  返回的数据
   */
  static get <T>(url:string,data?:object):Promise<T>{
    //创建请求
    return Request_API.request(url,data,http.RequestMethod.GET)
  }
//post 请求
  static post <T>(url:string,data?:object):Promise<T>{
    return Request_API.request(url,data,http.RequestMethod.POST)
    //创建请求
  }
//put请求
  static put <T>(url:string,data?:object):Promise<T>{
    //创建请求
    return Request_API.request(url,data,http.RequestMethod.PUT)
  }
//delete请求
  static delete <T>(url:string,data?:object):Promise<T>{
    //创建请求
    return Request_API.request(url,data,http.RequestMethod.DELETE)
  }
}