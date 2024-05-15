import router from '@ohos.router'

export interface ToolBarIcon {
  icon: Resource;
  onClick: (() => void);
}

@Component
export default struct ToolBarComponent {
  @Prop title: string
  icons: ToolBarIcon[] = []
  backIcon: boolean = false

  build() {
    RelativeContainer() {
      if (this.backIcon) {
        Image($r("app.media.ic_back"))
          .fillColor($r('app.color.black'))
          .width(24)
          .height(24)
          .margin({ left: 18 })
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            left: { anchor: "__container__", align: HorizontalAlign.Start }
          })
          .id("backIcon")
          .onClick(() => {
            router.back()
          })
      }
      Text(this.title)
        .fontColor($r('app.color.black'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          middle: { anchor: "__container__", align: HorizontalAlign.Center },
        })
        .id("title")
      if (this.icons.length > 0) {
        Row() {
          ForEach(this.icons, (icon: ToolBarIcon) => {
            Image(icon.icon)
              .fillColor($r('app.color.black'))
              .width(24)
              .height(24)
              .margin({ right: 18 })
              .onClick(icon.onClick)
          })
        }
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .id("icons")
      }
    }
    .width('100%')
    .height(65)
  }
}