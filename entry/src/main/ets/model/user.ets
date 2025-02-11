import { resourceManager } from "@kit.LocalizationKit"
//登录
export  interface  LoginForm{
  account:string
  password:string
}

export  class LoginFormModel implements LoginForm{
  account: string =''
  password: string=''

  constructor(model:LoginForm) {
    this.password = model.password
    this.account = model.account
  }
}












//用户信息
export  interface UserInfo{
  avatar:string | Resource
  name:string
  number:string
  phone:string
}
export class UserInfoModel implements  UserInfo{
  avatar:string | Resource=''
  name:string=''
  number:string=''
  phone:string=''

  constructor(model:UserInfo) {
    this.avatar = model.avatar
    this.name = model.name
    this.number = model.number
    this.phone = model.phone
  }
}

//task信息
export  interface  UserTaskInfo{
  completeAmount:number
  taskAmounts:number
  transportMileage:number
  dailyMileage:DailyMileage[]
}
export interface  DailyMileage{
  dateTime:string|null
  mileage:number|null
}
export class DailyMileageModel implements DailyMileage{
  dateTime:string|null = null
  mileage:number|null  = null

  constructor(model:DailyMileage) {
  this.dateTime = model.dateTime
    this.mileage = model.mileage
  }
}

export  class  UserTaskInfoModel implements  UserTaskInfo{
  completeAmount:number=0
  taskAmounts:number=0
  transportMileage:number=0
  dailyMileage:DailyMileage[]=[]
  constructor(model:UserTaskInfo) {
    this.completeAmount=model.completeAmount
    this.taskAmounts = model.taskAmounts
    this.transportMileage = model.transportMileage
    this.dailyMileage = model.dailyMileage
  }
}


//请求参数设置
export  interface  UserTaskInfoParams{
  month:string
  year:string
}
export  class UserTaskInfoParamsModel implements UserTaskInfoParams{
  month:string=''
  year:string=''

  constructor(model:UserTaskInfoParams) {
    this.month= model.month
    this.year = model.year
  }
}










