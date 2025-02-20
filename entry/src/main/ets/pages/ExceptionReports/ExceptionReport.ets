import dayjs from '@hview/dayjs'
import { Card, CardItem, NavBar,SelectCard, PictureUpload, Loading, UploadFiles } from '../../components'
import { app_top_Height } from '../../constants'
import { CommonRouterParams, ExceptionParams,ExceptionParamsModel, ImageList } from '../../model'
import { Log } from '@abner/log'
import { router } from '@kit.ArkUI'
import { exceptionReport } from '../../api/task'


@Entry
@Component
struct ExceptionReport {
  maxLength: number = 50
  @State exceptionParams:ExceptionParams= new ExceptionParamsModel({} as ExceptionParams)
  aboutToAppear(): void {
  const params = router.getParams() as  CommonRouterParams
   if (params && params.id) {
     this.exceptionParams.transportTaskId =params.id
   }
  }



  typeController:CustomDialogController = new  CustomDialogController({
    builder:SelectCard({
      cardContent:()=>{
        this.getCardContent()
      },
      confirm:()=>{
        this.exceptionParams.exceptionType = this.exceptionErrorList[this.selectIndex]
      }
    }),
    customStyle:true,
    autoCancel:false,
    alignment:DialogAlignment.Bottom
  })


  //异常类型
  exceptionErrorList:string[]=[
    "发动机启动困难",
    "不着车、漏油",
    "照明失灵",
    "有异常响动",
    "排烟异常、温度异常",
    "其他问题"
  ]


  @State selectIndex:number=-1

  @Builder
  getCardContent(){
    ForEach(this.exceptionErrorList,(item:string,index:number)=>{
          this.getSingleItem({name:item,index:index} as ExceptionItemClass)
    })
  }

  @Builder
 getSingleItem(item:ExceptionItemClass){
    Row(){
        Text(item.name).fontSize(14).fontWeight(500).fontColor($r("app.color.text_primary"))
      Image(this.selectIndex === item.index?$r("app.media.ic_check_true"):$r("app.media.ic_check_false"))
        .width(32)
        .aspectRatio(1)
        .onClick(()=>{
          this.selectIndex = item.index
        })
    }.width('100%')
   .height(50)
   .justifyContent(FlexAlign.SpaceBetween)
   .border({width:{bottom:1},color:$r("app.color.background_divider")})
 }



onPageShow(): void {
      const params  = router.getParams() as CommonRouterParams
  if (params && params.id) {
    this.exceptionParams.transportTaskId = params.id
  }
  if (params && params.address) {
    this.exceptionParams.exceptionPlace = params.address
  }
  }







  build() {
    Column() {
      Row()
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(AppStorage.get(app_top_Height))
      NavBar({ title: "上报异常" })
      Scroll() {
        Column() {
          Card() {
            CardItem({
              leftTitle: "异常时间", rightValue:this.exceptionParams.exceptionTime || "请选择", onRightClick: () => {
                //弹出时间框，选择时间
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  alignment: DialogAlignment.Bottom,
                  onDateAccept: (value: Date) => {
                    this.exceptionParams.exceptionTime = dayjs(value).format('YYYY-MM-DD HH:mm')
                  }
                })
              }
            })
            CardItem({
              leftTitle: "上报位置", rightValue: this.exceptionParams.exceptionPlace ||"请选择",
              onRightClick:()=>{
                router.pushUrl({url:"pages/selectLocation/SelectLocation"})
              }
            })
            CardItem({
              leftTitle: "异常类型", rightValue: this.exceptionParams.exceptionType||"请选择",
              onRightClick:()=>{
                this.typeController.open()
              }
            })
            CardItem({
              leftTitle: "异常描述",
              rightValue: "",
              showBottomBorder: false,
             showRightArrow:false
            })

            TextArea({ placeholder: "请输入异常描述",text:this.exceptionParams.exceptionDescribe || "" })
              .backgroundColor($r("app.color.background_page"))
              .height(130)
              .fontSize(14)
              .margin({ top: 10 })
              .placeholderColor($r("app.color.text_secondary"))
              .borderRadius(8)
              .maxLength(this.maxLength)
              .onChange(value => {
                  this.exceptionParams.exceptionDescribe= value
              })

            Text(`${this.exceptionParams.exceptionDescribe?.length || 0}/${this.maxLength}`).width('100%')
              .margin({ top: -30 })
              .textAlign(TextAlign.End)
              .padding({ right: 15 })
              .fontColor($r("app.color.text_secondary"))
            Row().height(30)
          }

          Card() {
            PictureUpload({
              title: "上传图片（最多6张）",
              maxNumber: 6,
              ImageList:this.exceptionParams.exceptionImagesList||[],
              onListChange: (imglist:ImageList[]) => {
                  this.exceptionParams.exceptionImagesList = imglist
              }
            })
            Row().height(10)
          }
        }
      }

      Row() {
        Button("提交")
          .width(200)
          .height(50)
          .enabled(this.getBtnStatus())
          .backgroundColor(this.getBtnStatus()?$r("app.color.primary"):$r("app.color.primary_disabled"))
          .onClick(()=>{
            Log.info(JSON.stringify(this.exceptionParams))
            this.exceptionReport()
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(80)
      .position({ y: "100%" })
      .translate({ y: -80 })
    }.height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }

  layer:CustomDialogController=new CustomDialogController({
    builder:Loading({loadingText:"数据正在处理中,请耐心等待!"}),
    customStyle:true,
    alignment:DialogAlignment.Center,
    autoCancel:false
  })

  async exceptionReport(){
    try {
      this.layer.open()
      if (this.exceptionParams.exceptionImagesList?.length) {
        this.exceptionParams.exceptionImagesList = await
        UploadFiles(this.exceptionParams.exceptionImagesList)
      }
      await exceptionReport(this.exceptionParams)
      AlertDialog.show({message:"上报异常成功!"})
      router.pushUrl({
        url:"pages/TaskDetail/TaskDetail",
        params:{
          isExceptionReport:true
        }
      })
    } catch (err) {
      AlertDialog.show({message:"上报异常失败!"})
    } finally {
      this.layer.close()
    }
  }
  getBtnStatus(){
    if (
      this.exceptionParams.transportTaskId &&  this.exceptionParams.exceptionType &&
    this.exceptionParams.exceptionTime && this.exceptionParams.exceptionPlace &&
      this.exceptionParams.exceptionImagesList?.length||[].length>0 && this.exceptionParams.exceptionDescribe
    ) {
      return true
    }
     return false
  }

}

class  ExceptionItemClass{
  name:string=''
  index:number=-1
}