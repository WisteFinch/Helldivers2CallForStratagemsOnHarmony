import { curves } from "@kit.ArkUI"

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
 * 按钮边框默认样式
 */
export const ButtonBorderNormalOptions: BorderImageOption = {
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
 * 按钮边框按下样式
 */
export const ButtonBorderPressOptions: BorderImageOption = {
  source: {
    angle: 0,
    direction: GradientDirection.Bottom,
    colors: [[$r('app.color.border_highlight'), 0.4], [$r('app.color.transparent'), 0.4], [$r('app.color.transparent'), 0.6],
      [$r('app.color.border_highlight'), 0.6]]
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
  @BuilderParam closer: () => void;

  /**
   * 点击时间
   */
  click: () => void = () => {
  };

  /**
   * 布局权重
   */
  weight: string | number = 0;

  /**
   * 对齐方式
   */
  rules: AlignRuleOption = AlignTop;

  /**
   * 边距
   */
  marginValue: Length = 0

  /**
   * 启用
   */
  @State enable: boolean = true;

  /**
   * 边框颜色
   */
  @State _borderColor: BorderImageOption = ButtonBorderNormalOptions;

  /**
   * 背景颜色
   */
  @State _bgColor: ResourceColor = $r('app.color.background_primary');

  build() {
    Column() {
      Column() {
        this.closer()
      }
      .margin(5)
      .padding(5)
      .backgroundColor(this._bgColor)
      .backgroundImage(this.enable ? null : $r('app.media.stripes'))
      .backgroundImageSize(ImageSize.Cover)
      .animation({ curve: curves.springMotion(0.1) })
    }
    .margin(this.marginValue)
    .layoutWeight(this.weight)
    .alignRules(this.rules)
    .borderImage(this._borderColor)
    .backgroundColor($r('app.color.transparent'))
    .animation({ curve: curves.springMotion(0.1) })
    .onTouch((e: TouchEvent) => {
      if (this.enable && e.type == TouchType.Down) {
        this._bgColor = $r('app.color.stress')
        this._borderColor = ButtonBorderPressOptions
      }
      else if (e.type == TouchType.Up){
        this._bgColor = $r('app.color.background_primary')
        this._borderColor = ButtonBorderNormalOptions
      }
    })
    .onClick(() => {
      if (this.enable) {
        this.click()
      }
    })
  }
}

/**
 * 选项卡标签
 */
@Component
export struct AppTabItem {
  @State name: string = '';
  @State index: number = 0;
  @Prop selectedIndex: number;
  @Prop tabBarWidth: number;

  build() {
    RelativeContainer() {
      // 名称
      Text(this.name)
        .fontColor(this.selectedIndex === this.index ? $r("app.color.text_stress") : $r('app.color.text_primary'))
        .fontWeight(this.selectedIndex === this.index ? FontWeight.Medium : FontWeight.Normal)
        .fontFamily('Sinclair')
        .textOverflow({ overflow: this.selectedIndex === this.index ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
        .maxLines(1)
        .textAlign(TextAlign.Start)
        .width('100%')
        .height(30)
        .padding({ left: 10, right: 10 })
        .alignRules(AlignTop)
        .animation({ curve: curves.springMotion(0.25) })
      // 序号
      Text((this.index + 1).toString())
        .fontColor(this.selectedIndex === this.index ? $r("app.color.text_stress") : $r('app.color.text_primary'))
        .fontWeight(this.selectedIndex === this.index ? FontWeight.Medium : FontWeight.Normal)
        .fontFamily('Sinclair')
        .textAlign(TextAlign.Center)
        .width('fir_content')
        .height(20)
        .alignRules(AlignTopRight)
        .offset({ top: 27, right: 35 })
      // 边框
      Text()
        .width(this.tabBarWidth - 50)
        .height(this.selectedIndex === this.index ? 45 : 35)
        .outlineWidth({ left: 2, bottom: 2 })
        .outlineColor(this.selectedIndex === this.index ? $r('app.color.border_highlight') : $r('app.color.border'))
        .alignRules(AlignTopLeft)
        .animation({ curve: curves.springMotion(0.25) })
      Text()
        .width(30)
        .height(this.selectedIndex === this.index ? 45 : 35)
        .outlineWidth({ right: 2, bottom: 2 })
        .outlineColor(this.selectedIndex === this.index ? $r('app.color.border_highlight') : $r('app.color.border'))
        .alignRules(AlignTopRight)
        .animation({ curve: curves.springMotion(0.25) })
      // 斜线
      Image($r('app.media.slash'))
        .width(this.tabBarWidth - 50)
        .height(this.selectedIndex === this.index ? 10 : 0)
        .padding({ left: 5 })
        .alignRules(AlignTopLeft)
        .offset({ top: 30 })
        .animation({ curve: curves.springMotion(0.25) })
      Image($r('app.media.slash'))
        .width(30)
        .height(this.selectedIndex === this.index ? 10 : 0)
        .padding({ right: 5 })
        .alignRules(AlignTopRight)
        .offset({ top: 30 })
        .animation({ curve: curves.springMotion(0.25) })
    }
    .width(this.tabBarWidth)
    .height(50)
    .margin({ left: 5, right: 5 })
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
export const AlignTopLeft: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
}

/**
 * 右上对齐
 */
export const AlignTopRight: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
}

/**
 * 右下对齐
 */
export const AlignBottomRight: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
}