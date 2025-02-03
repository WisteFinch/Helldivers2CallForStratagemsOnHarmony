/**
 * 分割线预设样式
 */
export class DividerLine {
  strokeWidth: Length = 1
  startMargin: Length = 5
  endMargin: Length = 5
  color: ResourceColor = $r('app.color.divider')

  constructor(strokeWidth: Length = 1, startMargin: Length = 5, endMargin: Length = 5, color: ResourceColor = $r('app.color.divider')) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}

/**
 * 列表组标题
 * @param str 标题文本
 */
@Builder export function ListItemGroupHead(str: Resource) {
  Text(str)
    .width('100%')
    .padding(5)
    .margin({bottom: 5})
    .fontWeight(FontWeight.Medium)
    .fontColor($r('app.color.text_title'))
    .fontFamily('Sinclair')
    .backgroundColor($r('app.color.background_primary'))
    .backgroundImage($r('app.media.stripes'))
    .backgroundImageSize(ImageSize.Cover)
}

/**
 * 页面标题
 * @param str 标题文本
 */
@Builder export function PageHead(str: Resource) {
  Row() {
    Text(str)
      .fontWeight(FontWeight.Bold)
      .fontSize(20)
      .fontColor($r('app.color.text_title'))
      .fontFamily('Sinclair')
  }
  .height("100%")
  .margin({left: 6})
}

/**
 * 文本输入对话框
 */
@CustomDialog
export struct TextInputDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: TextInputDialog() })

  /**
   * 确认回调
   */
  confirm: (value: string) => void = () => {}

  /**
   * 标题
   */
  title: ResourceStr = ''

  /**
   * 输入框提示
   */
  placeholder: ResourceStr = ''

  /**
   * 输入值
   */
  value: string = ''

  /**
   * 分割线
   */
  divider: DividerLine = new DividerLine(1, 10, 10, $r('app.color.divider'))

  build() {
    Column({ space: 20 }) {
      // 标题
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)

      // 输入框
      TextInput({placeholder: this.placeholder})
        .onChange((value) => {
          this.value = value;
        })

      //按钮
      Row({ space: 20 }) {
        // 取消
        Button($r('app.string.dialog_cancel'))
          .onClick(() => {
            this.controller.close();
          })
          .fontColor($r('app.color.button_text'))
          .backgroundColor($r('app.color.button_background'))
          .layoutWeight(1)

        Divider()
          .vertical(true)
          .height(22)

        //确认
        Button($r('app.string.dialog_accept'))
          .onClick(() => {
          this.confirm(this.value);
          this.controller.close();
        })
          .fontColor($r('app.color.button_text'))
          .backgroundColor($r('app.color.button_background'))
          .layoutWeight(1)
      }
      .height(40)
    }
    .padding(20)
  }
}