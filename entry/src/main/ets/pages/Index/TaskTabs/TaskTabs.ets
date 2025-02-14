
import { TabClass, TaskListParams, TaskListParamsModel, TaskTypeEunm } from "../../../model";
import { Waitting } from "./waitting/waitting";

@Component
export struct TaskTabs {

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
   Stack({alignContent:Alignment.TopStart}) {
     Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex }) {
       ForEach(this.tasksData, (item: TabClass, index: number) => {
         TabContent() {
           if (item.name ==  'waitting') {
             Waitting()
           } else if (item.name === 'line') {
              Waitting({queryParams: new TaskListParamsModel({
                status:TaskTypeEunm.Line,
                page:1,
                pageSize:5
              } as TaskListParams) })
           } else {
           }
         }
       })
     }
     .backgroundColor($r("app.color.background_page"))
     .animationDuration(300)

       Row({space:20}){
         ForEach(this.tasksData,(item:TabClass,index:number)=>{
           this.getTabBar(item)
         })
       }.width('100%')
       .height(50)
       .padding({left:40,right:40})
        .backgroundColor($r("app.color.background_page"))
     }

  }
}