import { Card, CardItem, Loading, NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { promptAction, router } from '@kit.ArkUI';
import { CommonRouterParams, DelayParams, DelayParamsModel, DeliverParamsModel } from '../../model';
import { Log } from '@abner/log';
import dayjs from '@hview/dayjs';
import { delay } from '../../api/task';

@Entry
@Component
struct DelayPickUp {
  layer:CustomDialogController = new CustomDialogController({
    builder:Loading({loadingText:"延迟提货处理中，请稍等！"}),
    customStyle:true,
    autoCancel:false,
    alignment:DialogAlignment.Bottom
  })

  getDate(date:string){
    const  res = new Date(date)
   const day =  `${res.getFullYear()}-${res.getMonth()+1}-${res.getDate()} ${res.getHours()+2}:${res.getMinutes()} `
    console.log('------.day',JSON.stringify(day))
    return day
  }

  @State delayParams:DelayParams = new  DelayParamsModel({} as DelayParams)
  @State endTime:string=""
aboutToAppear(){
  const  res = router.getParams() as CommonRouterParams
  if (res && res.id && res.planTime) {
    Log.info(JSON.stringify(res))
    this.delayParams.id = res.id
    this.endTime = res.planTime||""
  }
}


maxLength:number=50
  build() {
    Column(){
        Row().width('100%')
          .height(AppStorage.get(app_top_Height))
          .backgroundColor($r("app.color.white"))
      NavBar({title:"延迟提货"})
      Card(){
          CardItem({leftTitle:"原定时间",rightValue:this.endTime ||" ",showRightArrow:false})
          CardItem({leftTitle:"延迟时间",rightValue:this.delayParams.delayTime||"不可超过2小时",onRightClick:()=>{
            DatePickerDialog.show({
              showTime:true,
              useMilitaryTime:true,
              alignment:DialogAlignment.Bottom,
              selected:new Date(this.endTime),
              start:new Date(this.endTime),
              end: new Date(this.getDate(this.endTime)),
              onDateAccept:(data:Date)=>{
                promptAction.showToast({message:JSON.stringify(data)})
                this.delayParams.delayTime = dayjs(data).format("YYYY-MM-DD HH:mm")
              }
            })
          }})
        TextArea({placeholder:"请输入延迟提货原因"})
          .height(130)
          .backgroundColor($r("app.color.background_page"))
          .fontSize(14)
          .margin({top:20})
          .placeholderColor($r("app.color.text_secondary"))
          .maxLength(this.maxLength)
          .onChange((vale:string)=>{
           this.delayParams.delayReason =vale
            if ( this.delayParams.delayReason.length === 50) {
              promptAction.showToast({message:"已达到最大填写长度!"})
              return
            }
          })

        Text(`${this.delayParams.delayReason?.length || 0}/${this.maxLength}`)
          .width('100%')
          .margin({top:-30})
          .textAlign(TextAlign.End)
          .padding({right:15})
          .fontColor($r("app.color.text_secondary"))
        Row(){
            Button('提交')
              .width(200)
              .height(50)
              .enabled(this.getBtnStatus())
              .backgroundColor(this.getBtnStatus()?$r("app.color.primary"):$r("app.color.primary_disabled"))
              .onClick(()=>{
                this.delay()
              })
        }
        .padding({ top:40,bottom:20 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
  getBtnStatus(){
    if (this.delayParams.delayReason && this.delayParams.delayTime && this.delayParams.id) {
      return true
    }
    return false
  }
  async  delay(){
    try {
      this.layer.open()
      await delay(this.delayParams)
      promptAction.showToast({message:"延迟提货成功",duration:3000})
      router.back()
    } catch (err) {
      promptAction.showToast({message:"延迟提货失败",duration:3000})
    } finally {
      this.layer.close()
    }
  }
}