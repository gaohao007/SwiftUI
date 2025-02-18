# day08-webview混合开发





## 1.掌握授权过程并总结流程

https://github.com/gaohao007/SwiftUI.git



- 应用APL等级与权限等级的匹配关系请参考APL等级说明。

- 权限的授权方式分为user_grant（用户授权）和system_grant（系统授权），具体请参考授权方式说明。

  - 如果目标权限是system_grant类型，开发者在进行权限申请后，系统会在安装应用时自动为其进行权限预授予，开发者不需要做其他操作即可使用权限。

  在应用需要获取user_grant权限时，请完成以下步骤：

  在配置文件中，声明应用需要请求的权限。

  ```typescript
  {
    "module" : {
      // ...
      "requestPermissions":[
        {
          "name" : "ohos.permission.PERMISSION1",
          "reason": "$string:reason",
          "usedScene": {
            "abilities": [
              "FormAbility"
            ],
            "when":"inuse"
          }
        },
        {
          "name" : "ohos.permission.PERMISSION2",
          "reason": "$string:reason",
          "usedScene": {
            "abilities": [
              "FormAbility"
            ],
            "when":"always"
          }
        }
      ]
    }
  }
  ```

  将应用中需要申请权限的目标对象与对应目标权限进行关联，让用户明确地知道，哪些操作需要用户向应用授予指定的权限。

  运行应用时，在用户触发访问操作目标对象时应该调用接口，精准触发动态授权弹框。该接口的内部会检查当前用户是否已经授权应用所需的权限，如果当前用户尚未授予应用所需的权限，该接口会拉起动态授权弹框，向用户请求授权。

  ```wiki
  约束与限制
  user_grant权限授权要基于用户可知可控的原则，需要应用在运行时主动调用系统动态申请权限的接口，系统弹框由用户授权，用户结合应用运行场景的上下文，识别出应用申请相应敏感权限的合理性，从而做出正确的选择。
  系统不鼓励频繁弹窗打扰用户，如果用户拒绝授权，将无法再次拉起弹窗，需要应用引导用户在系统应用“设置”的界面中手动授予权限。
  系统权限弹窗不可被遮挡。
  系统权限弹窗不可被其他组件/控件遮挡，弹窗信息需要完整展示，以便用户识别并完成授权动作。
  如果系统权限弹窗与其他组件/控件同时同位置展示，系统权限弹窗将默认覆盖其他组件/控件。
  每次执行需要目标权限的操作时，应用都必须检查自己是否已经具有该权限。
  如需检查用户是否已向您的应用授予特定权限，可以使用checkAccessToken()函数，此方法会返回PERMISSION_GRANTED或PERMISSION_DENIED。
  每次访问受目标权限保护的接口之前，都需要使用requestPermissionsFromUser()接口请求相应的权限。
  用户可能在动态授予权限后通过系统设置来取消应用的权限，因此不能将之前授予的授权状态持久化。
  
  应用在onWindowStageCreate()回调中申请授权时，需要等待异步接口loadContent()/setUIContent()执行结束后或在loadContent()/setUIContent()回调中调用requestPermissionsFromUser()，否则在Content加载完成前，requestPermissionsFromUser会调用失败。
  应用在UIExtensionAbility申请授权时，需要在onWindowStageCreate函数执行结束后或在onWindowStageCreate函数回调中调用requestPermissionsFromUser()，否则在ability加载完成前，requestPermissionsFromUser会调用失败。
  ```

  检查用户的授权结果，确认用户已授权才可以进行下一步操作。

- 应用可以通过ACL（访问控制列表）方式申请高级别的权限，具体请参考申请使用受限权限。





## 2.掌握混合开发的传值方式

通过对javaScriptProxy和runJavaScript封装，实现JSBridge通信方案。使用Web组件javaScriptProxy将原生侧接口注入到H5的window对象上，通过runJavaScript接口执行JS脚本到H5中，并在回调中获取脚本执行结果。(**通过WebviewController中runJavaScript方法异步执行JavaScript脚本，并通过回调方式获取执行结果。runJavaScript需要在loadUrl完成后，比如onPageEnd中调用**。)



## 3.实现高德地图的定位

创建AMap.Map对象时如果没有传入center参数，您会发现地图将自动定位到您所在城市并显示，这就是JS API的初始加载定位：无需传入对应参数就能获取大致的定位信息。

web组件通过onPageEnd回调,WebviewController控制器运行(传参数)Js脚本,把坐标值传给center进行定位





## 3.复习三个生命周期，并提交总结笔记

> UIABility、Page、Component
>
> ### UIABility
>
> 当用户打开、切换和返回到对应应用时，应用中的UIAbility实例会在其生命周期的不同状态之间转换。UIAbility类提供了一系列回调，通过这些回调可以知道当前UIAbility实例的某个状态发生改变，会经过UIAbility实例的创建和销毁，或者UIAbility实例发生了前后台的状态切换。
>
> UIAbility的生命周期包括Create、Foreground、Background、Destroy四个状态.
>
>
> Create状态
> 	Create状态为在应用加载过程中，UIAbility实例创建完成时触发，系统会调用onCreate()回调。可以在该回调中进行页面初始化操作，例如变量定义资源加载等，用于后续的UI展示。(Want是对象间信息传递的载体，可以用于应用组件间的信息传递。)
>
> WindowStageCreate和WindowStageDestroy状态
> 	UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。WindowStage创建完成后会进入onWindowStageCreate()回调，可以在该回调中设置UI加载、设置WindowStage的事件订阅。在onWindowStageCreate()回调中通过loadContent()方法设置应用要加载的页面，并根据需要调用on('windowStageEvent')方法订阅WindowStage的事件（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）  对应于onWindowStageCreate()回调。在UIAbility实例销毁之前，则会先进入
> onWindowStageDestroy()回调，可以在该回调中释放UI资源。
> WindowStageWillDestroy状态
> 	对应onWindowStageWillDestroy()回调，在WindowStage销毁前执行，此时WindowStage可以使用。
> Foreground和Background状态	
> 	Foreground和Background状态分别在UIAbility实例切换至前台和切换至后台时触发，对应于onForeground()回调和onBackground()回调。onForeground()回调，在UIAbility的UI可见之前，如UIAbility切换至前台时触发。可以在onForeground()回调中申请系统需要的资源，或者重新申请在onBackground()中释放的资源。onBackground()回调，在UIAbility的UI完全不可见之后，如UIAbility切换至后台时候触发。可以在onBackground()回调中释放UI不可见时无用的资源，或者在此回调中执行较为耗时的操作，例如状态保存等。当应用切换到后台状态，可以在onBackground()回调中停止定位功能，以节省系统的资源消耗。

#### Page

页面生命周期，即被@Entry装饰的组件生命周期，提供以下生命周期接口：

- onPageShow：页面每次显示时触发一次，包括路由过程、应用进入前台等场景。
- onPageHide：页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。
- onBackPress：当用户点击返回按钮时触发。

#### Component

组件生命周期，即一般用@Component装饰的自定义组件的生命周期，提供以下生命周期接口：

- aboutToAppear：组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行。
- onDidBuild：组件build()函数执行完成之后回调该接口，开发者可以在这个阶段进行埋点数据上报等不影响实际UI的功能。不建议在onDidBuild函数中更改状态变量、使用animateTo等功能，这可能会导致不稳定的UI表现。
- aboutToDisappear：aboutToDisappear函数在自定义组件析构销毁之前执行。不允许在aboutToDisappear函数中改变状态变量，特别是@Link变量的修改可能会导致应用程序行为不稳定。