import { UserTaskInfoParamsModel,
  LoginForm,
  UserInfoModel,
  UserTaskInfoModel } from '../model/user'
import { Request_API } from '../utils/request'

export  const  getUserInfo=()=>{
 return Request_API.get<UserInfoModel>('users')
}
//登录业务
export  async function  login(data:LoginForm):Promise<string>{
 return  await Request_API.post<string>('login/account',data)
}

export    function getUserTaskInfo(data:UserTaskInfoParamsModel){
   return  Request_API.get<UserTaskInfoModel>("users/taskReport",data)
}


