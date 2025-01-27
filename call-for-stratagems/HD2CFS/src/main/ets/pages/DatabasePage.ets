import { DatabaseUpdateDialog } from '../common/DatabaseUpdateDialog';
import { PageHead, TextInputDialog } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import { DatabaseInfoDialog } from '../common/DatabaseInfoDialog';

@Component
export struct DatabasePage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State list: DatabaseModel[] = []
  @State addList: string[] = []
  @State curDb: DatabaseModel = new DatabaseModel('null', 'null', 'null', 'null', 'null')

  addDbDialog: CustomDialogController = new CustomDialogController({
    builder: TextInputDialog({
      title: $r('app.string.db_add_title'),
      placeholder: $r('app.string.db_add_hint'),
      confirm: (value) => {
        this.addList = [value];
        this.updateDbDialog.open();
      }
    }),
    alignment: DialogAlignment.Bottom
  })

  updateDbDialog: CustomDialogController = new CustomDialogController({
    builder: DatabaseUpdateDialog({
      tasks: this.addList,
      confirm: () => {
        DatabaseService.GetDbList().then((value) => {
          this.list = value;
        })
      }
    }),
    alignment: DialogAlignment.Bottom
  })

  infoDialog: CustomDialogController = new CustomDialogController({
    builder: DatabaseInfoDialog({
      db: this.curDb,
      onDelete: () => {
        DatabaseService.GetDbList().then((value) => {
          this.list = value;
        })
      }
    }),
    alignment: DialogAlignment.Bottom
  })

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
                    .fontWeight(FontWeight.Medium)
                } else {
                  Text(item.name)
                    .fontWeight(FontWeight.Medium)
                }
                // 数据库版本
                if (item.ver == 'null') {
                  Text($r('app.string.db_ver_null'))
                    .fontColor($r('app.color.text_alert'))
                } else {
                  Text(item.ver)
                    .fontColor($r('app.color.text_hint'))
                }
              }
              .alignItems(HorizontalAlign.Start)
              .flexShrink(1)

              Blank()

              // 更新
              Button() {
                Image($r('app.media.ic_sync'))
                  .width(30)
                  .height(30)
                  .fillColor($r('app.color.button_text'))
              }
              .width(40)
              .height(40)
              .backgroundColor($r('app.color.button_background'))
              .onClick(() => {
                this.addList = [item.url];
                this.updateDbDialog.open();
              })

              // 详细信息
              Button() {
                Image($r('app.media.ic_more'))
                  .width(30)
                  .height(30)
                  .fillColor($r('app.color.button_text'))
                  .onClick(() => {
                    this.curDb = item;
                    this.infoDialog.open();
                  })
              }
              .width(40)
              .height(40)
              .backgroundColor($r('app.color.button_background'))
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .borderRadius(24)
          .padding(10)
          .backgroundColor($r('app.color.background_primary'))
        })
      }
      .width('100%')
      .height('100%')
      .padding('16')
      .backgroundColor($r('app.color.background_secondary'))
    }
    .title(PageHead($r('app.string.db_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .backgroundColor($r('app.color.background_secondary'))
    .menus([
      {
        value: '',
        icon: 'resources/base/media/ic_sync.svg',
        action: ()=> {
          this.addList = [];
          for (let i = 0; i < this.list.length; i++) {
            this.addList.push(this.list[i].url);
          }
          this.updateDbDialog.open();
        },
        isEnabled: this.list.length > 0
      },
      {
        value: '',
        icon: 'resources/base/media/ic_add.svg',
        action: ()=> {
          this.addDbDialog.open();
        }
      }
    ])
  }
}