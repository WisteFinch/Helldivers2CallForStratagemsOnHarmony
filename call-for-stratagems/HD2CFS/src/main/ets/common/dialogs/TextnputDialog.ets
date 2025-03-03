import { AppButton } from "../UiUtils"

/**
 * 文本输入对话框
 */
@CustomDialog
export struct TextInputDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: TextInputDialog() })
  /**
   * 确认回调
   */
  confirm: (value: string) => void = () => {
  }
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

  build() {
    Column() {
      Column() {
        // 标题
        Text(this.title)
          .margin(10)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_stress'))
          .fontFamily('Sinclair')

        Text()
          .width('100%')
          .height(10)
          .backgroundColor($r('app.color.transparent'))
          .backgroundImage($r('app.media.stripes'))
          .backgroundImageSize(ImageSize.Cover)

        // 输入框
        TextInput({ placeholder: this.placeholder })
          .onChange((value) => {
            this.value = value;
          })
          .caretColor($r('app.color.caret'))
          .backgroundColor($r('app.color.background_secondary'))
          .borderRadius(0)
          .margin({
            top: 20,
            bottom: 10,
            left: 10,
            right: 10
          })
          .placeholderFont({ family: 'Sinclair' })
          .fontFamily('Sinclair')

        //按钮
        Row({ space: 20 }) {
          // 取消
          AppButton({
            weight: 1, click: () => {
              this.controller.close();
            }
          }) {
            Text($r('app.string.dialog_cancel'))
              .width('100%')
              .fontColor($r('app.color.button_text'))
              .fontFamily('Sinclair')
              .textAlign(TextAlign.Center)
          }

          //确认
          AppButton({
            weight: 1, click: () => {
              this.confirm(this.value);
              this.controller.close();
            }
          }) {
            Text($r('app.string.dialog_accept'))
              .width('100%')
              .fontColor($r('app.color.button_text'))
              .fontFamily('Sinclair')
              .textAlign(TextAlign.Center)
          }
        }
        .height(40)
        .margin(10)
      }
      .margin(5)
      .backgroundColor($r('app.color.background_primary'))
    }
    .margin({ left: 10, right: 10, bottom: 20 })
    .borderColor($r('app.color.border_highlight'))
    .borderWidth(2)
    .backgroundColor($r('app.color.transparent'))
  }
}