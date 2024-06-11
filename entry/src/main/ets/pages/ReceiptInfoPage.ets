import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { Bill } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import LabelUtil from '../utils/LabelUtil'
import ToolBarComponent, { ToolBarIcon } from '../view/common/ToolBarComponent'
import TypeRadioComponent from '../view/receipt/TypeRadioComponent'
import StringUtil from '../utils/StringUtil'
import { ReceiptHandleType } from '../model/ReceiptModel'
import { MediaHelper } from '../media/MediaHelper'
import SelectorBottomSheetDialog from '../dialog/SelectorBottomSheetDialog'
import common from '@ohos.app.ability.common'
import Logger from '../utils/Logger'
import TextInUtil from '../utils/TextInUtil'
import LoadingDialog from '../dialog/LoadingDialog'

const DEFAULT_LABEL_NAME: string = "点击选择标签"
const CANCEL_STRING: string = '取消'

@Entry
@Component
struct ReceiptInfoPage {
  @State isIncome: boolean = false
  @State money: string = ""
  @State labelName: string = DEFAULT_LABEL_NAME
  @State date: string = StringUtil.getNowFormatDate()
  @State shopkeeper: string = ""
  @State remark: string | null = ""
  @State isEditPage: boolean = false
  private pageChangeCount: number = 0
  private backRouterName: string
  private billId: number = 0
  private tagSelectIndex: number = 0
  private selectedDate: Date = new Date(Date.now())
  private mediaHelper: MediaHelper = new MediaHelper(getContext())
  private addIcon: ToolBarIcon = { icon: $r("app.media.ic_complete"), onClick: () => {
    this.doAddBill()
  } }
  private deleteIcon: ToolBarIcon = { icon: $r("app.media.ic_delete_2"), onClick: () => {
    this.showDeleteDialog()
  } }
  private imageIcon: ToolBarIcon = { icon: $r("app.media.ic_add_photo"), onClick: () => {
    this.dialogController.open()
  } }
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectorBottomSheetDialog({
      title: "选择",
      sheets: [
        {
          content: "拍照",
          action: async () => {
            this.mediaHelper.takePhoto(getContext(this) as common.UIAbilityContext)
          }
        },
        {
          content: "从相册中选择图片",
          action: async () => {
            let resMediaBean = await this.mediaHelper.selectPicture()
            this.loadingController.open()
            let billCropRes = await TextInUtil.billsCrop(resMediaBean)
            this.loadingController.close()
            this.money = billCropRes.billPrice
            this.date = billCropRes.billTime
            this.labelName = billCropRes.billType
            this.shopkeeper = billCropRes.billShopkeeper
          }
        }
      ]
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -10 }
  })

  private loadingController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      message: "智能识别中..."
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false
  })

  aboutToAppear() {
    let bill: Bill | null = (router.getParams() as Record<string, Bill | null>)['bill']
    this.backRouterName = (router.getParams() as Record<string, string | null>)['backRouterName']
    this.pageChangeCount = (router.getParams() as Record<string, number | null>)['pageChangeCount']
    if (bill !== null) {
      this.billId = bill.billId
      this.isIncome = bill.money < 0
      this.money = Math.abs(bill.money).toString()
      this.labelName = LabelUtil.getLabelNameFormId(bill.labelId)
      this.date = bill.time.split(' ')[0]
      this.shopkeeper = bill.shopkeeper
      this.remark = bill.remark
      this.isEditPage = true
    }
  }

  aboutToDisappear() {
    this.dialogController = undefined
    this.loadingController = undefined
  }

  build() {
    Column() {
      ToolBarComponent({
        title: this.isEditPage ? "账单详情" : "添加账单",
        backIcon: true,
        icons: this.isEditPage ? [this.imageIcon, this.deleteIcon] : [this.imageIcon, this.addIcon]
      })
      Row() {
        Text("¥")
          .fontSize(55)
          .fontColor($r("app.color.primary"))
        TextInput({ placeholder: "0.00", text: this.money })
          .type(InputType.Normal)
          .fontSize(60)
          .fontColor($r("app.color.primary"))
          .placeholderColor($r("app.color.primary"))
          .placeholderFont({ size: 60 })
          .caretColor($r("app.color.transparent"))
          .style(TextInputStyle.Inline)
          .backgroundColor($r("app.color.transparent"))
          .padding(3)
          .onChange((value: string) => {
            this.money = value
          })
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 35 })

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_type"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("类型")
          .fontSize(16)
          .margin({ right: 30 })
        TypeRadioComponent({ isIncomeType: $isIncome, onChangeListener: (value: boolean) => {
          this.isIncome = value
        } })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_tag_2"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("标签")
          .fontSize(16)
        Text(this.labelName)
          .fontSize(16)
          .fontColor(this.labelName == DEFAULT_LABEL_NAME ? $r("app.color.gray") : $r("app.color.black"))
          .margin({ left: 25 })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")
      .onClick(() => {
        TextPickerDialog.show({
          range: LabelUtil.getLabelNameList(),
          selected: this.tagSelectIndex,
          onAccept: (value: TextPickerResult) => {
            this.tagSelectIndex = value.index
            this.labelName = LabelUtil.getLabelNameList()[value.index]
          },
        })
      })

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_time_2"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("时间")
          .fontSize(16)
        Text(this.date)
          .fontSize(16)
          .fontColor($r("app.color.black"))
          .margin({ left: 25 })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")
      .onClick(() => {
        DatePickerDialog.show({
          start: new Date("2000-1-1"),
          end: new Date("2100-12-31"),
          selected: this.selectedDate,
          onAccept: (value: DatePickerResult) => {
            this.selectedDate.setFullYear(value.year, value.month, value.day)
            this.date = `${value.year}-${value.month + 1}-${value.day}`
          },
        })
      })

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_shopkeeper"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("商家")
          .fontSize(16)
        TextInput({ placeholder: "点击输入商家", text: this.shopkeeper })
          .fontSize(16)
          .placeholderFont({ size: 16 })
          .placeholderColor($r("app.color.gray"))
          .caretColor($r("app.color.primary"))
          .style(TextInputStyle.Inline)
          .backgroundColor($r("app.color.transparent"))
          .margin({ left: 25 })
          .padding(0)
          .borderRadius(0)
          .onChange((value: string) => {
            this.shopkeeper = value
          })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_remark"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("备注")
          .fontSize(16)
          .margin({ top: 3 })
        TextArea({ placeholder: "...", text: this.remark })
          .fontSize(16)
          .placeholderFont({ size: 16 })
          .placeholderColor($r("app.color.gray"))
          .caretColor($r("app.color.primary"))
          .backgroundColor($r("app.color.transparent"))
          .margin({ left: 25 })
          .padding({ left: 0, top: 3 })
          .borderRadius(0)
          .height(100)
      }
      .alignItems(VerticalAlign.Top)
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")

      if (this.isEditPage)
        Button("修改")
          .fontSize(18)
          .backgroundColor($r("app.color.primary"))
          .padding({ left: 50, right: 50, top: 8, bottom: 8 })
          .onClick(() => {
            this.showUpdateDialog()
          })
    }
    .backgroundColor($r("app.color.grayBackground"))
    .width("100%")
    .height("100%")
  }

  @Builder NormalDivider() {
    Divider()
      .color($r("app.color.primary"))
      .width(2)
      .margin({ left: 30, bottom: 10 })
      .width("100%")
  }

  private showUpdateDialog() {
    AlertDialog.show(
      {
        title: '提示', // 标题
        message: '是否需要修改该账单?', // 内容
        autoCancel: false, // 点击遮障层时，是否关闭弹窗。
        alignment: DialogAlignment.Center, // 弹窗在竖直方向的对齐方式
        offset: { dx: 0, dy: -20 }, // 弹窗相对alignment位置的偏移量
        primaryButton: {
          value: CANCEL_STRING,
          action: () => {
          }
        },
        secondaryButton: {
          value: '修改',
          fontColor: '#D94838',
          action: () => {
            if (this.billId > 0) {
              if (StringUtil.isNumber(this.money)) {
                let moneyInNumber = Math.abs(Number.parseFloat(this.money))
                this.updateBill({
                  billId: this.billId,
                  labelId: LabelUtil.getLabelIdFromName(this.labelName),
                  userId: 0,
                  money: this.isIncome ? -moneyInNumber : moneyInNumber,
                  remark: this.remark,
                  time: this.date,
                  shopkeeper: this.shopkeeper
                })
              } else {
                promptAction.showToast({ message: "金额必须为数字" })
              }
            }
          }
        }
      }
    )
  }

  private showDeleteDialog() {
    AlertDialog.show(
      {
        title: '提示',
        message: '是否需要删除该账单?',
        autoCancel: false,
        alignment: DialogAlignment.Center,
        offset: { dx: 0, dy: -20 },
        primaryButton: {
          value: CANCEL_STRING,
          action: () => {
          }
        },
        secondaryButton: {
          value: '删除',
          fontColor: '#D94838',
          action: () => {
            if (this.billId > 0) {
              this.removeBill(this.billId)
            }
          }
        }
      }
    )
  }

  private doAddBill() {
    if (!StringUtil.isContentEmpty(this.money)) {
      if (!StringUtil.isContentEmpty(this.labelName)) {
        if (!StringUtil.isContentEmpty(this.shopkeeper)) {
          if (StringUtil.isNumber(this.money)) {
            let moneyInNumber = Math.abs(Number.parseFloat(this.money))
            this.addBill({
              billId: 0,
              labelId: LabelUtil.getLabelIdFromName(this.labelName),
              userId: 0,
              money: this.isIncome ? -moneyInNumber : moneyInNumber,
              remark: this.remark,
              time: this.date,
              shopkeeper: this.shopkeeper
            })
          } else {
            promptAction.showToast({ message: "金额必须为数字" })
          }
        } else {
          promptAction.showToast({ message: "商家不能为空" })
        }
      } else {
        promptAction.showToast({ message: "标签不能为空" })
      }
    } else {
      promptAction.showToast({ message: "金额不能为0" })
    }
  }

  private addBill(bill: Bill) {
    HttpHelper.getInstance().put({ url: "bill/add", data: bill, onDataSuccess: (data, msg) => {
      promptAction.showToast({ message: msg })
      this.pageChangeCount++
      router.back({
        url: this.backRouterName,
        params: {
          handleType: ReceiptHandleType.TYPE_ADD,
          data: bill,
          pageChangeCount: this.pageChangeCount
        }
      });
    } })
  }

  private removeBill(billId: number) {
    HttpHelper.getInstance().delete({ url: "/bill/remove", params: { billId: billId }, onDataSuccess: (data, msg) => {
      promptAction.showToast({ message: msg })
      this.pageChangeCount++
      router.back({
        url: this.backRouterName,
        params: {
          handleType: ReceiptHandleType.TYPE_REMOVE,
          data: { billId: billId },
          pageChangeCount: this.pageChangeCount
        }
      });
    } })
  }

  private updateBill(bill: Bill) {
    HttpHelper.getInstance().put({ url: "/bill/update", data: bill, onDataSuccess: (data, msg) => {
      promptAction.showToast({ message: msg })
      this.pageChangeCount++
      router.back({
        url: this.backRouterName,
        params: {
          handleType: ReceiptHandleType.TYPE_UPDATE,
          data: bill,
          pageChangeCount: this.pageChangeCount
        }
      });
    } })
  }
}