import { router } from "@kit.ArkUI"
@Component
export  struct  NavBar{
showBackIcon:boolean=true
  title:string=""
  build() {
    Stack({alignContent:Alignment.TopStart}){
     Row(){
          if (this.title){
            Text(this.title)
              .fontSize(18)
              .fontWeight(700)
              .fontColor($r("app.color.text_primary"))
          }
     }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

        if (this.showBackIcon){
          Row(){
            Image($r("app.media.ic_btn_nav_back"))
              .width(44)
              .height(44)
              .onClick(()=>{
                router.back()
              })
          }.alignItems(VerticalAlign.Center)
          .width(44)
        }


    }.width('100%')
    .height(50)
    .padding(10)
    .backgroundColor($r("app.color.white"))

  }
}