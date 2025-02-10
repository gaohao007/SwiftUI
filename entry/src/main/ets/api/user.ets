import { LoginForm } from '../model/user'
import { Request_API } from '../utils/request'


//登录业务
export  async function  login(data:LoginForm):Promise<string>{
 return  await Request_API.post<string>('login/account',data)
}