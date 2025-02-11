@CustomDialog
@Component
export struct Confirmdelete{
  customController:CustomDialogController
  message:string =''
  buttonList:ConfrimButton[]=[]
  build() {
    Row(){
        Column(){
            Row(){
                Text(this.message).fontColor($r("app.color.text_primary"))
            }
            .width('100%')
            .height(80)
          .border({
            width:{bottom:1},
            color:$r("app.color.background_divider")
          })
          .justifyContent(FlexAlign.Center)

          Row(){
              ForEach(this.buttonList,(item:ConfrimButton,index:number)=>{
                Text(item.title)
                  .fontSize(item.fontsize||16)
                  .fontColor(item.fontColor ||$r("app.color.text_secondary"))
                  .height('100%')
                  .textAlign(TextAlign.Center)
                  .layoutWeight(1)
                  .border({
                    width:{
                      right:(this.buttonList.length>1 && index !== this.buttonList.length-1)?1:0
                    },
                    color:$r("app.color.background_divider")
                  })
                  .onClick(()=>{
                    if (item.action) {
                      item.action()
                    }
                    this.customController.close()
                  })
              })
          }.width('100%')
          .height(50)
        }
    }
    .width(280)
    .borderRadius(12)
    .backgroundColor($r("app.color.white"))

  }
}


class ConfrimButton{
  title:string =""
  fontsize?:number=16
  fontColor?:Resource|string=""
  action?:()=>void=()=>{}
}