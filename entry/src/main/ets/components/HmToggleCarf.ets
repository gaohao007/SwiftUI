




@Component
export struct ToggleCard{
  @BuilderParam
  CardContent:()=>void

  @State isShowToggleImage:boolean= true
  title:string=""
  build() {
    Column(){
          Row(){
            Text(this.title)
              .fontColor($r("app.color.text_primary"))
              .fontWeight(500)
               Image(!this.isShowToggleImage?$r("app.media.ic_btn_add"):$r("app.media.ic_btn_cut"))
                 .width(24)
                 .height(24)
              .onClick(()=>{
                this.isShowToggleImage = ! this.isShowToggleImage
              })

          }.width('100%')
            .height(80)
      .justifyContent(FlexAlign.SpaceBetween)
      if (this.CardContent && this.isShowToggleImage){
          this.CardContent()
      }
    }.borderRadius(8)
    .backgroundColor($r("app.color.white"))
    .margin({left:15,right:15,top:15})
    .padding({
      left:20,right:20,bottom:20
    })
  }
}






