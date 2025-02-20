import { Card, CardItem, NavBar } from '../../components';
import { app_top_Height } from '../../constants';
import { router } from '@kit.ArkUI';
import { CommonRouterParams, ExceptionList, ExceptionListModel, ImageList } from '../../model';
import { Log } from '@abner/log';

@Entry
@Component
struct ExceptionDetail {

  @State exceptionData:ExceptionList = new ExceptionListModel({} as ExceptionList)
  aboutToAppear(): void {
   const params= router.getParams() as CommonRouterParams
    if (params && params.transmintExceptionDate) {
      this.exceptionData = params.transmintExceptionDate
      Log.info(JSON.stringify(this.exceptionData))
    }
  }

  build() {
    Column(){
      Row()
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(AppStorage.get(app_top_Height))
        NavBar({ title: "异常详情" })
       Card(){
              CardItem({
                leftTitle:"异常时间",
                rightValue:this.exceptionData.exceptionTime,
                showRightArrow:false
              })

         CardItem({
           leftTitle:"上报位置",
           rightValue:this.exceptionData.exceptionPlace,
           showRightArrow:false
         })

         CardItem({
           leftTitle:"异常类型",
           rightValue:this.exceptionData.exceptionType,
           showRightArrow:false
         })

         CardItem({
           leftTitle:"异常时间",
           rightValue:this.exceptionData.exceptionTime,
           showRightArrow:false,
           showBottomBorder:false
         })
          Row(){
                Text(this.exceptionData.exceptionDescribe || '无')
                  .fontSize(14)
                  .fontColor($r("app.color.text_secondary"))
          }.width('100%')
         .padding(15)
         .justifyContent(FlexAlign.Start)
       }


       Card(){
        CardItem({
          leftTitle:"异常图片",
          rightValue:"",
          showBottomBorder:false,
          showRightArrow:false
        })

         if (this.exceptionData.exceptionImagesList?.length){
           Flex({wrap:FlexWrap.Wrap,direction:FlexDirection.Row}){
             ForEach(this.exceptionData.exceptionImagesList,(item:ImageList,index:number)=>{

               Image(item.url)
                 .width(95)
                 .aspectRatio(1)
                 .borderRadius(8)
                 .margin({left:15})
             })
           }.width('100%')
           .margin({top:15,bottom:15})

         }

       }

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}