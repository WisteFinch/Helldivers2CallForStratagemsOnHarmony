import { PageHead } from '../common/UiUtils';

@Component
export struct EditPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  /**
   * 是否为新增战备组
   */
  @State isNewGroup: boolean = false;

  aboutToAppear(): void {
    this.isNewGroup = this.pageInfos.getParamByIndex(0) as boolean;
  }

  build() {
    NavDestination() {
      Column() {

      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.transparent'))
    }
    .title(PageHead(this.isNewGroup ? $r('app.string.edit_page_title_add') : $r('app.string.edit_page_title')))
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