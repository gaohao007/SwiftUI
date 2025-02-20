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
import dayjs from "@hview/dayjs"

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
      this.taskListData =this.taskListData.concat(res.items || [])
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

Column(){
  if (this.queryParams.status === TaskTypeEunm.Finish){
   this. getSearchForm()
  }

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
}.height('100%')



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
//搜索框
@Builder
  getSearchForm(){
    Column(){
      Row(){
        Search({placeholder:"请输入任务编号"})
          .backgroundColor($r("app.color.background_page"))
          .height(32)
          .placeholderFont({size:12})
          .onSubmit(async (value:string)=>{

            if (value) {
              if (isNaN(parseInt(value))){
                promptAction.showToast({message:'非数字,请重新输入!'})
                return
              }
              try {
                this.layer.open()
                this.queryParams.transportTaskId = value
                this.queryParams.startTime=""
                this.queryParams.endTime =''
                this.reset =false
                this.totalPage=0;
                this.queryParams.page=1
                const  res = await getTaskList(this.queryParams)
                this.taskListData = res.items ||[]
              } catch (err) {
                promptAction.showToast({message:JSON.stringify(err)})
              } finally {
                this.layer.close()
              }
            }else{
              this.getTaskList(true)
            }
          })
      }.width('100%')
      .padding({left:8,right:8,bottom:5})


      Row(){
        Button(this.queryParams.startTime||'开始时间')
          .fontSize(12)
          .width(110)
          .height(32)
          .fontColor($r("app.color.text_secondary"))
          .backgroundColor($r("app.color.background_page"))
          .onClick(()=>{
            DatePickerDialog.show({
              selected:new Date(),
              alignment:DialogAlignment.Bottom,
              onDateAccept:(value:Date)=>{
                this.queryParams.startTime = dayjs(value).format('YYYY-MM-DD')
              }
            })
          })
        Text('至')
        Button(this.queryParams.endTime||'结束时间')
          .fontSize(12)
          .width(110)
          .height(32)
          .fontColor($r("app.color.text_secondary"))
          .backgroundColor($r("app.color.background_page"))
          .onClick(()=>{
            DatePickerDialog.show({
              selected:new Date(),
              alignment:DialogAlignment.Bottom,
              onDateAccept:(value:Date)=>{
                this.queryParams.endTime = dayjs(value).format('YYYY-MM-DD')
              }
            })
          })
        Button(this.reset?"重置":'筛选')
          .width(60)
          .height(32)
          .enabled(this.getSearchBtn())
          .backgroundColor(this.getSearchBtn()?$r("app.color.primary"):$r("app.color.primary_disabled"))
          .onClick(()=>{
            this.btnSearch()

          })
      }.width('100%')
     .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .backgroundColor($r("app.color.white"))
    .padding(15)


  }
  layer:CustomDialogController=new CustomDialogController({
    builder:Loading({loadingText:"数据正在处理中,请耐心等待!"}),
    customStyle:true,
    alignment:DialogAlignment.Center,
    autoCancel:false
  })
 async  btnSearch(){
   try {
     this.layer.open()
     if (this.reset) {
       //重置
       this.queryParams.transportTaskId=""
       this.queryParams.startTime=""
       this.queryParams.endTime=""
      this.reset = false
     }else {
      //筛选
       this.reset = true
     }
     this.queryParams.page=1;
     this.totalPage =1;
     await this.getTaskList(false)


   } catch (err) {
     AlertDialog.show({message:JSON.stringify(err)})
   } finally {
     this.layer.close()
   }
  }
getSearchBtn(){
  if ((this.queryParams.endTime && this.queryParams.startTime )) {
    return true
  }
  return false
}
//筛选
@State reset:boolean =false
}
