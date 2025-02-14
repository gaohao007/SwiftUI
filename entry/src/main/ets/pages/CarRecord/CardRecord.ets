import { Card, CardItem, NavBar } from '../../components'
import { app_top_Height } from '../../constants'

@Entry
@Component
struct CardRecord {


  build() {
    Column(){
          Row().width('100%')
            .backgroundColor($r("app.color.white"))
            .height(AppStorage.get(app_top_Height))
          NavBar({title:"回车登记"})
      Card(){
            CardItem({
              leftTitle:"出车时间",
              rightValue:"22324-2323-232"
            })

        CardItem({
          leftTitle:"出车时间",
          rightValue:"请选择",
          showBottomBorder:false
        })

      }
      Row(){
            Button('交车').width('100%')
              .backgroundColor($r("app.color.primary"))
      }

    }
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}