@Entry
@Component
struct CarInfo {
  @State message: string = 'Hello World';

  build() {
    Column(){

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}