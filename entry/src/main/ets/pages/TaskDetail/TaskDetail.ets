
import { promptAction, router } from '@kit.ArkUI'

import { deliver, getTaskDetailInfo, pickUp } from '../../api/task'
import { Loading, NavBar, PictureUpload, ToggleCard, UploadFiles } from '../../components'
import { CommonRouterParams,
  DeliverParamsModel,
  ImageList, PickUpParamsModel, TaskDetailInfo, TaskDetailInfoModel,
  TaskTypeEunm } from '../../model'
import { call } from '@kit.TelephonyKit'
import { Log } from '@abner/log'
import { Skeleton } from '../../components/Skeleton'
import { app_bottom_height, app_top_Height } from '../../constants'

@Entry
@Component
struct TaskDetail {

  scroller:Scroller = new Scroller()

  @State
    taskDetailDateInfo:TaskDetailInfo = new TaskDetailInfoModel({} as TaskDetailInfo)
  layer:CustomDialogController=new CustomDialogController({
    builder:Loading({loadingText:"数据正在处理中,请耐心等待!"}),
    customStyle:true,
    alignment:DialogAlignment.Center,
    autoCancel:false
  })


  async aboutToAppear() {
  const params =router.getParams() as CommonRouterParams
    if (params &&  params.id) {
     await this.getTaskDetailData(params.id)
    }
  }
  async getTaskDetailData(id:string){
    const res = await getTaskDetailInfo(id)
    this.taskDetailDateInfo = res
    Log.info(JSON.stringify(res))
  }
  // 显示基本信息
  @Builder
  getBaseDateInfo(){
    Row(){
      Column(){
        Row(){
            Text('起')
              .fontSize(12)
              .height(22)
              .width(22)
              .borderRadius(11)
              .fontColor($r("app.color.white"))
              .backgroundColor($r("app.color.text_primary"))
              .textAlign(TextAlign.Center)
            Text(this.taskDetailDateInfo.startAddress)
              .fontSize(14)
              .fontColor($r("app.color.text_secondary"))
              .margin({left:12})
        }.margin({top:18})
        Row(){
          Text('止')
            .fontSize(12)
            .height(22)
            .width(22)
            .borderRadius(11)
            .fontColor($r("app.color.white"))
            .backgroundColor($r("app.color.primary"))
            .textAlign(TextAlign.Center)
          Text(this.taskDetailDateInfo.endAddress)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
            .margin({left:12})
        }.margin({top:14})
      }.alignItems(HorizontalAlign.Start)
      Column(){
        Image($r("app.media.ic_navigation"))
          .width(22).aspectRatio(1)
        Text('开始导航')
          .fontSize(14)
          .margin({top:10,bottom:10})
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({top:22})
    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    Divider()
      .width(2)
      .color($r("app.color.background_divider"))
      .margin({top:20,left:8,right:8})
    this.getBaseContentItem({title:"任务编号",value:this.taskDetailDateInfo.transportTaskId})
    this.getBaseContentItem({title:"联系人",value:this.taskDetailDateInfo.startHandoverName})
    this.getBaseContentItem({
      title:"联系电话",value:this.taskDetailDateInfo.startHandoverPhone,icon:$r("app.media.ic_phone"),
      action:async ()=>{
       await call.makeCall(this.taskDetailDateInfo.startHandoverPhone)
      }
    })
    this.getBaseContentItem({title:"提货时间",value:this.taskDetailDateInfo.planDepartureTime})
    this.getBaseContentItem({title:"预计送达时间",value:this.taskDetailDateInfo.planArrivalTime})
  }
  @Builder
  getBaseContentItem(item:BaseContentItemBuilderClass){
    Row(){
      Text(item.title)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
        .lineHeight(20)
      Row(){
        Text(item.value)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if (item.icon){
          Image(item.icon)
            .width(24).aspectRatio(1)
            .onClick(()=>{
              if (item.action) {
                item.action()
              }
            })
        }
      }
    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({top:14})
  }

  //司机信息
  @Builder
  getDriverInfo(){
    this.getBaseContentItem({title:"车牌号",value:this.taskDetailDateInfo.licensePlate})
    this.getBaseContentItem({title:"司机姓名",value:this.taskDetailDateInfo.driverName})
  }

//运输路径:
@Builder
getTransportLinesInfo(){
    Row(){
      Column(){
        Text(this.taskDetailDateInfo.startProvince)
          .fontWeight(700)
          .fontColor($r("app.color.text_primary"))
          .lineHeight(22)
        Text(this.taskDetailDateInfo.startCity)
          .fontSize(14)
          .fontColor($r("app.color.text_primary"))
          .lineHeight(22)

      }.height(50)
      Image($r("app.media.ic_right_arrow"))
        .height(36).aspectRatio(1)

      Column(){
        Text(this.taskDetailDateInfo.endProvince)
          .fontWeight(700)
          .fontColor($r("app.color.text_primary"))
          .lineHeight(22)
        Text(this.taskDetailDateInfo.endCity)
          .fontSize(14)
          .fontColor($r("app.color.text_primary"))
          .lineHeight(22)

      }.height(50)

    }.width('100%')
  .padding({left:60,right:60})
  .justifyContent(FlexAlign.SpaceBetween)
}


@Builder
getPickUpContent(){
    PictureUpload({title:"请拍照上传回单凭证"
    ,ImageList:this.taskDetailDateInfo.cargoPickUpPictureList || []
    ,onListChange:(data:ImageList[])=>{
      this.taskDetailDateInfo.cargoPickUpPictureList =data
      },
      isOrNoUpLoad:this.taskDetailDateInfo.status === TaskTypeEunm.Watting
    })
    PictureUpload({title:"请拍照上传货品照片",
      ImageList:this.taskDetailDateInfo.cargoPictureList || []
    ,onListChange:(data:ImageList[])=>{
        this.taskDetailDateInfo.cargoPictureList=data
      },
      isOrNoUpLoad:this.taskDetailDateInfo.status === TaskTypeEunm.Watting
    })
}



  @Builder
  getDriverContent(){
    PictureUpload({title:"请拍照上传交货凭证"
    ,ImageList:this.taskDetailDateInfo.certificatePictureList || []
    ,onListChange:(data:ImageList[])=>{
        this.taskDetailDateInfo.certificatePictureList =data
      },
      isOrNoUpLoad:this.taskDetailDateInfo.status === TaskTypeEunm.Line
    })
    PictureUpload({title:"请拍照上传交货照片",
      ImageList:this.taskDetailDateInfo.deliverPictureList || []
    ,onListChange:(data:ImageList[])=>{
        this.taskDetailDateInfo.deliverPictureList=data
      },
      isOrNoUpLoad:this.taskDetailDateInfo.status === TaskTypeEunm.Line
    })
  }




@Builder
getBottomBtn(){
    Row(){
  if (this.taskDetailDateInfo.status  === TaskTypeEunm.Watting){
    Button('延迟提货')
      .backgroundColor($r("app.color.btn_gray"))
      .fontColor($r("app.color.text_primary"))
      .height(50)
      .width(125)
      .onClick(()=>{
        router.pushUrl({
          url:"pages/delayPickUp/DelayPickUp",
          params:{
            id:this.taskDetailDateInfo.id,
            planTime:this.taskDetailDateInfo.planDepartureTime
          }
        })
      })

    Button('提货')
      .backgroundColor(this.getPickUpStatus()?$r("app.color.primary"):$r("app.color.primary_disabled"))
      .fontColor($r('app.color.white'))
      .height(50)
      .layoutWeight(1)
      .margin({left:12})
      .enabled(this.getPickUpStatus())
      .onClick(()=>{
        //提货
        this.btnPickUp()
      })
  }else if (this.taskDetailDateInfo.status  === TaskTypeEunm.Line){
    Button('上报异常')
      .backgroundColor($r("app.color.btn_gray"))
      .fontColor($r("app.color.text_primary"))
      .height(50)
      .width(125)

    Button('交货')
      .backgroundColor(this.getDeliverStatus()?$r("app.color.primary"):$r("app.color.primary_disabled"))
      .fontColor($r('app.color.white'))
      .height(50)
      .layoutWeight(1)
      .margin({left:12})
      .enabled(this.getDeliverStatus())
      .onClick(()=>{
        this.btnDeliver()
      })
  }else if (this.taskDetailDateInfo.status  === TaskTypeEunm.Delivered){
    Row(){
      Button('回车登记')
        .backgroundColor($r("app.color.primary"))
        .fontColor($r("app.color.white"))
        .height(50)
        .width('80%')
        .onClick(()=>{
              router.pushUrl({
                url:"pages/CarRecord/CardRecord",
                params:{
                  id:this.taskDetailDateInfo.id
                }
              })
        })
    }.width('100%')
    .justifyContent(FlexAlign.Center)
  }

    }
    .justifyContent(FlexAlign.SpaceBetween)
  .width('100%')
  .height(80)
  .padding({left:15,right:15})
  .backgroundColor($r("app.color.white"))
  .position({y :"100%"})
  .translate({y:-80})
}

//提货
 async  btnPickUp(){
   // 图片上传
   try {
     this.layer.open()
     const result =  await Promise.all([
       await UploadFiles(this.taskDetailDateInfo.cargoPickUpPictureList),
       await UploadFiles(this.taskDetailDateInfo.cargoPictureList)]
     )
     Log.info(JSON.stringify(result))
     await  pickUp( new PickUpParamsModel({
       id:this.taskDetailDateInfo.id,
       cargoPickUpPictureList:result[0],
       cargoPictureList:result[1]
     }))
     this.getTaskDetailData(this.taskDetailDateInfo.id)
    this.scroller.scrollEdge(Edge.Top)
     promptAction.showToast({message:"提货成功!!",duration:3000})
   } catch (err) {
     AlertDialog.show({message:"提货失败"+JSON.stringify(err)})
   } finally {
     this.layer.close()
   }
  }
//交货
  async  btnDeliver(){
    // 图片上传
    try {
      this.layer.open()
      const result =  await Promise.all([
        await UploadFiles(this.taskDetailDateInfo.certificatePictureList),
        await UploadFiles(this.taskDetailDateInfo.deliverPictureList)]
      )
      Log.info(JSON.stringify(result))
      await  deliver(new DeliverParamsModel({
          id:this.taskDetailDateInfo.id,
          certificatePictureList:result[0],
         deliverPictureList:result[1]
      } ))
      this.getTaskDetailData(this.taskDetailDateInfo.id)
      this.scroller.scrollEdge(Edge.Top)
      promptAction.showToast({message:"交货成功!!",duration:3000})
    } catch (err) {
      AlertDialog.show({message:"交货失败"+JSON.stringify(err)})
    } finally {
      this.layer.close()
    }
  }


  build() {
    Column(){
      Row()
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(AppStorage.get<number>(app_top_Height))
        NavBar({title:"订单详情"})
         if (this.taskDetailDateInfo.id){
           Scroll(this.scroller){
             Column(){
               ToggleCard({ title:"基本信息", isShowToggleImage:false }){
                 this.getBaseDateInfo()
               }

               ToggleCard({title:"车辆司机信息",isShowToggleImage:false}){
                 this.getDriverInfo()
               }

               ToggleCard({title:"运输路径",isShowToggleImage:false}){
                 this.getTransportLinesInfo()
               }

               if (this.taskDetailDateInfo.status === TaskTypeEunm.Watting
               || this.taskDetailDateInfo.status === TaskTypeEunm.Delivered) {
                 ToggleCard({title:"提货信息",isShowToggleImage:false}){
                   this.getPickUpContent()
                 }
               }

               if (this.taskDetailDateInfo.status === TaskTypeEunm.Line
               ||  this.taskDetailDateInfo.status === TaskTypeEunm.Delivered) {
                 ToggleCard({title:"交货信息",isShowToggleImage:false}){
                   this.getDriverContent()
                 }
               }


             }
             .padding({bottom:140})
           }
         }else {
           Skeleton()
         }
       this.getBottomBtn()

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
//提货按钮状态
  getPickUpStatus(){
    if (this.taskDetailDateInfo.cargoPickUpPictureList?.length > 0
    && this.taskDetailDateInfo.cargoPictureList?.length>0) {
      return true
    }
    return false
  }

  //交货按钮状态
  getDeliverStatus(){
    if (this.taskDetailDateInfo.certificatePictureList?.length > 0
      && this.taskDetailDateInfo.deliverPictureList?.length>0) {
      return true
    }
    return false
  }
}



class BaseContentItemBuilderClass{
  title:string=""
  value:string=""
  icon?:ResourceStr=""
  action?:()=>void=()=>{}
}















