import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { HttpHelper } from '../network/HttpHelper'
import StringUtil from '../utils/StringUtil'
import common from '@ohos.app.ability.common';
import PreferencesUtil from '../utils/PreferencesUtil';
import LabelUtil from '../utils/LabelUtil'
import { Label } from '../model/ResponseModel'


const USERNAME: string = 'username';
const PASSWORD: string = 'password';
export const USERID: string = 'userId';

@Entry
@Component
struct LoginPage {
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  @State username: string = ''
  @State password: string = ''

  aboutToAppear() {
    PreferencesUtil.get(USERNAME, '', (value) => {
      this.username = value
    })
    PreferencesUtil.get(PASSWORD, '', (value) => {
      this.password = value
    })
  }

  build() {
    Column() {
      Text('登录')
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
      Row() {
        Text('没有账号?来注册吧')
          .fontSize(16)
          .fontColor($r('app.color.primary'))
          .decoration({ type: TextDecorationType.Underline })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/RegisterPage'
            }, router.RouterMode.Single)
          })
        Button('登录')
          .backgroundColor($r('app.color.primary'))
          .fontSize(16)
          .padding({ left: 30, right: 30 })
          .onClick(() => {
            this.doLogin()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 36, right: 36 })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  private doLogin() {
    if (!StringUtil.isContentEmpty(this.username, this.password)) {
      HttpHelper.getInstance()
        .post({
          url: '/user/login',
          params: { username: this.username, password: this.password },
          onDataSuccess: (data: string, msg: string) => {
            HttpHelper.getInstance().setAuthToken(data)
            this.getUserId()
            PreferencesUtil.put(USERNAME, this.username)
            PreferencesUtil.put(PASSWORD, this.password)
            promptAction.showToast({ message: msg })
            this.getAllLabels()
          }
        })
    } else {
      promptAction.showToast({ message: '用户名和密码不能为空' })
    }
  }

  private getAllLabels() {
    HttpHelper.getInstance()
      .get({ url: "/label/getAll", onDataSuccess: (data: Label[]) => {
        LabelUtil.initLabelList(data)
        router.replaceUrl({
          url: 'pages/MainPage'
        }, router.RouterMode.Single)
      } })
  }

  private getUserId() {
    HttpHelper.getInstance().get({url: "/user/getUserId", onDataSuccess: (data: number) => {
      PreferencesUtil.put(USERID, data)
    }})
  }
}