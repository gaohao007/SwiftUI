import { ExceptionList, ExceptionListModel } from "."

//定义路由传参的数据类型
export class CommonRouterParams {
  id?: string = ""
  planTime?:string=""
  address?:string=""
  transmintExceptionDate?:ExceptionList= new ExceptionListModel({} as ExceptionList)
  isExceptionReport?:boolean =false
}