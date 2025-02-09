import StratagemModel from "../database/model/StratagemModel"
import { fileUri } from "@kit.CoreFileKit"
import { AlignBottom, AlignCenter, AlignTop } from "./UiUtils"
import { curves } from "@kit.ArkUI"

/**
 * 战备项目
 */
@Component
export struct StratagemItem {
  /**
   * 战备信息
   */
  @State stratagem: StratagemModel = new StratagemModel(0, 'null', 'null', 'null', 'null', []);

  /**
   * 点击回调
   */
  click: (s: StratagemModel) => void = () => {};

  /**
   * 长按回调
   */
  longPress: (s: StratagemModel) => void = () => {};

  /**
   * 边框颜色
   */
  @State _borderColor: ResourceColor = $r('app.color.border');

  /**
   * 背景颜色
   */
  @State _bgColor: ResourceColor = $r('app.color.background_primary');

  build() {
    ListItem() {
      RelativeContainer() {
        Image(fileUri.getUriFromPath(getContext().filesDir + `/${this.stratagem.dbId}/${this.stratagem.icon}.svg`))
          .margin(5)
          .padding(5)
          .alignRules(AlignCenter)
          .backgroundColor(this._bgColor)
          .draggable(false)
        Text()
          .borderWidth({ top: 2, left: 2, right: 2 })
          .width('100%')
          .height('40%')
          .borderColor(this._borderColor)
          .alignRules(AlignTop)
        Text()
          .borderWidth({ bottom: 2, left: 2, right: 2 })
          .width('100%')
          .height('40%')
          .borderColor(this._borderColor)
          .alignRules(AlignBottom)
      }
      .width('100%')
      .height('100%')
    }
    .width('85')
    .height('85')
    .animation({ curve: curves.springMotion(0.1) })
    .onTouch((e: TouchEvent) => {
      if (e.type == TouchType.Down) {
        this._bgColor = $r('app.color.stress')
        this._borderColor = $r('app.color.border_highlight')
      }
      else if (e.type == TouchType.Up){
        this._bgColor = $r('app.color.background_primary')
        this._borderColor = $r('app.color.border')
      }
    })
    .onClick(()=> {
      this.click(this.stratagem);
    })
    .gesture(LongPressGesture({ repeat: false })
      .onAction((_e: GestureEvent) => {
        this.longPress(this.stratagem);
      }))
  }
}