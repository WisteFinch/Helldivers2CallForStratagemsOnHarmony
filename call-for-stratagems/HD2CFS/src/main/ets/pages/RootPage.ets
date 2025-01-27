import { DatabaseUpdateDialog } from "../common/DatabaseUpdateDialog";
import { TextInputDialog } from "../common/UiUtils";
import { DatabasePage } from "./DatabasePage";
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
    }
    else if (name === "DatabasePage") {
      DatabasePage()
    }
    else if (name === "ListPage") {
      ListPage()
    }
  }

  build() {
    Column() {
      Navigation(this.pageInfos) {
        List({ space: 12 }) {
          ListItem() {
            Text("Page")
              .width("100%")
              .height(72)
              .backgroundColor($r('app.color.background_primary'))
              .borderRadius(24)
              .fontSize(16)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
        }
        .width("100%")
        .height("100%")
        .padding('10')
        .backgroundColor($r('app.color.background_secondary'))
      }
      .title($r('app.string.HD2CFSAbility_label'))
      .menus([
        {
          value: "",
          icon: "resources/base/media/ic_list.svg",
          action: ()=> {
            this.pageInfos.pushPath({ name: "ListPage"});
          }
        },
        {
          value: "",
          icon: 'resources/base/media/ic_settings.svg',
          action: ()=> {
            this.pageInfos.pushPath({ name: "SettingsPage"});
          }
        }
      ])
      .backgroundColor($r('app.color.background_secondary'))
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(true)
    }
    .height('100%')
    .width('100%')
  }
}