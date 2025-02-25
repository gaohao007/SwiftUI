import { NoticeList, NoticeParams } from '../model/notice'
import { Request_API } from '../utils/request'


//车辆新增
export    function getNotice(data:NoticeParams){
  return  Request_API.get<NoticeList>("messages/page",data)
}
//全部已读
export    function readAll(contentType:number){
  return  Request_API.put<null>(`messages/readAll/${contentType}`)
}

//全部已读
export    function MarkedReaded(id:string){
  return  Request_API.put<null>(`messages/`+id)
}