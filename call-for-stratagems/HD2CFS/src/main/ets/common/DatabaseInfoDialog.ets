import DatabaseService from '../database/DatabaseService'
import DatabaseModel from '../database/model/DatabaseModel'
import { i18n } from '@kit.LocalizationKit'
import { DividerLine } from './UiUtils'
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
  @Link db: DatabaseModel

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
    } catch (_err) {}
    this.onDelete();
  }

  build() {
    Column({ space: 20 }) {
      // 标题
      Text($r('app.string.db_info_title'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)

      // 详细信息
      Column({ space: 5 }) {
        Text($r('app.string.db_info_id', this.db.id))
        if (i18n.System.getSystemLanguage() == 'zh-Hans') {
          Text($r('app.string.db_info_name', this.db.nameZh))
        } else {
          Text($r('app.string.db_info_name', this.db.name))
        }
        if (this.db.ver == 'null') {
          Text($r('app.string.db_ver_null'))
            .fontColor($r('app.color.text_alert'))
        } else {
          Text($r('app.string.db_info_ver', this.db.ver))
        }
        Text($r('app.string.db_info_url', this.db.url))
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 按钮
      Row({ space: 20 }) {
        // 删除
        Button($r('app.string.dialog_delete'))
          .onClick(() => {
            this.deleteDb();
            this.controller.close();
          })
          .fontColor($r('app.color.button_text_alert'))
          .backgroundColor($r('app.color.button_background'))
          .layoutWeight(1)

        Divider()
          .vertical(true)
          .height(22)

        // 确认
        Button($r('app.string.dialog_accept'))
          .onClick(() => {
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