/**
 * 分割线预设样式
 */
export class DividerLine {
  strokeWidth: Length = 1
  startMargin: Length = 5
  endMargin: Length = 5
  color: ResourceColor = $r('app.color.divider')

  constructor(strokeWidth: Length = 1, startMargin: Length = 5, endMargin: Length = 5,
    color: ResourceColor = $r('app.color.divider')) {
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
@Builder
export function ListItemGroupHead(str: Resource) {
  Text(str)
    .width('100%')
    .padding(5)
    .margin({ bottom: 5 })
    .fontWeight(FontWeight.Medium)
    .fontColor($r("app.color.text_stress"))
    .fontFamily('Sinclair')
    .backgroundColor($r('app.color.background_primary'))
    .backgroundImage($r('app.media.stripes'))
    .backgroundImageSize(ImageSize.Cover)
}

/**
 * 页面标题
 * @param str 标题文本
 */
@Builder
export function PageHead(str: Resource) {
  Row() {
    Text(str)
      .fontWeight(FontWeight.Bold)
      .fontSize(24)
      .fontColor($r("app.color.text_stress"))
      .fontFamily('Sinclair')
  }
  .height("100%")
  .margin({ left: 6 })
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
    Column({ space: 20 }) {
      // 标题
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_stress'))
        .fontFamily('Sinclair')

      // 输入框
      TextInput({ placeholder: this.placeholder })
        .onChange((value) => {
          this.value = value;
        })
        .caretColor($r('app.color.caret'))
        .backgroundColor($r('app.color.background_secondary'))
        .borderRadius(0)
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
    }
    .margin(20)
    .padding(20)
    .backgroundColor($r('app.color.background_tertiary'))
  }
}

/**
 * 按钮边框样式
 */
export const ButtonBorderOptions: BorderImageOption = {
  source: {
    angle: 0,
    direction: GradientDirection.Bottom,
    colors: [[$r('app.color.border'), 0.4], [$r('app.color.transparent'), 0.4], [$r('app.color.transparent'), 0.6],
      [$r('app.color.border'), 0.6]]
  },
  slice: {
    top: 2,
    bottom: 2,
    left: 2,
    right: 2
  },
  width: {
    top: 2,
    bottom: 2,
    left: 2,
    right: 2
  },
  repeat: RepeatMode.Stretch,
  fill: false
}

/**
 * 按钮
 */
@Component
export struct AppButton {
  @BuilderParam closer: () => void
  click: () => void = () => {
  }
  weight: string | number = 0

  build() {
    Column() {
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        this.closer()
      }
      .onClick(() => {
        this.click()
      })
      .margin(5)
      .padding(5)
      .backgroundColor($r('app.color.background_primary'))
    }
    .layoutWeight(this.weight)
    .borderImage(ButtonBorderOptions)
    .backgroundColor($r('app.color.transparent'))
  }
}

/**
 * 顶部对齐
 */
export const AlignTop: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top }
}

/**
 * 底部对齐
 */
export const AlignBottom: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom }
}

/**
 * 居中对齐
 */
export const AlignCenter: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
}

/**
 * 左上对齐
 */
export const alignTopLeft: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
}

/**
 * 右上对齐
 */
export const alignTopRight: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
}