import { app_bottom_height, app_top_Height, TOKEN_KEY } from '../../constants'
import { TabClass } from '../../model'
import { Mine } from './My/Mine'
import { NoticeTab } from './Notice/NoticeTab'
import { TaskTabs } from './TaskTabs/TaskTabs'

PersistentStorage.persistProp(TOKEN_KEY,"")

@Entry
@Component
struct Index {
  //默认选中
  @State
   currentName:string = 'Mine'
@State tabsData:TabClass[]=[
  {
    title:"任务",
    name:"Task",
    image:$r('app.media.ic_tab_btn_task')
  },
  {
    title:"消息",
    name:"Message",
    image:$r('app.media.ic_tab_btn_mess_nor')
  },
  {
    title:"我的",
    name:"Mine",
    image:$r('app.media.ic_tab_btn_mine_nor')
  }
]


  @Builder
    getTabBar(item:TabClass){
   Column(){
     Image(item.image).width(22).aspectRatio(1)
       .fillColor(item.name ===this.currentName?$r("app.color.primary"):$r("app.color.text_secondary") )
     Text(item.title).fontSize(12).fontWeight(400).margin({top:5})
       .fontColor(item.name ===this.currentName?$r("app.color.primary"):$r("app.color.text_secondary") )
   }.alignItems(HorizontalAlign.Center)
}

  build() {
    Column(){
      Row().width('100%')
        .height(AppStorage.get(app_top_Height))
        .backgroundColor($r("app.color.white"))
      Tabs({barPosition:BarPosition.End,index:2}){
        ForEach(this.tabsData,(item:TabClass)=>{
          TabContent(){
            if (item.name === 'Task') {
              TaskTabs()
            }else  if (item.name === 'Message'){
              NoticeTab()
            }else {
              Mine()
            }
          }.tabBar(this.getTabBar(item))
        })
      }
      .onChange((index:number)=>{
        this.currentName = this.tabsData[index].name!
      })
      .animationDuration(300)
      .padding({
        top:AppStorage.get<number>(app_top_Height),
        bottom:AppStorage.get<number>(app_bottom_height)
      })
    }

  }
}