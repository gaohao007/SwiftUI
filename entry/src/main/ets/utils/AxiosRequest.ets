import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import { BASE_URL, TOKEN_KEY } from '../constants'
import { UserSettingClass } from './setting'
import { promptAction } from '@kit.ArkUI'
import { Log } from '@abner/log'

const instance= axios.create({
  baseURL:BASE_URL,
  timeout:60000,
  headers:{
      "Content-Type": "application/json", //指定数据的格式,
      "Authorization": AppStorage.get<string>(TOKEN_KEY) || ""
  }
})

instance.interceptors.request.use(async (config:InternalAxiosRequestConfig)=>{
  const  token:string = AppStorage.get(TOKEN_KEY) || ""
  if (token) {
    config.headers['Authorization'] =token
  }
  return config
},(err:AxiosError)=>{
  promptAction.showToast({message:err.message,duration:10000})
  return Promise.reject(err)
})

instance.interceptors.response.use((response:AxiosResponse)=>{
  if (response.data.httpcode === 200 && response.data) {
    Log.info(JSON.stringify(response))
    return response
  }else{
  }
  return Promise.reject(response.data)
},
  (err:AxiosError)=>{
    promptAction.showToast({message:err.message,duration:10000})
    return Promise.reject(err)
  }
)

export  {instance}






