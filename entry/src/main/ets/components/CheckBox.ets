
//选择框
@Component
export  struct  HmCheckBox{
  title:string=""
  @Prop value:boolean
  checkChange:(value:boolean)=>void=()=>{}
  build() {
    Row(){
      Row(){
        Text(this.title)
          .fontSize(14)
          .fontColor($r("app.color.text_primary"))
        Row({space:20}){
          Row(){
            Image(this.value?$r("app.media.ic_radio_true"):$r("app.media.ic_radio_false"))
              .width(32).aspectRatio(1)
            Text('是')
              .fontSize(14)
              .fontColor($r("app.color.text_secondary"))
          }.onClick(()=>{
            this.value =true
            this.checkChange(this.value)
          })

          Row(){
            Image(this.value?$r("app.media.ic_radio_false"):$r("app.media.ic_radio_true"))
              .width(32).aspectRatio(1)
            Text('否')
              .fontSize(14)
              .fontColor($r("app.color.text_secondary"))
          }.onClick(()=>{
            this.value =false
            this.checkChange(this.value)
          })

        }
      }
      .backgroundColor($r("app.color.white"))
      .width('100%')
      .padding({left:15,right:15})
      .height(60)
      .borderRadius(8)
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('100%')
    .padding({left:15,right:15})
    .margin({top:15})
  }
}