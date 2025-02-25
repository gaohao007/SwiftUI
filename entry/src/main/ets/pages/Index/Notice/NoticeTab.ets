
import { app_top_Height } from "../../../constants"
import { TabClass } from "../../../model"
import { Notice } from "./Notice"
import { NoticeList } from "./NoticeList"

@Component
export struct NoticeTab {


  //已读
  @Builder
  getReaded(){
    Row(){
      Row(){
        Image($r("app.media.ic_yidu"))
          .width(35)
          .aspectRatio(1)
          .padding({left:10,right:6})
        Text('全部已读')
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
          .fontWeight(500)
      }    .width('100%')
      .backgroundColor($r("app.color.background_page"))
    }
    .width('100%')
    .backgroundColor($r("app.color.white"))
    .padding({left:20,right:20,top:5,bottom:20})
  }




  // tab的索引
@State currentIndex:number=0

  @Builder
  getTabBar(item:TabClass){
    Column({space:5}){
      Text(item.title)
        .fontColor(item.name===this.tasksData[this.currentIndex].name?$r("app.color.primary") :$r("app.color.text_secondary"))
      Divider()
        .strokeWidth(4)
        .color(item.name===this.tasksData[this.currentIndex].name?$r("app.color.primary") :$r("app.color.text_secondary"))
        .lineCap(LineCapStyle.Round)
        .animation({duration:300})
        .width(item.name===this.tasksData[this.currentIndex].name?40:0)
    }.onClick(()=>{
      const index = this.tasksData.findIndex(obj=>obj.name===item.name)
      this.currentIndex = index
    })
  }

//tab的数组
  @State tasksData:TabClass[]=[
    {
      title:"公告",
      name:"notice",
    },
    {
      title:"任务通知",
      name:"task_notice",
    }

  ]

  build() {
    Column(){
      Row().width('100%')
        .height(AppStorage.get(app_top_Height))
        .backgroundColor($r("app.color.white"))

      Text('消息').width('100%')
        .fontSize(26)
        .fontWeight(800)
        .textAlign(TextAlign.Center)
        .backgroundColor($r("app.color.white"))
        .padding(20)

      Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex } ){
        ForEach(this.tasksData, (item: TabClass) => {
          TabContent() {
            if (item.name ==  'notice') {
                    Notice()
            } else if (item.name === 'task_notice') {
              NoticeList()

            }
          }.tabBar(this.getTabBar(item))
        })
      }

    }.width('100%')
    .height('100%')
    .backgroundColor($r("app.color.white"))

  }
}