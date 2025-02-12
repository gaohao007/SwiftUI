//进度条
@Component

export  struct Loading{
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
   Progress({
     value:this.num,
     total:this.maxNum,
     type:ProgressType.ScaleRing
   }).color($r("app.color.text_secondary"))
     .width(this.hwidth)
     .style({strokeWidth:2})
  }
}
