import { DatabaseUpdateDialog } from "../common/DatabaseUpdateDialog";
import { PageHead, TextInputDialog } from "../common/UiUtils";
import DatabaseService from "../database/DatabaseService";
import DatabaseModel from "../database/model/DatabaseModel";

@Component
export struct DatabasePage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State list: DatabaseModel[] = []
  @State addList: string[] = []

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

  aboutToAppear() {
    DatabaseService.GetDbList().then((value) => {
      this.list = value;
    })
  }

  build() {
    NavDestination() {
      List({ space: 20 }) {
        ForEach(this.list, (item: DatabaseModel) => {
          ListItem() {
            Text(item.id)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        })
      }
      .width("100%")
      .height("100%")
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
        value: "",
        icon: "resources/base/media/ic_sync.svg",
        action: ()=> {

        }
      },
      {
        value: "",
        icon: 'resources/base/media/ic_add.svg',
        action: ()=> {
          this.addDbDialog.open();
        }
      }
    ])
  }
}