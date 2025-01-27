import { PageHead } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import StratagemModel from '../database/model/StratagemModel';
import { fileUri } from '@kit.CoreFileKit';

/**
 * 战备项目
 * @param img 图像资源
 * @param name 名称资源
 */
@Builder
function StratagemItem(img: ResourceStr, name: ResourceStr) {
  ListItem() {
    Column() {
      Image(img)
        .height(70)
        .width(70)
      Text(name)
        .fontFamily('Sinclair')
        .textAlign(TextAlign.Center)
    }
  }
  .width('100')
  .backgroundColor('#555555')
}

@Component
export struct ListPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State dbList: DatabaseModel[] = []
  @State stratagemList: Array<StratagemModel[]> = []
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  private controller: TabsController = new TabsController()
  @State tabBarWidth: Length = '100%'
  @State Lanes: LengthConstrain = { minLength: 100, maxLength: 100 }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex === index ? $r('app.color.text_hyperlink') : $r('app.color.text_primary'))
        .fontWeight(this.selectedIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .margin({ top: 10, bottom: 10 })
        .textOverflow({ overflow: this.selectedIndex === index ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
        .maxLines(1)
        .textAlign(TextAlign.Center)
      Divider()
        .strokeWidth(2)
        .color($r('app.color.text_hyperlink'))
        .opacity(this.selectedIndex === index ? 1 : 0)
    }
    .width(this.tabBarWidth)
  }

  async aboutToAppear() {
    this.dbList = await DatabaseService.GetDbList();
    for (let i = 0; i < this.dbList.length; i++) {
      if (i == 0) {
        this.stratagemList.push(await DatabaseService.getStratagemList(this.dbList[0].id));
      } else {
        this.stratagemList.push([]);
      }
    }
    this.tabBarWidth = this.dbList.length > 1 ? '62%' : '100%';
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        ForEach(this.dbList, (dbItem: DatabaseModel, dbIndex: number) => {
          TabContent() {
            List({ space: 5 }) {
              if (this.stratagemList[dbIndex].length != 0) {
                ForEach(this.stratagemList[dbIndex], (sItem: StratagemModel, sIndex: number) => {
                  StratagemItem(fileUri.getUriFromPath(getContext().filesDir + `/${dbItem.id}/${sItem.icon}.svg`),
                    sItem.name)
                })
              } else { // 无战备，显示空
                StratagemItem($r('app.media.ic_question'), $r('app.string.stratagem_empty'))
              }
            }
            .width('100%')
            .height('100%')
            .lanes(this.Lanes)
            .alignListItem(ListItemAlign.Center)
          }
          .tabBar(this.tabBuilder(dbIndex, i18n.System.getSystemLanguage() == 'zh-Hans' ? dbItem.nameZh : dbItem.name))
        })
      }
      .vertical(false)
      .barMode(BarMode.Scrollable)
      .barWidth('100%')
      .animationDuration(400)
      .onChange(async (index: number) => {
        this.currentIndex = index;
        this.selectedIndex = index;
        if (this.stratagemList[index].length == 0) {
          this.stratagemList[index] = await DatabaseService.getStratagemList(this.dbList[index].id);
        }
      })
      .onAnimationStart((index: number, targetIndex: number, _event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return
        }
        this.selectedIndex = targetIndex
      })
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .title(PageHead($r('app.string.list_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .backgroundColor($r('app.color.background_secondary'))
    .menus([
      {
        value: '',
        icon: 'resources/base/media/ic_sync.svg',
        action: () => {
        }
      },
      {
        value: '',
        icon: 'resources/base/media/ic_add.svg',
        action: () => {
        }
      }
    ])
  }
}