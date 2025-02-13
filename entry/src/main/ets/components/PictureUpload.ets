import { photoAccessHelper } from "@kit.MediaLibraryKit"


@Component
export struct PictureUpload{
  title:string =""
  build() {
    Column(){
      Text(this.title)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
        .margin({top:15,bottom:15})
      Row(){
        Image($r("app.media.ic_add_img"))
          .width(30)
          .aspectRatio(1)
          .border({width:1,color:$r("app.color.text_secondary"),style:BorderStyle.Dashed})
      }.width(95)
      .aspectRatio(1)
      .backgroundColor($r("app.color.background_page"))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .borderRadius(4)
      .onClick(()=>{
        this.selectImage()
      })
    }.width('100%')
    .alignItems(HorizontalAlign.Start)
  }
  // 打开相册
  selectImage(){
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
    photoPicker.select()
  }
}
