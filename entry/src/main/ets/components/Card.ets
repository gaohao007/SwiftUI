


@Component
export struct  Card{
  @BuilderParam
    CardContent:()=>void
  build() {
    Column(){
        Column(){
           if (this.CardContent){
             this.CardContent()
           }
        }
        .backgroundColor($r("app.color.white"))
      .borderRadius(8)
      .width('100%')
      .padding({left:15,right:15})
    }.width('100%')
    .padding(15)

  }
}

