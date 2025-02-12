import { Log } from '@abner/log'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct TaskDetail {
  aboutToAppear() {
   const id =  router.getParams() as string
    Log.info(id)
  }

  build() {
    Column(){

    }
    .height('100%')
    .width('100%')
  }
}