import { it } from "@ohos/hypium";
import { TabClass } from "../../../model";

@Component
export struct TaskTabs {

  @Builder
  getTabBar(item:TabClass){
    Column(){
      Text(item.title)
        .fontColor(item.name===this.tasksData[this.currentIndex].name?$r("app.color.primary") :$r("app.color.text_secondary"))
      Divider()
        .strokeWidth(4)
        .color(item.name===this.tasksData[this.currentIndex].name?$r("app.color.primary") :$r("app.color.text_secondary"))
        .lineCap(LineCapStyle.Round)
        .animation({duration:300})
        .width(item.name===this.tasksData[this.currentIndex].name?25:0)
    }
  }



  @State currentIndex:number=0
  @State tasksData:TabClass[]=[
    {
      title:"待提货",
      name:"waitting",
    },
    {
      title:"在途",
      name:"line",
    },
    {
      title:"已完成",
      name:"finish",
    }
  ]
  build() {
    Tabs({barPosition:BarPosition.Start,index:$$this.currentIndex}){
        ForEach(this.tasksData,(item:TabClass,index:number)=>{
            TabContent(){
                  Text(item.title)
            }.tabBar(this.getTabBar(item))
        })
    }
    .onChange((value:number)=>{
      this.currentIndex = value
    })
    .backgroundColor($r("app.color.background_page"))
    .animationDuration(300)

  }
}