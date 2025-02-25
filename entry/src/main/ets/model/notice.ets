
//公告的请求参数
export  interface  NoticeParams{
  contentType:number
  page:number
  pageSize:number
}
export class NoticeParamsModel implements  NoticeParams{
  contentType:number=200
  page:number=1
  pageSize:number=10
  constructor(model:NoticeParams) {
    this.contentType = model.contentType
    this.page = model.page
    this.pageSize = model.pageSize
  }
}
//接收消息通知接口
export  interface  NoticeList{
  counts:number
  pageSize:number
  pages:number
  page:number
  items:NoticeListItem[]
}

export class NoticeListModel implements NoticeList{
  counts:number=0
  pageSize:number=0
  pages:number=0
  page:number=0
  items:NoticeListItem[]=[]
  constructor(model:NoticeList) {
    this.counts = model.counts
    this.pageSize = model.pageSize
    this.pages = model.pages
    this.page = model.page
    this.items = model.items
  }
}


export interface NoticeListItem{
  id: string,
  title:string,
  content:string,
  bussinessType:number,
  userId: string,
  contentType: number,
  isRead: string,
  readTime: null |string,
  relevantId: string,
  createUser: string,
  created: string,
  updateUser: string,
  updated: string
}

export class NoticeListItemModel implements NoticeListItem{
  id: string=''
  title:string=''
  content:string=''
  bussinessType:number=0
  userId: string=''
  contentType: number=0
  isRead: string=''
  readTime: null |string=null
  relevantId: string=''
  createUser: string=''
  created: string=''
  updateUser: string=''
  updated: string=''
  constructor(model:NoticeListItem) {
    this.id = model.id
    this.title = model.title
    this.content = model.content
    this.bussinessType = model.bussinessType
    this.userId = model.userId
    this.contentType = model.contentType
    this.isRead = model.isRead
    this.readTime = model.readTime
    this.relevantId = model.relevantId
    this.createUser = model.createUser
    this.created = model.created
  }
}



























































