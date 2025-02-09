import { AlignBottomRight, AlignTop, AppButton, PageHead } from "../common/UiUtils";
import { DatabasePage } from "./DatabasePage";
import { EditPage } from "./EditPage";
import { ListPage } from "./ListPage";
import { SettingsPage } from "./SettingsPage";

@Entry
@Component
struct RootPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === "SettingsPage") {
      SettingsPage()
    } else if (name === "DatabasePage") {
      DatabasePage()
    } else if (name === "ListPage") {
      ListPage()
    } else if (name === "EditPage") {
      EditPage()
    }
  }

  /**
   * 导航菜单
   */
  @Builder
  navMenus() {
    Row({ space: 5 }) {
      // 战备列表页面
      AppButton({
        click: () => {
          this.pageInfos.pushPath({ name: "ListPage" });
        }
      }) {
        Image($r('app.media.ic_list'))
          .width(20)
          .height(20)
      }

      // 设置页面
      AppButton({
        click: () => {
          this.pageInfos.pushPath({ name: "SettingsPage" });
        }
      }) {
        Image($r('app.media.ic_settings'))
          .width(20)
          .height(20)
      }
    }
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .margin({ right: 10 })
  }

  build() {
    Navigation(this.pageInfos) {
      RelativeContainer() {
        List({ space: 12 }) {
          ListItem() {
            Text("Page")
              .width("100%")
              .height(72)
              .backgroundColor($r('app.color.background_secondary'))
              .borderWidth(2)
              .borderColor($r('app.color.border'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }.onClick(() => {
            this.pageInfos.pushPath({ name: "EditPage", param: false });
          })
        }
        .alignRules(AlignTop)
        .width("100%")
        .height("100%")

        AppButton({
          rules: AlignBottomRight, marginValue: 10, click: () => {
            this.pageInfos.pushPath({ name: "EditPage", param: true });
          }
        }) {
          Image($r('app.media.ic_add'))
            .width(40)
            .height(40)
        }
      }
      .width("100%")
      .height("100%")
      .padding('10')
      .backgroundColor($r('app.color.transparent'))
    }
    .title(PageHead($r('app.string.HD2CFSAbility_label')))
    .menus(this.navMenus)
    .backgroundColor($r('app.color.background_primary'))
    .backgroundImage($r('app.media.bg_1'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundEffect({ radius: 2, color: $r('app.color.background_blur') })
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
    .titleMode(NavigationTitleMode.Mini)
    .hideToolBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}