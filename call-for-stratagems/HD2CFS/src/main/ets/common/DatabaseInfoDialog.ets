import DatabaseService from '../database/DatabaseService'
import DatabaseModel from '../database/model/DatabaseModel'
import { i18n } from '@kit.LocalizationKit'
import { AppButton, DividerLine } from './UiUtils'
import fs from '@ohos.file.fs'

/**
 * 数据库信息对话框
 */
@CustomDialog
export struct DatabaseInfoDialog {
  controller: CustomDialogController
  /**
   * 删除数据库回调
   */
  onDelete: () => void = () => {
  }
  /**
   * 数据库信息
   */
  @Prop db: DatabaseModel
  /**
   * 分割线
   */
  divider: DividerLine = new DividerLine(1, 10, 10, $r('app.color.divider'))

  async deleteDb() {
    // 删除数据库条目
    await DatabaseService.deleteStratagems(this.db.id);
    await DatabaseService.deleteDb(this.db.id);
    // 删除文件
    try {
      await fs.rmdir(getContext().filesDir + `/${this.db.id}/`);
    } catch (_err) {
    }
    this.onDelete();
  }

  build() {
    Column({ space: 20 }) {
      // 标题
      Text($r('app.string.db_info_title'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_stress'))
        .fontFamily('Sinclair')

      // 详细信息
      Column({ space: 5 }) {
        Text($r('app.string.db_info_id', this.db.id))
          .fontColor($r('app.color.text_primary'))
          .fontFamily('Sinclair')
        if (i18n.System.getSystemLanguage() == 'zh-Hans') {
          Text($r('app.string.db_info_name', this.db.nameZh))
            .fontColor($r('app.color.text_primary'))
            .fontFamily('Sinclair')
        } else {
          Text($r('app.string.db_info_name', this.db.name))
            .fontColor($r('app.color.text_primary'))
            .fontFamily('Sinclair')
        }
        if (this.db.ver == 'null') {
          Text($r('app.string.db_ver_null'))
            .fontColor($r('app.color.text_alert'))
            .fontFamily('Sinclair')
        } else {
          Text($r('app.string.db_info_ver', this.db.ver))
            .fontColor($r('app.color.text_primary'))
            .fontFamily('Sinclair')
        }
        Text($r('app.string.db_info_url', this.db.url))
          .fontColor($r('app.color.text_primary'))
          .fontFamily('Sinclair')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 按钮
      Row({ space: 20 }) {
        // 删除
        AppButton({
          weight: 1, click: () => {
            this.deleteDb();
            this.controller.close();
          }
        }) {
          Text($r('app.string.dialog_delete'))
            .width('100%')
            .fontColor($r('app.color.button_text_alert'))
            .fontFamily('Sinclair')
            .textAlign(TextAlign.Center)
        }

        // 确认
        AppButton({
          weight: 1, click: () => {
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