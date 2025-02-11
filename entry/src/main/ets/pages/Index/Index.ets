import { it } from '@ohos/hypium'
import { TabClass } from '../../model'

@Entry
@Component
struct Index {
  //默认选中
  @State
   currentName:string = 'Task'


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
    Tabs({barPosition:BarPosition.End}){
      ForEach(this.tabsData,(item:TabClass)=>{
        TabContent(){
          if (item.name === 'Task') {
            Text('任务组件')
          }else  if (item.name === 'Message'){
            Text('消息组件')
          }else {
            Text('我的组件')
          }
        }.tabBar(this.getTabBar(item))
      })
    }.onChange((index:number)=>{
      this.currentName = this.tabsData[index].name
    })
    .animationDuration(300)

    .height('100%')
    .width('100%')
  }
}