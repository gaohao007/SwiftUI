import { Card, CardItem, NavBar } from '../../components'
import { app_top_Height } from '../../constants'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../model'
import { promptAction, router } from '@kit.ArkUI'
import { Log } from '@abner/log'
import { getTaskDetailInfo } from '../../api/task'
import { HmCheckBox } from '../../components/CheckBox'

@Entry
@Component
struct CardRecord {
@State
taskDetailData:TaskDetailInfo= new TaskDetailInfoModel({} as TaskDetailInfo)

    aboutToAppear() {
  const  params = router.getParams() as CommonRouterParams
    if (params && params.id) {
           this.getTaskDetail(params.id)
    }
  }
  async getTaskDetail(id: string) {
    this.taskDetailData  = await getTaskDetailInfo(id)
    Log.info(JSON.stringify(this.taskDetailData))
  }


  build() {
    Column(){
          Row().width('100%')
            .backgroundColor($r("app.color.white"))
            .height(AppStorage.get(app_top_Height))


      NavBar({title:"回车登记"})
      Card(){
            CardItem({
              leftTitle:"出车时间",
              rightValue:this.taskDetailData.actualDepartureTime || "",
              showRightArrow:false
            })

        CardItem({
          leftTitle:"回车时间",
          rightValue:"请选择",
          showBottomBorder:false,
          onRightClick:()=>{
            DatePickerDialog.show({
              showTime:true,
              useMilitaryTime:true,
              alignment:DialogAlignment.Bottom,
              onDateAccept:(data:Date)=>{
                promptAction.showToast({message:JSON.stringify(data)})
              }
            })
          }
        })

        HmCheckBox({title:"车辆违章",value:false})
        HmCheckBox({title:"车辆故障",value:false})
        HmCheckBox({title:"车辆事故",value:false})
      }
      Row(){
            Button('交车').width('40%')
              .backgroundColor($r("app.color.primary"))
      }.height(80)
      .width('100%')
      .position({y:"100%"})
      .translate({y:-80})
      .backgroundColor($r("app.color.white"))
      .justifyContent(FlexAlign.Center)

    }.height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}