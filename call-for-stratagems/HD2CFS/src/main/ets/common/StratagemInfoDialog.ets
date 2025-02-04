import StratagemModel from "../database/model/StratagemModel"
import { fileUri } from "@kit.CoreFileKit"
import { i18n } from "@kit.LocalizationKit"
import { Button } from "@ohos.multimodalInput.mouseEvent"
import { ButtonBorderOptions } from "./UiUtils"

/**
 * 战备信息对话框
 */
@CustomDialog
export struct StratagemInfoDialog {
  controller: CustomDialogController
  /**
   * 战备信息
   */
  @Link stratagem: StratagemModel

  build() {
    Row() {
      Row({ space: 10 }) {
        // 图像
        Image(fileUri.getUriFromPath(getContext().filesDir + `/${this.stratagem.dbId}/${this.stratagem.icon}.svg`))
          .width(50)
          .height(50)

        Column({ space: 10 }) {
          // 标题
          if (i18n.System.getSystemLanguage() == 'zh-Hans') {
            Text(this.stratagem.nameZh)
              .fontSize(20)
              .fontColor($r('app.color.text_primary'))
              .fontFamily('Sinclair')
          } else {
            Text(this.stratagem.name)
              .fontSize(20)
              .fontColor($r('app.color.text_primary'))
              .fontFamily('Sinclair')
          }
          // 按键
          Row({ space: 5 }) {
            ForEach(this.stratagem.steps, (step: number) => {
              if (step == 1) {
                Image($r('app.media.ic_arrow_upward'))
                  .width(20)
                  .height(20)
              } else if (step == 2) {
                Image($r('app.media.ic_arrow_downward'))
                  .width(20)
                  .height(20)
              } else if (step == 3) {
                Image($r('app.media.ic_arrow_backward'))
                  .width(20)
                  .height(20)
              } else if (step == 4) {
                Image($r('app.media.ic_arrow_forward'))
                  .width(20)
                  .height(20)
              }
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin(5)
      .padding(10)
      .backgroundColor($r('app.color.background_primary'))
    }
    .borderImage(ButtonBorderOptions)
    .backgroundColor($r('app.color.transparent'))
  }
}