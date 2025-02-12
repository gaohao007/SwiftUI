import { TaskList, TaskListModel } from "../../../../model/task"


@Component
export  struct TaskItemCard{
  taskItemData:TaskList = new TaskListModel({} as TaskList)

  getBtnEnable() {
    if (this.taskItemData.enablePickUp) {
      return true
    }

    return false
  }

  build() {
    Column(){
      Row() {
        Text(`任务编号：${this.taskItemData.transportTaskId}`)
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

        Button("提货")
          .backgroundColor(this.getBtnEnable() ? $r("app.color.primary") : $r("app.color.primary_disabled"))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }.backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .margin({left:15,right:15,top:15})
    .padding(19)
  }
}