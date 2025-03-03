import { AppTabItem, PageHead } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import StratagemModel from '../database/model/StratagemModel';
import { display } from '@kit.ArkUI';
import { StratagemInfoDialog } from '../common/dialogs/StratagemInfoDialog';
import { StratagemItem } from '../common/StratagemItem';

@Component
export struct ListPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State dbList: DatabaseModel[] = [];
  @State stratagemList: Array<StratagemModel[]> = [];
  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  private controller: TabsController = new TabsController();
  @State tabBarWidth: number = 100;
  @State Lanes: LengthConstrain = { minLength: 90, maxLength: 90 };
  @State curStratagem: StratagemModel = new StratagemModel(0, 'null', 'null', 'null', 'null', []);
  infoDialog: CustomDialogController = new CustomDialogController({
    builder: StratagemInfoDialog({
      stratagem: this.curStratagem
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
    maskColor: $r('app.color.background_blur')
  });

  @Builder
  tabBuilder(index: number, name: string) {
    AppTabItem({
      index: index,
      name: name,
      selectedIndex: this.selectedIndex,
      tabBarWidth: this.tabBarWidth
    })
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
    let dsp = display.getDefaultDisplaySync();
    this.tabBarWidth = px2vp(this.dbList.length > 1 ? dsp.width * 0.62 : dsp.width);
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        ForEach(this.dbList, (dbItem: DatabaseModel, dbIndex: number) => {
          TabContent() {
            List({ space: 10 }) {
              if (this.stratagemList.length > dbIndex && this.stratagemList[dbIndex].length != 0) {
                ForEach(this.stratagemList[dbIndex], (sItem: StratagemModel) => {
                  StratagemItem({
                    stratagem: sItem, click: (s: StratagemModel) => {
                      this.curStratagem = s;
                      this.infoDialog.open();
                    }
                  })
                })
              } else { // 无战备，显示空
                ListItem() {
                  Column() {
                    Image($r('app.media.ic_super_earth'))
                      .fillColor($r('app.color.text_secondary'))
                    Text($r('app.string.stratagem_empty'))
                      .fontColor($r('app.color.text_secondary'))
                      .fontWeight(FontWeight.Medium)
                      .fontFamily('Sinclair')
                  }
                  .width('60%')
                  .alignItems(HorizontalAlign.Center)
                }
              }
            }
            .width('100%')
            .height('100%')
            .lanes(this.stratagemList.length > dbIndex && this.stratagemList[dbIndex].length == 0 ? 1 : this.Lanes)
            .scrollBarColor('#8d874f')
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
      .backgroundColor($r('app.color.transparent'))
    }
    .title(PageHead($r('app.string.list_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .backgroundImage($r('app.media.bg_3'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundEffect({ radius: 2, color: $r('app.color.background_blur') })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}