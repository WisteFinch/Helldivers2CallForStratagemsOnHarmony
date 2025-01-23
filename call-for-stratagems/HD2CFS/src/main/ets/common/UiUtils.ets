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

@Builder export function ListItemGroupHead(str: Resource) {
  Text(str)
    .width('100%')
    .padding({left: 10, bottom: 5})
    .fontColor($r('app.color.text_hint'))
}

@Builder export function PageHead(str: Resource) {
  Row() {
    Text(str)
      .fontWeight(FontWeight.Bold)
      .fontSize(20)
  }
  .height("100%")
  .margin({left: 6})
}

@CustomDialog
export struct TextInputDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: TextInputDialog() })
  confirm: (value: string) => void = () => {}
  title: ResourceStr = ''
  placeholder: ResourceStr = ''
  value: string = ''
  divider: DividerLine = new DividerLine(1, 10, 10, $r('app.color.divider'))

  build() {
    Column({ space: 20 }) {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
      TextInput({placeholder: this.placeholder})
        .onChange((value) => {
          this.value = value;
        })
      Row({ space: 20 }) {
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