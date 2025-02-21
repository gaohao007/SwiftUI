import { ImageList } from "."

//响应数据封装(泛型接收数据)
export class  ResponseDate<T>{
  code:number=0
  msg:string=""
  data:T |null = null
}

//线程之间发送的数据类型
export class PostParams {
  files: ImageList[] = [] //需要压缩的图片
  filePath: string = "" //图片的存储路径
}