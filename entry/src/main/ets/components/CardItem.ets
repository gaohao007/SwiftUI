@Component
export struct CardItem{
   showBottomBorder:boolean=true
   leftTitle:string=""
  @Prop rightValue:string=""
  showRightArrow:boolean=true
  onRightClick:()=>void=()=>{}
  build() {
    Row(){
          if (this.leftTitle){
            Text(this.leftTitle)
              .fontWeight(400)
              .fontColor($r("app.color.text_primary"))
              .constraintSize({maxWidth:"40%"})
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          }
          Row(){
            if (this.rightValue){
              Text(this.rightValue)
                .fontWeight(400)
                .fontColor($r("app.color.text_primary"))
                .constraintSize({maxWidth:"60%"})
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            if (this.showRightArrow){
              Image($r("app.media.ic_btn_more"))
                .width(24)
                .height(24)
                .onClick(()=>{
                  this.onRightClick()
                })
            }
          }
    }.width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width:{
        bottom: this.showBottomBorder?1:0
      },
      color:$r("app.color.background_divider")
    })
  }
}