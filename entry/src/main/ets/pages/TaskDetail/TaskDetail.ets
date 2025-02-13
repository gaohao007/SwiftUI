
import { router } from '@kit.ArkUI'
import { getTaskDetailInfo } from '../../api/task'
import { NavBar } from '../../components'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../model'

@Entry
@Component
struct TaskDetail {
  @State
    taskDetailDateInfo:TaskDetailInfo = new TaskDetailInfoModel({} as TaskDetailInfo)
  async aboutToAppear() {
  const params =router.getParams() as CommonRouterParams
    if (params &&  params.id) {
     await this.getTaskDetailData(params.id)
    }



  }
  async getTaskDetailData(id:string){
    const res = await getTaskDetailInfo(id)
    this.taskDetailDateInfo = res
  }

  build() {
    Column(){
        NavBar({title:"订单详情"})
      Text(JSON.stringify(this.taskDetailDateInfo))
    }
    .height('100%')
    .width('100%')
  }
}