import { PageHead } from '../common/UiUtils';
import { curves } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

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

  @State private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State dragItem: number = -1
  @State scaleItem: number = -1
  @State neighborItem: number = -1
  @State neighborScale: number = -1
  private dragRefOffset: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  private ITEM_INTV: number = 120

  scaleSelect(item: number): number {
    if (this.scaleItem === item) {
      return 1.05
    } else if (this.neighborItem === item) {
      return this.neighborScale
    } else {
      return 1
    }
  }

  itemMove(index: number, newIndex: number): void {
    let tmp = this.arr.splice(index, 1)
    this.arr.splice(newIndex, 0, tmp[0])
  }

  build() {
    NavDestination() {
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