import { Card, CardItem, Loading, NavBar } from '../../components'
import { app_top_Height } from '../../constants'
import { CarRecordParams,
  CarRecordParamsModel,
  CommonRouterParams,
  TaskDetailInfo,
  TaskDetailInfoModel } from '../../model'
import { promptAction, router } from '@kit.ArkUI'
import { Log } from '@abner/log'
import { carRecord, getTaskDetailInfo } from '../../api/task'
import { HmCheckBox } from '../../components/CheckBox'
import dayjs from "@hview/dayjs"

@Entry
@Component
struct CardRecord {
  layer:CustomDialogController = new CustomDialogController({
    builder:Loading({loadingText:"回车登录处理中，请稍等！"}),
    customStyle:true,
    autoCancel:false,
    alignment:DialogAlignment.Center
  })

@State
taskDetailData:TaskDetailInfo= new TaskDetailInfoModel({} as TaskDetailInfo)
@State
   carRecordParams:CarRecordParams = new CarRecordParamsModel({} as CarRecordParams)
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
          rightValue:this.carRecordParams.endTime || "请选择",
          showBottomBorder:false,
          onRightClick:()=>{
            DatePickerDialog.show({
              showTime:true,
              useMilitaryTime:true,
              alignment:DialogAlignment.Bottom,
              onDateAccept:(data:Date)=>{
                promptAction.showToast({message:JSON.stringify(data)})
                this.carRecordParams.endTime = dayjs(data).format("YYYY-MM-DD HH:mm:ss")
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
              .onClick(()=>{
                this.btnDeliver()
              })
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
  async btnDeliver(){
    try {
      this.layer.open()
      this.carRecordParams.id = this.taskDetailData.transportTaskId
      this.carRecordParams.startTime = this.taskDetailData.actualDepartureTime
      if (!this.carRecordParams.endTime) {
        promptAction.showToast({message:"请选择回车时间!"})
        return
      }
      await carRecord(this.carRecordParams)
      promptAction.showToast({message:"回车登记完毕!"})
      router.clear()
      router.replaceUrl({url:"pages/Index/Index"})

    } catch (err) {
      promptAction.showToast({message:"回车错误"+JSON.stringify(err)})

    } finally {
      this.layer.close()
    }
  }
}