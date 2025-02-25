import { NoticeListItem, NoticeListItemModel } from "../../../model/notice"
import { router } from "@kit.ArkUI";
import { MarkedReaded } from "../../../api/notice";


@Component
export struct NoticeCard {

  @Prop
     noticeItem:NoticeListItem= new  NoticeListItemModel({} as NoticeListItem)
//获取首行文本
  @Builder
  getNoticeCardContent(){
    Row(){
      Text('您有新的运输任务')
        .fontSize(20)
        .fontWeight(600)
      if (this.noticeItem.isRead ===0 ){
        Text('·')
          .fontSize(50)
          .fontWeight(700)
          .margin({left:15})
          .fontColor("#ff3331")
      }
    }.width('100%').padding({left:20})
    .margin({bottom:20})
  }


  build() {
    Column(){
      this.getNoticeCardContent()
      Text(this.noticeItem.content)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
        .margin({top:20,bottom:20})
        .offset({x:-20})
      Row(){
        Text(this.noticeItem.created)
          .fontSize(12)
          .fontColor($r("app.color.text_secondary"))
        Button('查看详情').width(75)
          .height(30)
          .border({width:1,color:$r("app.color.primary")})
          .backgroundColor($r("app.color.white"))
          .fontColor($r("app.color.primary"))
          .onClick(async  ()=>{
              await MarkedReaded(this.noticeItem.id)
            router.pushUrl({url:'pages/NoticeDetail/NoticeDetail',
            params:{
              id:this.noticeItem.id,
              createdTime:this.noticeItem.created,
              noticeContent:this.noticeItem.content
            }
            })
          })
      }.margin({top:30})
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:20,right:20})
    }.backgroundColor($r("app.color.white"))
  }
}
