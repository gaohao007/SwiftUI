
//响应数据封装(泛型接收数据)
export class  ResponseDate<T>{
  code:number=0
  msg:string=""
  data:T |null = null
}