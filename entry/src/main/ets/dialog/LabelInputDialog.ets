import promptAction from '@ohos.promptAction'
import { Label } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import { USERID } from '../pages/LoginPage'
import LabelUtil from '../utils/LabelUtil'
import PreferencesUtil from '../utils/PreferencesUtil'
import StringUtil from '../utils/StringUtil'
@CustomDialog
export default struct LabelInputDialog {
  @Link labels: Label[]
  private inputText: string = ""
  title: string
  controller: CustomDialogController
  cancel: () => void = () => {}
  confirm: () => void = () => {}

  build() {
    Column() {
      Text(this.title).fontSize(20).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: ''}).height(60).width('90%')
        .onChange((value: string) => {
          this.inputText = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor($r("app.color.white")).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            this.controller.close()
            this.confirm()
            this.addLabel(this.inputText)
          }).backgroundColor($r("app.color.white")).fontColor(Color.Red)
      }.margin({ bottom: 10, top: 8 })
    }
  }

  private addLabel(textValue: string) {
    if (!StringUtil.isContentEmpty(textValue)) {
      HttpHelper.getInstance()
        .put({ url: "/label/add", params: { labelName: textValue }, onDataSuccess: (labelId: number, msg: string) => {
          PreferencesUtil.get(USERID, 0, (userId: number) => {
            let newLabel = { labelId: labelId, labelName: textValue, userId: userId }
            LabelUtil.getLabelList().push(newLabel)
            this.labels = [...LabelUtil.getLabelList()]
            promptAction.showToast({ message: msg })
          })
        } })
    } else {
      promptAction.showToast({ message: "标签名不能为空" })
    }
  }
}