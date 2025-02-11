import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import { BASE_URL, TOKEN_KEY } from '../constants'
import { promptAction } from '@kit.ArkUI'
import { Log } from '@abner/log'

const instance= axios.create({
  baseURL:BASE_URL,
  timeout:60000
})

instance.interceptors.request.use(async (config:InternalAxiosRequestConfig)=>{
config.headers.Authorization = AppStorage.get(TOKEN_KEY) || ""
  return config
},(err:AxiosError)=>{
  promptAction.showToast({message:err.message,duration:10000})
  return Promise.reject(err)
})

instance.interceptors.response.use((response:AxiosResponse)=>{
  if (response.data.httpcode === 200 && response.data) {
    Log.info(JSON.stringify(response))
    return response.data.data
  }
  return response
},
  (err:AxiosError)=>{
    promptAction.showToast({message:err.message,duration:10000})
    return Promise.reject(err)
  }
)

export  {instance}






