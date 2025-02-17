import dayjs from '@hview/dayjs'
import { Card, CardItem, NavBar, PictureUpload } from '../../components'
import { app_top_Height } from '../../constants'
import {  ExceptionParams,ExceptionParamsModel } from '../../model'


@Entry
@Component
struct ExceptionReport {
  maxLength: number = 50
  @State exceptionParams:ExceptionParams= new ExceptionParamsModel({} as ExceptionParams)
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
              leftTitle: "异常时间", rightValue: "请选择", onRightClick: () => {
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
              leftTitle: "上报位置", rightValue: "请选择"
            })
            CardItem({
              leftTitle: "异常类型", rightValue: "请选择"
            })
            CardItem({
              leftTitle: "异常描述",
              rightValue: "",
              showBottomBorder: false,
             showRightArrow:false
            })

            TextArea({ placeholder: "请输入异常描述" })
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

              onListChange: () => {

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
          .backgroundColor($r("app.color.primary_disabled"))
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
}
