@Component
@CustomDialog
export  struct  SelectCard{
  controller:CustomDialogController

  @BuilderParam
  cardContent:()=>void
    confirm:()=>void=()=>{}
  build() {
    Column(){
      Row(){
          Text('选择类型')
            .fontColor($r("app.color.text_primary"))
            .fontWeight(700)
        Image($r("app.media.ic_btn_close"))
          .width(13)
          .aspectRatio(1)
          .onClick(()=>{
            this.controller.close()
          })
      }.width('100%')
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .border({width:{bottom:1},color:$r("app.color.background_divider")})


        if (this.cardContent){
          this.cardContent()
        }
    Row(){
          Button('确定')
            .width(200)
            .height(50)
            .backgroundColor($r("app.color.primary"))
            .onClick(()=>{
              if (this.confirm) {
                this.confirm()
              }
              this.controller.close()
            })
    }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({top:20,bottom:20})


    }.width('100%')
    .padding({left:20,right:20})
    .borderRadius({topLeft:16,topRight:16})
    .backgroundColor($r("app.color.white"))
  }
}