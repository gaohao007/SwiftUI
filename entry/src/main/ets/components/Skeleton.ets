//骨架屏
@Component
export struct Skeleton{
  @State currentColor:string = '#f3f4f5'
  count:number=4
  timer:number=-1
  aboutToAppear(): void {
  this.timer = setInterval(()=>{
    if (this.currentColor = "#f3f4f5") {
      this.currentColor = '#f7f8f9'
    }else {
      this.currentColor ="#f3f4f5"
    }
  },100)
  }
  aboutToDisappear(): void {
          clearInterval(this.timer)
  }
  @Builder
  getSingleItem() {
    Column() {
      Row({space:10}) {
        Row()
          .width(40)
          .height(40)
          .borderRadius(20)
          .backgroundColor(this.currentColor)

        Column({ space: 10 }) {
          Row()
            .width('30%')
            .height(26)
            .backgroundColor(this.currentColor)
          Row()
            .width('80%')
            .height(26)
            .backgroundColor(this.currentColor)
          Row()
            .width('88%')
            .height(26)
            .backgroundColor(this.currentColor)
          Row()
            .width('90%')
            .height(26)
            .backgroundColor(this.currentColor)
          Row()
            .width('87%')
            .height(26)
            .backgroundColor(this.currentColor)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)
      .width('100%')
    }
    .margin({ bottom: 10 })
    .width('100%')
  }
  build() {
    Column(){
      ForEach(Array.from(Array(this.count)),()=>{
        this.getSingleItem()
      })
    }
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.white"))
  }
}