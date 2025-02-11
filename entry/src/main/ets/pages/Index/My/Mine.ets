
import { getUserInfo, getUserTaskInfo } from "../../../api"
import { Card, CardItem } from "../../../components"
import {  UserTaskInfo, UserTaskInfoModel, UserInfo, UserInfoModel,
UserTaskInfoParamsModel} from "../../../model"
import { router } from "@kit.ArkUI"
import { Log } from "@abner/log"


@Component
export  struct Mine{
  @State taskInfo:UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)
  queryTaskParams:UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(),
    month: (new Date().getMonth() + 1).toString()
  })
  @State userInfo:UserInfoModel= new UserInfoModel({} as UserInfo)
   async aboutToAppear() {
      await this.getUserInfo()
      await this.getTaskInfo()
     Log.info(JSON.stringify(this.taskInfo))
  }
  async getUserInfo(){
    this.userInfo = await getUserInfo()
  }

  async getTaskInfo(){
        this.taskInfo  =  await getUserTaskInfo(this.queryTaskParams)
  }





  build() {
    Column(){
    //   基本信息
      Column(){
      Image(this.userInfo.avatar)
        .height(70).width(70).borderRadius(35)
        .backgroundColor($r("app.color.white"))
        Text('司机')
          .fontSize(18).fontWeight(700)
          .fontColor($r("app.color.white"))
          .margin({top:10,bottom:10})
        Text('司机编号:'+this.userInfo.number)
          .fontSize(14).fontWeight(400)
          .fontColor($r("app.color.white"))
          .margin({top:10})
        Text('手机号:'+this.userInfo.phone)
          .fontSize(14).fontWeight(400)
          .fontColor($r("app.color.white"))
          .margin({top:10})

      }
      .backgroundImage($r("app.media.bg_page_my"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height(290)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .margin({top:-2})
    //   本月任务
      Column(){
          Text("-  本月任务  -")
            .fontSize(14)
            .fontColor($r("app.color.text_secondary")).lineHeight(25)
        Row(){
            Column(){
                  Text(this.taskInfo.taskAmounts?.toString()||" ")
                    .fontSize(18)
                    .fontColor($r("app.color.text_primary"))
                    .lineHeight(25)
                    .margin({
                      bottom:17
                    })
              Text('任务总量').fontSize(12)
                .fontColor($r("app.color.text_primary")).lineHeight(17)
            }
            .layoutWeight(1)

          Column(){
            Text(this.taskInfo.completeAmount?.toString() || " ")
              .fontSize(18)
              .fontColor($r("app.color.text_primary"))
              .lineHeight(25)
              .margin({
                bottom:17
              })
            Text('完成任务量').fontSize(12)
              .fontColor($r("app.color.text_primary")).lineHeight(17)
          }
          .layoutWeight(1)


          Column(){
            Text(this.taskInfo.transportMileage?.toString()||" ")
              .fontSize(18)
              .fontColor($r("app.color.text_primary"))
              .lineHeight(25)
              .margin({
                bottom:17
              })
            Text('总公里数(KM)').fontSize(12)
              .fontColor($r("app.color.text_primary")).lineHeight(17)
          }
          .layoutWeight(1)

        }.width('100%')
        .layoutWeight(1)

      }
      .height(135)
      .backgroundColor($r("app.color.white"))
      .borderRadius(8)
      .padding({top:14,bottom:14})
      .margin({
        left:14,
        right:14,
        top:-55,
        bottom:14
      })

   Card(){
        CardItem({
          leftTitle:"车辆信息"
        })
     CardItem({
       leftTitle:"任务数据"
     })
     CardItem({
       leftTitle:"系统设置",
       showBottomBorder:false,
       onRightClick:()=>{
         router.pushUrl({url:"pages/Setting/Seting"})
       }
     })
   }

    //   综合信息
    //   Column(){
    //       Row(){
    //         Text('车辆信息').fontWeight(400).fontColor($r("app.color.text_primary"))
    //          Image($r("app.media.ic_btn_more"))
    //           .height(40)
    //           .width(40)
    //       }.width('100%')
    //     .height(60)
    //     .justifyContent(FlexAlign.SpaceBetween)
    //     .border({
    //       width:{bottom:1},
    //       color:$r("app.color.background_divider")
    //     })
    //
    //     Row(){
    //       Text('任务数据').fontWeight(400).fontColor($r("app.color.text_primary"))
    //       Image($r("app.media.ic_btn_more"))
    //         .height(40)
    //         .width(40)
    //
    //     }.width('100%')
    //     .height(60)
    //     .justifyContent(FlexAlign.SpaceBetween)
    //     .border({
    //       width:{bottom:1},
    //       color:$r("app.color.background_divider")
    //     })
    //
    //     Row(){
    //       Text('系统设置').fontWeight(400).fontColor($r("app.color.text_primary"))
    //       Image($r("app.media.ic_btn_more"))
    //         .height(40)
    //         .width(40)
    //         .borderRadius(20)
    //
    //     }.width('100%')
    //     .height(60)
    //     .justifyContent(FlexAlign.SpaceBetween)
    //     .border({
    //       width:{bottom:1},
    //       color:$r("app.color.background_divider")
    //     })
    //
    //   }.backgroundColor($r("app.color.white"))
    //   .borderRadius(8)
    //   .margin({left:14,right:14})
    //   .padding({
    //     top:13,
    //     bottom:13,
    //     right:14,
    //     left:14
    //   })

    }.width('100%')
    .height('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}