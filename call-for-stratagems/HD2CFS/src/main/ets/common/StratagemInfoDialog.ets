import StratagemModel from "../database/model/StratagemModel"

/**
 * 战备信息对话框
 */
@CustomDialog
export struct StratagemInfoDialog {
  controller: CustomDialogController

  /**
   * 数据库信息
   */
  @Link db: StratagemModel

  build() {
    Column({ space: 20 }) {

    }
    .padding(20)
  }
}