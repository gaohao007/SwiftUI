import { TaskInfoListModel, TaskListParams,TaskDetailInfo } from "../model";
import { Request_API } from "../utils";
//任务列表
export function getTaskList (data:TaskListParams){
  return Request_API.get<TaskInfoListModel>('tasks/list',data)
}
//任务详细
export  function getTaskDetailInfo(id:string){
  return Request_API.get<TaskDetailInfo>(`tasks/details/${id}`)
}