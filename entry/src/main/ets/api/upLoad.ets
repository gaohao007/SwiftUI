import { request } from "@kit.BasicServicesKit";
import { BASE_URL, TOKEN_KEY } from "../constants";
import { Context } from "@kit.AbilityKit";
import { Log } from "@abner/log";
import { ImageList, ResponseDate } from "../model";

export async  function upLoadImage(context:Context,file:request.File[]){

  return new  Promise<ImageList[]>(async (resolve,reject)=>{
    try {
      //config

      const  serverImage:ImageList[]=[]
      let uploadConfig:request.UploadConfig={
        url:BASE_URL+"/files/imageUpload",
        method:"POST",
        files:file,
        data:[],
        header:{
          "Content-Type":"multipart/form-data",
          "Authorization":  AppStorage.get<string>(TOKEN_KEY) ||""
        }
      }
      const task=  await request.uploadFile(context,uploadConfig)
      //   监听
      task.on("complete",(state:request.TaskState[])=>{
        //上传完成,获取接口返回的内容
        resolve(serverImage)
      })
      // 每张图片上传完成后都会执行该状态,header记录了上传返回接口的内容
      task.on("headerReceive",(headr)=>{
        Log.info(JSON.stringify(headr))
        if (headr["body"]) {
          const result = JSON.parse(headr["body"]) as ResponseDate<string>
          if (result.code === 200) {
            serverImage.push({url:result.data} as ImageList)
          }
        }
      })
      task.on('fail',(state:request.TaskState[])=>{
        reject(new Error('上传失败!!'))
      })

    }catch (err){
      AlertDialog.show({message:"上传失败"+JSON.stringify(err)})
      reject(new Error('上传失败'))
    }

  })




}