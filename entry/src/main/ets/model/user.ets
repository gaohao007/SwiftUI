export  interface  LoginForm{
  account:string
  password:string
}
export  class LoginFormModel implements LoginForm{
  account: string =''
  password: string=''

  constructor(model:LoginForm) {
    this.password = model.password
    this.account = model.account
  }
}