import { DatabaseUpdateDialog } from '../common/dialogs/DatabaseUpdateDialog';
import { AppButton, PageHead } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import { DatabaseInfoDialog } from '../common/dialogs/DatabaseInfoDialog';
import { TextInputDialog } from '../common/dialogs/TextnputDialog';
import { curves } from '@kit.ArkUI';
import { clamp01 } from '../common/MathUtils';

@Component
export struct DatabasePage {
  @Consume('pageInfos') pageInfos: NavPathStack
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
  @State curDb: DatabaseModel = new DatabaseModel('null', 'null', 'null', 'null', 'null', 0)
  // 拖拽
  /**
   * 当前拖拽项目
   */
  @State private dragItem: string = ''
  /**
   * 当前缩放项目
   */
  @State private scaleItem: string = ''
  /**
   * 相邻项
   */
  @State private adjacentItem: string = ''
  /**
   * 相邻缩放
   */
  @State private adjacentScale: number = -1
  /**
   * 拖拽相对位移
   */
  private dragRefOffset: number = 0
  /**
   * 拖拽Y轴位移
   */
  @State private offsetY: number = 0
  /**
   * 项高度
   */
  private ITEM_HEIGHT: number = 85

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
   * 计算缩放
   * @param item 项id
   * @returns 缩放比例
   */
  private calcScale(item: string): number {
    if (this.scaleItem === item) {
      return 1.05;
    } else if (this.adjacentItem === item) {
      return this.adjacentScale;
    } else {
      return 1;
    }
  }

  /**
   * 移动项
   * @param index 原索引
   * @param newIndex 新索引
   */
  private async itemMove(index: number, newIndex: number): Promise<void> {
    let tmp = this.list.splice(index, 1)
    this.list.splice(newIndex, 0, tmp[0])
    await this.updateIndex(index)
    await this.updateIndex(newIndex)
  }

  /**
   * 刷新数据库排序
   * @param index 索引
   */
  private async updateIndex(index: number) {
    this.list[index].idx = index;
    await DatabaseService.addDb(this.list[index]);
  }

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
      List() {
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
                    .textOverflow({ overflow: TextOverflow.MARQUEE })
                    .maxLines(1)
                } else {
                  Text(item.name)
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .textOverflow({ overflow: TextOverflow.MARQUEE })
                    .maxLines(1)
                }
                // 数据库版本
                if (item.ver == 'null') {
                  Text($r('app.string.db_ver_null'))
                    .fontColor($r('app.color.text_alert'))
                    .fontFamily('Sinclair')
                    .textOverflow({ overflow: TextOverflow.MARQUEE })
                    .maxLines(1)
                } else {
                  Text(item.ver)
                    .fontColor($r('app.color.text_secondary'))
                    .fontFamily('Sinclair')
                    .textOverflow({ overflow: TextOverflow.MARQUEE })
                    .maxLines(1)
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
            .padding(10)
            .alignItems(VerticalAlign.Center)
          }
          .backgroundColor($r('app.color.background_secondary'))
          .borderWidth(2)
          .borderColor($r('app.color.border'))
          .margin({
            top: 5,
            bottom: 5,
            left: 16,
            right: 16
          })
          .scale({ x: this.calcScale(item.id), y: this.calcScale(item.id) })
          .zIndex(this.dragItem === item.id ? 1 : 0)
          .translate(this.dragItem === item.id ? { y: this.offsetY } : { y: 0 })
          .gesture(
            GestureGroup(GestureMode.Sequence,
              // 长按事件
              LongPressGesture({ repeat: true })
                .onAction(() => {
                  animateTo({ curve: Curve.Friction, duration: 300 }, () => {
                    this.scaleItem = item.id;
                  })
                })
                .onActionEnd(() => {
                  animateTo({ curve: Curve.Friction, duration: 300 }, () => {
                    this.scaleItem = '';
                  })
                }),
              // 拖动事件
              PanGesture({ fingers: 1, direction: null, distance: 0 })
                .onActionStart(() => {
                  this.dragItem = item.id;
                  this.dragRefOffset = 0;
                })
                .onActionUpdate(async (event: GestureEvent) => {
                  this.offsetY = event.offsetY - this.dragRefOffset;
                  this.adjacentItem = '';
                  let index = this.list.indexOf(item);
                  let value: number = 0;
                  // 计算相邻项缩放
                  if (this.offsetY < 0 && index > 0) {
                    value = clamp01(-this.offsetY / this.ITEM_HEIGHT);
                    this.adjacentItem = this.list[index-1].id;
                    this.adjacentScale = 1 - value / 20;
                  } else if (this.offsetY > 0 && index < this.list.length - 1) {
                    value = clamp01(this.offsetY / this.ITEM_HEIGHT);
                    this.adjacentItem = this.list[index+1].id;
                    this.adjacentScale = 1 - value / 20;
                  }
                  // 交换排序
                  if (this.offsetY > this.ITEM_HEIGHT / 2 && index < this.list.length - 1) {
                    this.offsetY -= this.ITEM_HEIGHT;
                    this.dragRefOffset += this.ITEM_HEIGHT;
                    await this.itemMove(index, index + 1);
                  } else if (this.offsetY < -this.ITEM_HEIGHT / 2 && index > 0) {
                    this.offsetY += this.ITEM_HEIGHT;
                    this.dragRefOffset -= this.ITEM_HEIGHT;
                    await this.itemMove(index, index - 1);
                  }
                })
                .onActionEnd(() => {
                  animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 50) }, () => {
                    this.dragItem = '';
                    this.adjacentItem = '';
                  })
                  animateTo({
                    curve: curves.interpolatingSpring(20, 1, 200, 20), delay: 150
                  }, () => {
                    this.scaleItem = '';
                  })
                })
            )
              .onCancel(() => {
                animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 50) }, () => {
                  this.dragItem = '';
                  this.adjacentItem = '';
                })
                animateTo({
                  curve: curves.interpolatingSpring(20, 1, 200, 20), delay: 150
                }, () => {
                  this.scaleItem = '';
                })
              })
          )
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.transparent'))
      .scrollBarColor('#8d874f')
    }
    .title(PageHead($r('app.string.db_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .width('100%')
    .backgroundImage($r('app.media.bg_2'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundEffect({ radius: 2, color: $r('app.color.background_blur') })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .menus(this.navMenus())
  }
}