import { TaskInfoListModel, TaskListParams } from "../model/task";
import { Request_API } from "../utils";

export function getTaskList (data:TaskListParams){
  return Request_API.get<TaskInfoListModel>('tasks/list',data)
}