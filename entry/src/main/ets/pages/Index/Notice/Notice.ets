import { Loading } from "../../../components"
import {  NoticeListItem, NoticeParams, NoticeParamsModel } from "../../../model/notice"
import { promptAction } from "@kit.ArkUI"
import { getNotice } from "../../../api/notice"
import { Log } from "@abner/log"

@Component
export struct Notice{
  //接收数据
  @State
  noticeList:NoticeListItem[]=[]

//请求接口
  async  getNotice(append:boolean){
    const  res =  await getNotice(this.queryParams)
    this.totalPageSize = res.pages
    Log.info(JSON.stringify(res))
    if (append) {
      this.noticeList =this.noticeList.concat(res.items || [])
    }else {
      this.noticeList =  res.items
    }
    this.queryParams.page++
    Log.info(JSON.stringify(this.noticeList))
  }



//请求参数
  @State
  queryParams:NoticeParams = new NoticeParamsModel({
    contentType:200,
    page:1,
    pageSize:10,
  })

//获取通知内容
  @Builder
  getNoticeContent(item:noticeItem){
    Row({space:5}){
      Text("·")
        .width(20)
        .height(20)
        .fontWeight(700)
        .borderRadius(10)
        .fontColor('#ff3331')
        Text(item.leftValue)
          .constraintSize({maxWidth:'50%'})
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
        Text(item.rightValue)
          .fontSize(12)
          .fontColor($r("app.color.text_secondary"))
    }.width('100%')
    .padding({left:15,right:15})
    .backgroundColor($r("app.color.white"))
  }

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
    }.backgroundColor($r("app.color.background_page"))
      .width(`100%`)
    }
    .width('100%')
    .height(50)
      .backgroundColor($r("app.color.white"))
       .padding({left:20,right:20})
  }

  @State isRefresh:boolean = true

  @State
  refreshStatus:RefreshStatus= RefreshStatus.Inactive

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
  getRefreshShow() {
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

  //是否显示加载中
  @State isLoading:boolean =false
//总页数
  @State totalPageSize:number=0

  //数据加载提示
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.isLoading) {
        Text(this.totalPageSize < this.queryParams.page ? "已经到底啦！" : "数据加载中！")
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if (this.totalPageSize >= this.queryParams.page) {
          Loading({ hwidth:20 })
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }



  build() {
    Column({}){
      this.getReaded()
      Refresh({refreshing:$$this.isRefresh,builder:this.getRefreshShow()}){
        List({space:20}){
          ForEach(this.noticeList,(item:NoticeListItem)=>{
            ListItem(){
              this.getNoticeContent({
                leftValue:item.content,
                rightValue:item.created
              })
            }.padding(10)
          })
          ListItem(){
            this.getBottomDisplay()
          }

        }.width('100%').height(250)
        .padding({ left:10,right:10,bottom:20 })
        .backgroundColor($r("app.color.white"))
        .onReachEnd(async ()=>{
          if (this.totalPageSize>=this.queryParams.page) {
            if (!this.isLoading) {
              this.isLoading = true
              await this.getNotice(true)
              this.isLoading = this.totalPageSize < this.queryParams.page ? true : false
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
    .backgroundColor($r("app.color.background_page"))
    .width('100%')
    }


  async  onRefresh(){
    this.queryParams.page=1;
    this.totalPageSize=1;
    await this.getNotice(false)
    this.isRefresh = false
    this.isLoading=false
    promptAction.showToast({message:"刷新成功!"})
  }

}
class noticeItem{
  rightValue:string=""
  leftValue:string=""
}