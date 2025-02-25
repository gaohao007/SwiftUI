import { NoticeList, NoticeParams } from '../model/notice'
import { Request_API } from '../utils/request'


//车辆新增
export    function getNotice(data:NoticeParams){
  return  Request_API.get<NoticeList>("messages/page",data)
}
