import { emitter } from "@kit.BasicServicesKit"

export  const  setting_key = "swift_setting"
 export  const  setting_key_ad = "swift_setting_ad"

 export  const  app_top_Height = "top_height"
 export  const  app_bottom_height = "bottom_height"

 export  const  SUB_WINDOWN_NAME = "ad_win"

 export  const  USER_TOKEN_KEY = "TOKEN"

 export  const  TOKEN_KEY = "PERSISTENCESTORAGE_TOKEN_KEY"

 export  const  BASE_URL="http://122.51.240.24:31007/driver"


export const event: emitter.InnerEvent = {
  eventId: 1,
  priority: emitter.EventPriority.LOW
 };