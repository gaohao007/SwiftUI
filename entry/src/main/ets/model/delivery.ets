import { ImageList } from ".";
export interface DeliverParams {
  deliverPictureList: ImageList[]
  id: string
  certificatePictureList: ImageList[]
}
export class DeliverParamsModel implements DeliverParams {
  deliverPictureList: ImageList[] = []
  id: string = ""
  certificatePictureList: ImageList[] = []

  constructor(model: DeliverParams) {
    this.deliverPictureList = model.deliverPictureList
    this.id = model.id
    this.certificatePictureList = model.certificatePictureList
  }
}