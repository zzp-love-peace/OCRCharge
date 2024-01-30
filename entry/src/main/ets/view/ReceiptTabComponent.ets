import { Label } from '../model/ResponseModel';
import { HttpHelper } from '../network/HttpHelper';
import LabelUtil from '../utils/LabelUtil';
import Logger from '../utils/Logger';
import ReceiptComponent, { ReceiptType } from './ReceiptComponent';
import ToolBarComponent from './ToolBarComponent';

@Component
export default struct ReceiptTabComponent {
  @State currentIndex: number = 0;

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.primary') : $r('app.color.gray'))
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .width('40%')
        .strokeWidth(2)
        .color($r('app.color.primary'))
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      ToolBarComponent({ title: "账单", icons: [{ icon: $r("app.media.ic_search"), onClick: () => {
      } },
        { icon: $r("app.media.ic_edit"), onClick: () => {
        } }] })
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          ReceiptComponent({ receiptType: ReceiptType.TYPE_EXPENSE })
        }
        .tabBar(this.TabBuilder(0, '支出'))

        TabContent() {
          ReceiptComponent({ receiptType: ReceiptType.TYPE_INCOME })
        }
        .tabBar(this.TabBuilder(1, '收入'))
      }
      .scrollable(true)
      .barWidth('94%')
      .barMode(BarMode.Fixed)
      .vertical(false)
      .onChange((index) => {
        this.currentIndex = index;
      })
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.grayBackground"))
  }
}