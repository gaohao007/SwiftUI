import { fileIo } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import File from '@system.file';

@Entry
@Component
struct FileCopy {
  @State
  list: ResourceStr[] = [
    "https://img0.baidu.com/it/u=2373411163,3695295946&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202005%2F09%2F20200509082358_QC4tG.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=7505fc6da6991d423f9165a19aa1edf1",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2F37f5ca53-0526-7d31-e22c-af01d0336714%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=8897e9bb197bed85dfd091c7772ab98d",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201908%2F15%2F20190815105853_4xB5V.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=97d2c31c5fae9e0da8dca20b0a5104c9",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201811%2F06%2F20181106210452_kjljj.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=9ded8a355b5964fee9fa1c833f9795cc",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201809%2F30%2F20180930235959_VCFPn.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=25320cd1095d6bd3c80800f3f71899b3",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F28%2F20181028130215_bwthn.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=d8ac6dc26891d1b4610b8a155c892ccb",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2F01028n0169bn5d32o6q011c1ytm0lzw63a%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=2f9d2e17f7ebb0ad354140da84c2ef6f",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F12%2F20181012013627_CLjxR.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233159&t=a24e31dc1a5aa5ee844f9aff882b07c3",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fea86243a-a102-49d3-90e5-f48d3b909b94%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1727233295&t=68ab736b45432a12defeaabf237e3ba7"
  ]

  // 下载到沙箱
  async downLoadImages() {
    let arr: string[] = []
    const allTasks = this.list.map(item => {
      let filePath = getContext().cacheDir + '/' + util.generateRandomUUID() + '.jpg'
      arr.push(filePath)
      return new Promise<boolean>((resolve, reject) => {
        request.downloadFile(getContext(), {
          url: item as string,
          filePath
        }).then(task => {
          task.on("complete", () => {
            resolve(true)
          })
          task.on("fail", () => {
            reject(false)
          })
        })
      })
    })
    await Promise.all(allTasks)
    return arr

  }

  async getFileBuffer(filePath: string): Promise<ArrayBuffer> {
    try {
      const imageSource = image.createImageSource(filePath)
      let imagePackerApi = image.createImagePacker();
      let buffer = await imagePackerApi.packing(imageSource, {
        quality: 100,
        format: 'image/jpeg'
      })
      return buffer
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error(`read file failed, errCode:${error.code}, errMessage:${error.message}`);
      return Promise.reject(err)
    }
  }

  // 保存沙箱图片到相册
  async saveImgToAssets() {
    try {
      const allImages = await this.downLoadImages()
      let index = 0
      while (index < allImages.length) {
        let context = getContext();
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
        // Creating a Media File
        let uri = await phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
        // Open the created media file and read the local file and convert it to ArrayBuffer for easy filling.
        let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        const buffer = await this.getFileBuffer(allImages[index])
        // Write the read ArrayBuffer to the new media file.
        let writeLen = await fileIo.write(file.fd, buffer);
        await fileIo.close(file);
        index++
      }
      promptAction.showToast({ message: '下载成功' })

    } catch (err) {
      AlertDialog.show({ message: err.message })
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        SaveButton()
          .onClick((event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              this.saveImgToAssets()
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')

      GridRow({ columns: 2 }) {
        ForEach(this.list, (item: string) => {
          GridCol() {
            Image(item)
              .height(150)
              .height(150)
              .borderRadius(4)
          }
          .margin({
            top: 10
          })
        })
      }
    }
  }
}