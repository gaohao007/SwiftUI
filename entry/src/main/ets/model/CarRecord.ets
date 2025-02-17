import { ImageList } from '.'

export interface CarRecordParams {
  id: string
  startTime: string
  endTime: string
  accidentDescription: string | null
  accidentImagesList: ImageList[] | null
  accidentType: string | null
  breakRulesDescription: string | null
  breakRulesType: string | null
  deductPoints: number | null
  faultDescription: string | null
  faultImagesList: ImageList[] | null
  faultType: string | null
  isAccident: boolean | null
  isAvailable: boolean | null
  isBreakRules: boolean | null
  isFault: boolean | null
  penaltyAmount: string | null
}

export class CarRecordParamsModel implements CarRecordParams {
  id: string = ""
  startTime: string = ""
  endTime: string = ""
  accidentDescription: string | null = null
  accidentImagesList: ImageList[] | null = null
  accidentType: string | null = null
  breakRulesDescription: string | null = null
  breakRulesType: string | null = null
  deductPoints: number | null = null
  faultDescription: string | null = null
  faultImagesList: ImageList[] | null = null
  faultType: string | null = null
  isAccident: boolean | null = null
  isAvailable: boolean | null = null
  isBreakRules: boolean | null = null
  isFault: boolean | null = null
  penaltyAmount: string | null = null

  constructor(model: CarRecordParams) {
    this.id = model.id
    this.startTime = model.startTime
    this.endTime = model.endTime
    this.accidentDescription = model.accidentDescription
    this.accidentImagesList = model.accidentImagesList
    this.accidentType = model.accidentType
    this.breakRulesDescription = model.breakRulesDescription
    this.breakRulesType = model.breakRulesType
    this.deductPoints = model.deductPoints
    this.faultDescription = model.faultDescription
    this.faultImagesList = model.faultImagesList
    this.faultType = model.faultType
    this.isAccident = model.isAccident
    this.isAvailable = model.isAvailable
    this.isBreakRules = model.isBreakRules
    this.isFault = model.isFault
    this.penaltyAmount = model.penaltyAmount
  }
}