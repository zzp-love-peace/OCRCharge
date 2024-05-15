import promptAction from '@ohos.promptAction'
import LabelInputDialog from '../dialog/LabelInputDialog'
import { Label } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import LabelUtil from '../utils/LabelUtil'
import ToolBarComponent from '../view/common/ToolBarComponent'

@Entry
@Component
struct LabelPage {
  @State private labels: Label[] = []
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: LabelInputDialog({
      labels: $labels,
      title: "添加标签",
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
  })

  aboutToAppear() {
    this.labels = LabelUtil.getLabelList()
  }

  aboutToDisappear() {
    this.dialogController = undefined
  }

  build() {
    Column() {
      ToolBarComponent({ title: "标签管理", backIcon: true, icons: [{ icon: $r("app.media.ic_add"), onClick: () => {
        this.dialogController.open()
      } }] })
      List({ space: 12 }) {
        ForEach(this.labels, (label: Label, index: number) => {
          ListItem() {
            Row() {
              Image($r("app.media.ic_tag"))
                .width(24)
                .height(24)
                .margin({ right: 12 })
              Text(label.labelName)
              Blank()
              if (label.userId !== 0) {
                Image($r("app.media.ic_delete"))
                  .width(24)
                  .height(24)
                  .onClick(() => {
                    this.deleteLabel(label, index)
                  })
              }
            }
            .padding({ left: 32, right: 32, top: 10, bottom: 10 })
            .backgroundColor($r("app.color.white"))
            .borderRadius(12)
            .width("100%")
          }
          .margin({ left: 32, right: 32 })
        }, item => item.labelId)
      }
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .width("100%")
      .layoutWeight(1)
    }
    .backgroundColor($r("app.color.grayBackground"))
    .width("100%")
    .height("100%")
  }

  private deleteLabel(label: Label, index: number) {
    AlertDialog.show(
      {
        title: '提示',
        message: `是否删除"${label.labelName}"标签?`,
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 4,
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '确定',
          action: () => {
            HttpHelper.getInstance()
              .delete({
                url: "/label/remove",
                params: { labelId: label.labelId },
                onDataSuccess: (data, msg: string) => {
                  LabelUtil.getLabelList().splice(index, 1)
                  this.labels = [...LabelUtil.getLabelList()]
                  promptAction.showToast({ message: msg })
                }
              })
          }
        },
      }
    )
  }
}