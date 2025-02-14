import { ImageList } from "."

export interface PickUpParams{
  cargoPickUpPictureList: ImageList[]
  id: string
  cargoPictureList: ImageList[]
}
export class PickUpParamsModel implements PickUpParams {
  cargoPickUpPictureList: ImageList[] = []
  id: string = ""
  cargoPictureList: ImageList[] = []

  constructor(model: PickUpParams) {
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.id = model.id
    this.cargoPictureList = model.cargoPictureList
  }
}