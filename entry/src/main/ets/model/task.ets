
export  interface  TaskListParams{
  endTime:string |null
  page:number
  pageSize:number
  startTime:string|null
  status:number
  transportTaskId:string|null
}

export class TaskListParamsModel implements  TaskListParams{
  endTime:string |null=null
  page:number=0
  pageSize:number=0
  startTime:string|null=null
  status:number=0
  transportTaskId:string|null=null

  constructor(model:TaskListParams) {
    this.endTime = model.endTime
    this.page = model.page
    this.pageSize = model.pageSize
    this.startTime = model.startTime
    this.status = model.status
    this.transportTaskId = model.transportTaskId
  }
}
//接收的数据类型定义
 export  interface TaskInfoList{
  count:number
   items:TaskList[],
   page:number
   pageSize:number
   pages:number
 }

 export  class  TaskInfoListModel implements TaskInfoList{
   count:number =0
   items:TaskList[]=[]
   page:number=0
   pageSize:number=0
   pages:number=0

   constructor(model:TaskInfoList) {
     this.count = model.count
     this.items = model.items
     this.page = model.page
     this.pages = model.pages
     this.pageSize = model.pageSize
   }
 }





export interface TaskList{
  actualArrivalTime:string
  actualDepartrueTime:string
  created:string
  driverId:string
  enablePickUp:boolean
  endAddress:string
  endAgencyId:number
  finishHandOver:string
  id:string
  planArrivalTime:string
  planDepartureTime:string
  startAddress:string
  startAgencyId:number
  startHandOver:string
  status:string
  transportTaskId:number
}

export  class TaskListModel implements TaskList{
  actualArrivalTime:string=''
  actualDepartrueTime:string=''
  created:string=''
  driverId:string=''
  enablePickUp:boolean=false
  endAddress:string=''
  endAgencyId:number=0
  finishHandOver:string=''
  id:string=''
  planArrivalTime:string=''
  planDepartureTime:string=''
  startAddress:string=''
  startAgencyId:number=0
  startHandOver:string=''
  status:string=''
  transportTaskId:number=0

  constructor(model:TaskList) {
    this.actualArrivalTime =model.actualArrivalTime
    this.actualDepartrueTime =model.actualDepartrueTime
    this.created =model.created
    this.driverId =model.driverId

    this.enablePickUp =model.enablePickUp
    this.endAddress =model.endAddress
    this.endAgencyId =model.endAgencyId
    this.finishHandOver =model.finishHandOver

    this.id =model.id
    this.planArrivalTime =model.planArrivalTime
    this.planDepartureTime =model.planDepartureTime
    this.startAddress =model.startAddress


    this.startAgencyId =model.startAgencyId
    this.startHandOver =model.startHandOver
    this.status =model.status
    this.transportTaskId =model.transportTaskId

  }
}




export  enum  TaskTypeEunm{
  Watting=1,
  Line=2,
  Change=3,
  Delivered =4,
  Cancle=5,
  Finish=6
}











