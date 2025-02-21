import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, util, worker } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';
import { ImageList, PostParams } from '../model';
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = async (e: MessageEvents) => {
  //进行图片压缩
  //1.接收主线程发送的数据
  const params = e.data as PostParams
  let arr: ImageList[] = [] //存储压缩后的图片地址
  //2.图片压缩:需要从数组中一张一张的进行压缩，然后将压缩完成后的图片地址返回给主线程
  if (params.files.length) {
    const imagePackerApi = image.createImagePacker()
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: 20 }; //压缩80%
    while (params.files.length) {
      const images = params.files.pop()
      const sourceImage = fileIo.openSync(images?.url, fileIo.OpenMode.READ_ONLY)
      const destPath = params.filePath + "/" + util.generateRandomUUID() + "_2.jpg" //压缩后图片存放的位置
      const targetImage = fileIo.openSync(destPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      await imagePackerApi.packToFile(image.createImageSource(sourceImage.fd), targetImage.fd, packOpts)

      fileIo.close(sourceImage)
      fileIo.close(targetImage)
      arr.push({
        url: destPath
      })
    }
  }
  //3.回传
  workerPort.postMessage({ files: arr } as PostParams)

  //4.销毁子线程
  workerPort.close()
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}