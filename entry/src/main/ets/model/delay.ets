export interface DelayParams {
  delayReason: string
  delayTime: string
  id: string
}

export class DelayParamsModel implements DelayParams {
  delayReason: string = ""
  delayTime: string = ""
  id: string = ""

  constructor(model: DelayParams) {
    this.delayReason = model.delayReason
    this.delayTime = model.delayTime
    this.id = model.id
  }
}