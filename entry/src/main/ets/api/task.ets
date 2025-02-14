import { TaskInfoListModel, TaskListParams,TaskDetailInfo,PickUpParams, DeliverParams } from "../model";

import { Request_API } from "../utils";
//任务列表
export function getTaskList (data:TaskListParams){
  return Request_API.get<TaskInfoListModel>('tasks/list',data)
}
//任务详细
export  function getTaskDetailInfo(id:string){
  return Request_API.get<TaskDetailInfo>(`tasks/details/${id}`)
}

//提货接口
export function  pickUp  (data: PickUpParams) {
  return Request_API.post<null>("tasks/takeDelivery", data)
}

//交货接口
export function  deliver (data: DeliverParams) {
  return Request_API.post<null>("tasks/deliver", data)
}