import { TaskList, TaskListModel, TaskTypeEunm } from "../../../../model/task"
import { router } from "@kit.ArkUI"


@Component
export  struct TaskItemCard{
  taskItemData:TaskList = new TaskListModel({} as TaskList)

  //按钮的文本
  getBtnText(){
    const status = this.taskItemData?.status.toString()
    switch (status){
      case TaskTypeEunm.Watting.toString():
        return '提货';
      case  TaskTypeEunm.Line.toString():
        return "交货";
      case  TaskTypeEunm.Change.toString():
        return "改签"
      case  TaskTypeEunm.Delivered.toString():
        return "回车登记"
      default:
        return ""
    }
  }

  getBtnEnable() {
    if (this.taskItemData?.enablePickUp) {
      return true
    }
    const status = this.taskItemData?.status.toString()
    switch (status){
      case TaskTypeEunm.Line.toString(): //在途
      case TaskTypeEunm.Change.toString()://改签
      case TaskTypeEunm.Delivered.toString()://已交货
     case TaskTypeEunm.Finish.toString()://已完成
        return true
      default :
        return false
    }
    return false
  }

  build() {
    Column(){
      Row() {
        Text(`任务编号：${this.taskItemData.transportTaskId}`)
          .copyOption(CopyOptions.InApp)
          .fontWeight(500)
          .fontColor($r("app.color.text_primary"))
          .lineHeight(22)
      }.width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .height(22)
          .width(22)
          .borderRadius(11)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.startAddress)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
          .margin({ left: 12 })
      }
      .width('100%')
      .margin({ top: 20 })

      Row() {
        Text("止")
          .fontSize(12)
          .height(22)
          .width(22)
          .borderRadius(11)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.primary"))
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.endAddress)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
          .margin({ left: 12 })
      }
      .width('100%')
      .margin({ top: 14 })

      Divider().height(2).color($r("app.color.background_divider"))
        .margin({
          top: 20,
          bottom: 4,
          right: 8,
          left: 8
        })

      Row() {
        Column() {
          Text("提货时间")
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
          Text(this.taskItemData.planDepartureTime)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)


        if (this.taskItemData.status != TaskTypeEunm.Finish.toString()){
          Button(this.getBtnText())
            .backgroundColor(this.getBtnEnable() ? $r("app.color.primary") : $r("app.color.primary_disabled"))
            .fontColor($r("app.color.white"))
            .fontSize(14)
            .height(32)
            .enabled(this.getBtnEnable())
            .onClick(()=>{
              this.gotoTaskDatail()
            })
        }

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .margin({left:15,right:15,top:15})
    .padding(19)
    .onClick(()=>{
      if ( this.taskItemData.status  == TaskTypeEunm.Finish.toString()) {
        this.gotoTaskDatail()
      }
    })
  }



  gotoTaskDatail(){
    router.pushUrl({
      url:"pages/TaskDetail/TaskDetail",
      params:{
        id:this.taskItemData.id
      }
    })
  }
}