import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { Log } from "@abner/log"
import { ImageList } from "../model"
import { fileIo } from "@kit.CoreFileKit"
import File from "@system.file"
import { util } from "@kit.ArkTS"
import { request } from "@kit.BasicServicesKit"
import { upLoadImage } from "../api"


@Component
export struct PictureUpload{
  // 照片列表
  @Prop
      ImageList:ImageList[]=[]

  onListChange:(list:ImageList[])=>void=()=>{}

  maxNumber:number=6
  title:string =""
@Prop
  isOrNoUpLoad:boolean=true
  build() {
    Column(){
      Text(this.title)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
        .margin({top:15,bottom:15})
      Grid(){
        ForEach(this.ImageList,(item:ImageList,index:number)=>{
       GridItem(){
         Stack({alignContent:Alignment.TopEnd}){
           Image(item.url)
             .width(95)
             .aspectRatio(1)
             .borderRadius(6)
           if (this.isOrNoUpLoad) {
             Image($r("app.media.ic_btn_delete"))
               .width(30).aspectRatio(1)
               .onClick(()=>{
                 this.ImageList.splice(index,1)
                 this.onListChange(this.ImageList)
               })
           }
         }
       }
        })
        if (this.ImageList.length<this.maxNumber && this.isOrNoUpLoad ){
          GridItem(){
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
          }
        }
      }.columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)


    }.width('100%')
    .alignItems(HorizontalAlign.Start)
  }
  // 打开相册
  async selectImage(){
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
   const res = await photoPicker.select({
      MIMEType:photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber:this.maxNumber  -   this.ImageList.length
    })
    Log.info(JSON.stringify(res))
    if (res.photoUris.length) {
      this.ImageList = this.ImageList.concat(res.photoUris.map(url=>{
        return {url:url} as ImageList
      }))
      //通知父组件
      this.onListChange(this.ImageList)
    }
  }
}

export async  function  UploadFiles (list:ImageList[]){
  //将文件copy到cache沙箱目录中
  const cacheDir = getContext().cacheDir
  const fileParams:request.File[]=[]
  list.forEach((Image:ImageList)=>{
    const  source =  fileIo.openSync(Image.url,fileIo.OpenMode.READ_ONLY)
  const  newName = util.generateRandomUUID()+'.jpg'
    fileIo.copyFileSync(source.fd,cacheDir+"/"+newName)
    fileIo.closeSync(source)
    fileParams.push({
      filename:newName,
      name:"file",
      uri: "internal://cache/" + newName,
      type:"jpg"
    })
  })
  Log.info(JSON.stringify(fileParams))

//   调用后端接口完成图片上传
  return await upLoadImage(getContext(),fileParams)

}













