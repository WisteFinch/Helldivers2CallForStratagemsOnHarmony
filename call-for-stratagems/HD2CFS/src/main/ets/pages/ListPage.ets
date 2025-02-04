import { AlignBottom, AlignCenter, AlignTop, alignTopLeft, alignTopRight, PageHead } from '../common/UiUtils';
import DatabaseService from '../database/DatabaseService';
import DatabaseModel from '../database/model/DatabaseModel';
import { i18n } from '@kit.LocalizationKit';
import StratagemModel from '../database/model/StratagemModel';
import { display } from '@kit.ArkUI';
import { StratagemInfoDialog } from '../common/StratagemInfoDialog';
import { fileUri } from '@kit.CoreFileKit';

@Component
export struct ListPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State dbList: DatabaseModel[] = []
  @State stratagemList: Array<StratagemModel[]> = []
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  private controller: TabsController = new TabsController()
  @State tabBarWidth: number = 100
  @State Lanes: LengthConstrain = { minLength: 90, maxLength: 90 }
  @State curStratagem: StratagemModel = new StratagemModel(0, 'null', 'null', 'null', 'null', [])

  infoDialog: CustomDialogController = new CustomDialogController({
    builder: StratagemInfoDialog({
      stratagem: this.curStratagem
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
    maskColor: $r('app.color.background_blur')
  })

  @Builder
  tabBuilder(index: number, name: string) {
    RelativeContainer() {
      Text(name)
        .fontColor(this.selectedIndex === index ? $r("app.color.text_stress") : $r('app.color.text_primary'))
        .fontWeight(this.selectedIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .fontFamily('Sinclair')
        .textOverflow({ overflow: this.selectedIndex === index ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
        .maxLines(1)
        .textAlign(TextAlign.Start)
        .width('100%')
        .height(30)
        .padding({ left: 10, right: 10 })
        .alignRules(AlignTop)
        .id('tabTxt')
      Text((index + 1).toString())
        .fontColor(this.selectedIndex === index ? $r("app.color.text_stress") : $r('app.color.text_primary'))
        .fontWeight(this.selectedIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .fontFamily('Sinclair')
        .textAlign(TextAlign.Center)
        .width('fir_content')
        .height(20)
        .alignRules(alignTopRight)
        .offset({ top: 27, right: 35 })
      Text()
        .width(this.tabBarWidth - 50)
        .height(this.selectedIndex === index ? 45 : 35)
        .outlineWidth({ left: 2, bottom: 2 })
        .outlineColor(this.selectedIndex === index ? $r('app.color.border_highlight') : $r('app.color.border'))
        .alignRules(alignTopLeft)
      Text()
        .width(30)
        .height(this.selectedIndex === index ? 45 : 35)
        .outlineWidth({ right: 2, bottom: 2 })
        .outlineColor(this.selectedIndex === index ? $r('app.color.border_highlight') : $r('app.color.border'))
        .alignRules(alignTopRight)
      if (this.selectedIndex === index) {
        Image($r('app.media.slash'))
          .width(this.tabBarWidth - 50)
          .height(10)
          .padding({ left: 5 })
          .alignRules(alignTopLeft)
          .offset({ top: 30 })
        Image($r('app.media.slash'))
          .width(30)
          .height(10)
          .padding({ right: 5 })
          .alignRules(alignTopRight)
          .offset({ top: 30 })
      }
    }
    .width(this.tabBarWidth)
    .height(50)
    .margin({ left: 5, right: 5 })
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

  /**
   * 战备项目
   * @param img 图像资源
   * @param name 名称资源
   */
  @Builder StratagemItem(s: StratagemModel) {
  ListItem() {
    RelativeContainer() {
      Image(fileUri.getUriFromPath(getContext().filesDir + `/${s.dbId}/${s.icon}.svg`))
        .margin(5)
        .padding(5)
        .alignRules(AlignCenter)
        .backgroundColor($r('app.color.background_tertiary'))
        .draggable(false)
      Text()
        .borderWidth({ top: 2, left: 2, right: 2 })
        .width('100%')
        .height('40%')
        .borderColor($r('app.color.border'))
        .alignRules(AlignTop)
      Text()
        .borderWidth({ bottom: 2, left: 2, right: 2 })
        .width('100%')
        .height('40%')
        .borderColor($r('app.color.border'))
        .alignRules(AlignBottom)
    }
    .width('100%')
    .height('100%')
  }
  .width('85')
  .height('85')
  .gesture(LongPressGesture({repeat: false})
    .onAction((_e: GestureEvent) => {
      this.curStratagem = s;
      this.infoDialog.open();
    }))
}

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        ForEach(this.dbList, (dbItem: DatabaseModel, dbIndex: number) => {
          TabContent() {
            List({ space: 5 }) {
              if (this.stratagemList[dbIndex].length != 0) {
                ForEach(this.stratagemList[dbIndex], (sItem: StratagemModel) => {
                  this.StratagemItem(sItem)
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
            .lanes(this.stratagemList[dbIndex].length == 0 ? 1 : this.Lanes)
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
    .backgroundImage($r('app.media.bg_2'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundEffect({ radius: 2, color: $r('app.color.background_blur') })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}