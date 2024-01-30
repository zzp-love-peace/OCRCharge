import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { HttpHelper } from '../network/HttpHelper'
import StringUtil from '../utils/StringUtil'
@Entry
@Component
struct RegisterPage {
  @State username: string = ''
  @State password: string = ''
  @State againPassword: string = ''

  build() {
    Column() {
      Text('注册')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 108 })
      Image($r('app.media.ic_face'))
        .width(144)
        .width(144)
        .fillColor($r('app.color.primary'))
        .margin({ top: 20 })
      TextInput({ text: this.username, placeholder: '用户名' })
        .height(50)
        .placeholderFont({ size: 16 })
        .enterKeyType(EnterKeyType.Next)
        .caretColor($r('app.color.primary'))
        .fontColor($r('app.color.primary'))
        .maxLength(12)
        .margin({ top: 36, bottom: 36 })
        .onChange((value: string) => {
          this.username = value
        })
      TextInput({ text: this.password, placeholder: '密码' })
        .height(50)
        .type(InputType.Password)
        .placeholderFont({ size: 16 })
        .caretColor($r('app.color.primary'))
        .fontColor($r('app.color.primary'))
        .maxLength(12)
        .margin({ bottom: 36 })
        .onChange((value: string) => {
          this.password = value
        })
      TextInput({ text: this.againPassword, placeholder: '确认密码' })
        .height(50)
        .type(InputType.Password)
        .placeholderFont({ size: 16 })
        .caretColor($r('app.color.primary'))
        .fontColor($r('app.color.primary'))
        .maxLength(12)
        .margin({ bottom: 36 })
        .onChange((value: string) => {
          this.againPassword = value
        })
      Button('注册')
        .backgroundColor($r('app.color.primary'))
        .fontSize(16)
        .padding({ left: 30, right: 30 })
        .onClick(() => {
          this.doRegister()
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 36, right: 36 })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  private doRegister() {
    if (!StringUtil.isContentEmpty(this.username, this.password, this.againPassword)) {
      if (this.password === this.againPassword) {
        HttpHelper.getInstance()
          .put({
            url: '/user/register',
            params: { username: this.username, password: this.password },
            onDataSuccess: (data: any, msg: string) => {
              promptAction.showToast({ message: msg })
              router.back()
            }
          })
      } else {
        promptAction.showToast({ message: '请保持两次输入密码一致' })
      }
    } else {
      promptAction.showToast({ message: '用户名和密码不能为空' })
    }
  }
}