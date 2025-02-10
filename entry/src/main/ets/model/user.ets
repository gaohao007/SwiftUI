export  interface  LoginForm{
  account:string
  passowrd:string
}
export  class LoginFormModel implements LoginForm{
  account: string =''
  passowrd: string=''

  constructor(model:LoginForm) {
    this.passowrd = model.passowrd
    this.account = model.account
  }
}