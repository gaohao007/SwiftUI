//进度条
@Component
@CustomDialog
export  struct Loading{
  controller:CustomDialogController
  loadingText:string=""
 hwidth:number=40
  maxNum:number=100
  @State num:number =0
  timer=-1
  aboutToAppear(): void {
      this.timer=  setInterval(()=>{
          if (this.num === this.maxNum) {
            this.num =0
          }
          this.num++
        },10)
 }
aboutToDisappear(): void {
  clearInterval(this.timer)
 }

  build() {
 Column({space:10}){
   Progress({
     value:this.num,
     total:this.maxNum,
     type:ProgressType.ScaleRing
   }).color($r("app.color.text_secondary"))
     .width(this.hwidth)
     .style({strokeWidth:2})
   if (this.loadingText){
     Text(this.loadingText)
       .fontSize(12)
       .fontColor($r("app.color.text_secondary"))
   }
 }.alignItems(HorizontalAlign.Center)
  }
}
