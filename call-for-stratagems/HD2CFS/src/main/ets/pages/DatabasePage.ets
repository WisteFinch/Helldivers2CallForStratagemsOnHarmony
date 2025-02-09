import { DatabaseUpdateDialog } from '../common/DatabaseUpdateDialog';
import { AppButton, PageHead, TextInputDialog } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import { DatabaseInfoDialog } from '../common/DatabaseInfoDialog';

@Component
export struct DatabasePage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  /**
   * 数据库渠道数据
   */
  @State list: DatabaseModel[] = []
  /**
   * 任务列表
   */
  @State tasks: string[] = []
  /**
   * 当前选定的数据库渠道
   */
  @State curDb: DatabaseModel = new DatabaseModel('null', 'null', 'null', 'null', 'null')
  /**
   * 添加数据库渠道对话框
   */
  addDbDialog: CustomDialogController = new CustomDialogController({
    builder: TextInputDialog({
      title: $r('app.string.db_add_title'),
      placeholder: $r('app.string.db_add_hint'),
      confirm: (value) => {
        this.tasks = [value];
        this.updateDbDialog.open();
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    maskColor: $r('app.color.background_blur')
  })
  /**
   * 升级数据库渠道对话框
   */
  updateDbDialog: CustomDialogController = new CustomDialogController({
    builder: DatabaseUpdateDialog({
      tasks: this.tasks,
      confirm: () => {
        DatabaseService.GetDbList().then((value) => {
          this.list = value;
        })
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    maskColor: $r('app.color.background_blur')
  })
  /**
   * 数据库渠道信息对话框
   */
  infoDialog: CustomDialogController = new CustomDialogController({
    builder: DatabaseInfoDialog({
      db: this.curDb,
      onDelete: () => {
        DatabaseService.GetDbList().then((value) => {
          this.list = value;
        })
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    maskColor: $r('app.color.background_blur')
  })

  /**
   * 导航菜单
   */
  @Builder
  navMenus() {
    Row({ space: 5 }) {
      // 更新数据库渠道
      if (this.list.length > 0) {
        AppButton({
          click: () => {
            this.tasks = [];
            for (let i = 0; i < this.list.length; i++) {
              this.tasks.push(this.list[i].url);
            }
            this.updateDbDialog.open();
          }
        }) {
          Image($r('app.media.ic_sync'))
            .width(20)
            .height(20)
        }
      } else {
        AppButton({
          click: () => {
            this.tasks = [];
            for (let i = 0; i < this.list.length; i++) {
              this.tasks.push(this.list[i].url);
            }
            this.updateDbDialog.open();
          },
          enable: false
        }) {
          Image($r('app.media.ic_sync'))
            .width(20)
            .height(20)
        }
      }

      // 添加数据库渠道
      AppButton({
        click: () => {
          this.addDbDialog.open()
        }
      }) {
        Image($r('app.media.ic_add'))
          .width(20)
          .height(20)
      }
    }
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .margin({ right: 10 })
  }

  aboutToAppear() {
    DatabaseService.GetDbList().then((value) => {
      this.list = value;
    })
  }

  build() {
    NavDestination() {
      List({ space: 10 }) {
        ForEach(this.list, (item: DatabaseModel) => {
          ListItem() {
            Row({ space: 5 }) {
              // 警告
              if (item.ver == 'null') {
                Image($r('app.media.ic_error'))
                  .width(30)
                  .height(30)
                  .fillColor($r('app.color.text_alert'))
              }

              // 基本信息
              Column() {
                // 数据库名称
                if (i18n.System.getSystemLanguage() == 'zh-Hans') {
                  Text(item.nameZh)
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                } else {
                  Text(item.name)
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                }
                // 数据库版本
                if (item.ver == 'null') {
                  Text($r('app.string.db_ver_null'))
                    .fontColor($r('app.color.text_alert'))
                    .fontFamily('Sinclair')
                } else {
                  Text(item.ver)
                    .fontColor($r('app.color.text_secondary'))
                    .fontFamily('Sinclair')
                }
              }
              .alignItems(HorizontalAlign.Start)
              .flexShrink(1)

              Blank()

              // 更新
              AppButton({
                click: () => {
                  this.tasks = [item.url];
                  this.updateDbDialog.open();
                }
              }) {
                Image($r('app.media.ic_sync'))
                  .width(30)
                  .height(30)
                  .fillColor($r('app.color.button_text'))
              }

              // 详细信息
              AppButton({
                click: () => {
                  this.curDb = item;
                  this.infoDialog.open();
                }
              }) {
                Image($r('app.media.ic_more'))
                  .width(30)
                  .height(30)
                  .fillColor($r('app.color.button_text'))
              }
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .backgroundColor($r('app.color.background_secondary'))
          .borderWidth(2)
          .borderColor($r('app.color.border'))
          .padding(10)
        })
      }
      .width('100%')
      .height('100%')
      .padding('16')
      .backgroundColor($r('app.color.transparent'))
      .scrollBarColor('#8d874f')
    }
    .title(PageHead($r('app.string.db_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .backgroundImage($r('app.media.bg_2'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundEffect({ radius: 2, color: $r('app.color.background_blur') })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .menus(this.navMenus())
  }
}