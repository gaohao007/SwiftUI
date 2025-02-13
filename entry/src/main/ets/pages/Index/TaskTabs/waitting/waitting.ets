import { Log } from "@abner/log"
import { getTaskList } from "../../../../api/task"
import { Loading } from "../../../../components"
import {
  TaskList,
  TaskListParams,
  TaskListParamsModel ,
  TaskTypeEunm} from "../../../../model"
import { TaskItemCard } from "./waittingcardItem"
import { promptAction } from "@kit.ArkUI"

// 待提货
@Component
export  struct Waitting{
  @State
        refreshStatus:RefreshStatus= RefreshStatus.Inactive

  @State
queryParams:TaskListParams = new  TaskListParamsModel({
  page:1,
  pageSize:5,
  status:TaskTypeEunm.Watting
} as TaskListParams)
  @State
    taskListData:TaskList[] = []

  @State isLoading:boolean =false
  // 总页数
  @State totalPage:number =1
  async  getTaskList(append:boolean){
     const  res =  await getTaskList(this.queryParams)
    this.totalPage = res.pages
    Log.info(JSON.stringify(res))
    if (append) {
      this.taskListData =this.taskListData.concat(res.items)
    }else {
      this.taskListData =  res.items
    }
    this.queryParams.page++
    Log.info(JSON.stringify(this.taskListData))
  }


  //数据加载提示
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.isLoading) {
        Text(this.totalPage < this.queryParams.page ? "已经到底啦！" : "数据加载中！")
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if (this.totalPage >= this.queryParams.page) {
          Loading({ hwidth:20 })
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  @State isRefresh:boolean = true


  build() {
    Refresh({refreshing:$$this.isRefresh,builder:this.getRefreshDisplay()}){
      List(){
        ForEach(this.taskListData,(item:TaskList)=>{
          ListItem(){
            TaskItemCard({taskItemData:item})
          }

        })
        ListItem(){
          this.getBottomDisplay()
        }
      }.width('100%').height('100%')
      .onReachEnd(async ()=>{
        if (this.totalPage>=this.queryParams.page) {
          if (!this.isLoading) {
            this.isLoading = true
            await this.getTaskList(true)
            this.isLoading = this.totalPage < this.queryParams.page ? true : false
          }
        }
      })
    }
    .onStateChange(async (value:RefreshStatus)=>{
      this.refreshStatus = value
      if (value === RefreshStatus.Refresh) {
        await this.onRefresh()
      }
    })

  }
  async  onRefresh(){
    this.queryParams.page=1;
    this.totalPage=1;
    await this.getTaskList(false)
    this.isRefresh = false
    this.isLoading=false
    promptAction.showToast({message:"刷新成功!"})
  }

  getStatusInfo(){
    switch (this.refreshStatus){
      case RefreshStatus.Drag:
        return "继续下拉"
      case RefreshStatus.OverDrag:
        return "松手加载"
      case RefreshStatus.Refresh:
        return "刷新中"
      case RefreshStatus.Done:
        return "刷新完成"
      default :
         return ""
    }
  }
  @Builder
  getRefreshDisplay() {
    //自定义刷新的样式
    Row() {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r("app.color.primary"))

      Text(this.getStatusInfo())
        .fontSize(14)
        .fontColor($r("app.color.primary"))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }


}
