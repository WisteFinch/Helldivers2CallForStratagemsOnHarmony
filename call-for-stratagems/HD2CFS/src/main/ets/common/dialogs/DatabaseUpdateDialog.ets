import DatabaseService from '../../database/DatabaseService'
import DatabaseModel from '../../database/model/DatabaseModel'
import StratagemModel from '../../database/model/StratagemModel'
import { downloadToFileDir, fetchData } from '../HttpUtils'
import { AppButton } from '../UiUtils'

enum UpdateStage {
  Idle,
  DownloadingIndex,
  Latest,
  DownloadingDb,
  DownloadingImg,
  Done,
  Err,
}

enum UpdateErr {
  Err,
  DownloadIndexErr,
  ParseIndexErr,
  DownloadDbErr,
  ParseDbErr,
  DownloadImgErr,
  ParseStratagemErr
}

class TaskItem {
  url: string
  stage: UpdateStage = UpdateStage.Idle
  index: number = 0
  count: number = 0
  txt: string = ''
  err: string = ''

  constructor(url: string) {
    this.url = url;
  }
}

@CustomDialog
export struct DatabaseUpdateDialog {
  controller: CustomDialogController
  confirm: () => void = () => {
  }
  @Prop tasks: string[]
  @State _tasks: TaskItem[] = []
  @State taskIndex: number = 0
  @State finished: boolean = false
  cancel: boolean = false

  /**
   * 更新数据库
   */
  async update() {
    for (this.taskIndex = 0; this.taskIndex < this.tasks.length; this.taskIndex++) {
      try {
        let baseUrl = this._tasks[this.taskIndex].url;
        if (baseUrl.slice(baseUrl.length - 1) != '/' && baseUrl.slice(baseUrl.length - 1) != '\\') {
          baseUrl = baseUrl + '/';
        }

        // 获取索引信息
        if (this.cancel) {
          return;
        }
        this._tasks[this.taskIndex].stage = UpdateStage.DownloadingIndex;
        this._tasks[this.taskIndex].txt = baseUrl;
        this._tasks = [...this._tasks];
        let indexRes: string;
        try {
          indexRes = await fetchData(baseUrl + 'index.json');
        } catch (_err) {
          throw new Error(UpdateErr.DownloadIndexErr.toString());
        }
        // 解析索引信息
        if (this.cancel) {
          return;
        }
        let indexJson: object;
        try {
          indexJson = JSON.parse(indexRes);
        } catch (_err) {
          throw new Error(UpdateErr.ParseIndexErr.toString());
        }
        const date: string = indexJson['date'];
        const dbUrl: string = baseUrl + indexJson['db_path'];
        const iconUrl: string = baseUrl + indexJson['icons_path'];
        const dbId: string = indexJson['name'];
        const dbName: string = indexJson['nameEn'];
        const dbNameZh: string = indexJson['nameZh'];
        if (dbId == undefined) {
          throw new Error(UpdateErr.ParseIndexErr.toString());
        }
        let oldDb = await DatabaseService.GetDb(dbId);
        if (oldDb.id == dbId && oldDb.ver == date) {
          this._tasks[this.taskIndex].stage = UpdateStage.Latest;
          this._tasks[this.taskIndex].txt = dbId;
          this._tasks[this.taskIndex].index = this._tasks[this.taskIndex].count = 1;
          this._tasks = [...this._tasks];
          continue;
        }
        let count = await DatabaseService.getDbCount();
        DatabaseService.deleteStratagems(dbId);
        await DatabaseService.addDb(new DatabaseModel(dbId, dbName, dbNameZh, baseUrl, 'null', count));

        // 获取数据库信息
        if (this.cancel) {
          return;
        }
        this._tasks[this.taskIndex].stage = UpdateStage.DownloadingDb;
        this._tasks[this.taskIndex].txt = dbUrl;
        this._tasks = [...this._tasks];
        let dbRes: string;
        try {
          dbRes = await fetchData(dbUrl);
        } catch (_err) {
          throw new Error(UpdateErr.DownloadDbErr.toString());
        }
        // 解析数据库信息
        if (this.cancel) {
          return;
        }
        let dbObjs: object[];
        try {
          dbObjs = JSON.parse(dbRes)['objects'][0]['rows'];
        } catch (_err) {
          throw new Error(UpdateErr.ParseDbErr.toString());
        }
        if (dbObjs == undefined) {
          throw new Error(UpdateErr.ParseDbErr.toString());
        }
        this._tasks[this.taskIndex].count = dbObjs.length

        // 解析战备信息
        this._tasks[this.taskIndex].stage = UpdateStage.DownloadingImg;
        this._tasks = [...this._tasks];
        for (this._tasks[this.taskIndex].index = 0; this._tasks[this.taskIndex].index < this._tasks[this.taskIndex].count;
          this._tasks[this.taskIndex].index++) {
          if (this.cancel) {
            return;
          }
          const row = dbObjs[this._tasks[this.taskIndex].index];
          let stratagem: StratagemModel;
          try {
            this._tasks[this.taskIndex].txt = row[1];
            stratagem = new StratagemModel(row[0],
              dbId,
              row[1],
              row[2],
              row[3],
              JSON.parse(row[4]));
          } catch (_err) {
            throw new Error(UpdateErr.ParseStratagemErr.toString());
          }
          this._tasks[this.taskIndex].txt = `${iconUrl}${stratagem.icon}.svg`;
          this._tasks = [...this._tasks];
          // 下载图像资源
          let res =
            await downloadToFileDir(`${iconUrl}${stratagem.icon}.svg`, `/${dbId}/`, `/${dbId}/${stratagem.icon}.svg`);
          if (!res) {
            throw new Error(UpdateErr.DownloadImgErr.toString());;
          }
          await DatabaseService.addStratagem(stratagem);
        }
        // 更新数据库
        if (this.cancel) {
          return;
        }
        await DatabaseService.addDb(new DatabaseModel(dbId, dbName, dbNameZh, baseUrl, date, count));
        this._tasks[this.taskIndex].stage = UpdateStage.Done;
        this._tasks[this.taskIndex].index = this._tasks[this.taskIndex].count = 1;
        this._tasks[this.taskIndex].txt = dbId;
        this._tasks = [...this._tasks];
      } catch (err) {
        this._tasks[this.taskIndex].stage = UpdateStage.Err;
        if (err == Error) {
          this._tasks[this.taskIndex].err = (err as Error).message;
        } else {
          this._tasks[this.taskIndex].err = UpdateErr.Err.toString()
        }
        this._tasks = [...this._tasks];
      }
    }
    this.finished = true;
  }

  aboutToAppear() {
    for (let i = 0; i < this.tasks.length; i++) {
      this._tasks.push(new TaskItem(this.tasks[i]))
    }
    this.update()
  }

  aboutToDisappear(): void {
    this.cancel = true;
    this.confirm();
  }

  build() {
    Column() {
      Column() {
        // 标题
        Text($r('app.string.db_updt_title'))
          .margin(10)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_stress'))
          .fontFamily('Sinclair')

        Text()
          .width('100%')
          .height(10)
          .backgroundColor($r('app.color.transparent'))
          .backgroundImage($r('app.media.stripes'))
          .backgroundImageSize(ImageSize.Cover)

        // 进度
        Column({ space: 10 }) {
          // 总进度
          Column() {
            Text($r('app.string.db_updt_task', this.taskIndex.toString(), this._tasks.length.toString()))
              .fontColor($r('app.color.text_primary'))
              .fontFamily('Sinclair')
            Progress({ value: this.taskIndex, total: this._tasks.length })
              .color($r('app.color.highlight'))
              .borderRadius(0)
              .style({strokeRadius: 0, strokeWidth: 5})
          }
          .alignItems(HorizontalAlign.Start)

          // 子条目
          ForEach(this.tasks, (_i: string, index: number) => {
            Column() {
              if (this._tasks[index].stage == UpdateStage.Idle) {
                Text($r('app.string.db_updt_idle', this._tasks[index].url))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.DownloadingIndex) {
                Text($r('app.string.db_updt_dl_idx', this._tasks[index].txt))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.Latest) {
                Text($r('app.string.db_updt_latest', this._tasks[index].txt))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.DownloadingDb) {
                Text($r('app.string.db_updt_dl_db', this._tasks[index].txt))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.DownloadingImg) {
                Text($r('app.string.db_updt_dl_img', this._tasks[index].index.toString(),
                  this._tasks[index].count.toString(), this._tasks[index].txt))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.Done) {
                Text($r('app.string.db_updt_done', this._tasks[index].txt))
                  .fontColor($r('app.color.text_primary'))
                  .fontFamily('Sinclair')
              } else if (this._tasks[index].stage == UpdateStage.Err) {
                if (this._tasks[index].err == UpdateErr.DownloadIndexErr.toString()) {
                  Text($r('app.string.db_updt_err_dl_idx', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else if (this._tasks[index].err == UpdateErr.ParseIndexErr.toString()) {
                  Text($r('app.string.db_updt_err_parse_idx', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else if (this._tasks[index].err == UpdateErr.DownloadDbErr.toString()) {
                  Text($r('app.string.db_updt_err_dl_db', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else if (this._tasks[index].err == UpdateErr.ParseDbErr.toString()) {
                  Text($r('app.string.db_updt_err_parse_db', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else if (this._tasks[index].err == UpdateErr.DownloadImgErr.toString()) {
                  Text($r('app.string.db_updt_err_dl_img', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else if (this._tasks[index].err == UpdateErr.ParseStratagemErr.toString()) {
                  Text($r('app.string.db_updt_err_parse_stratagem', this._tasks[index].txt))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                } else {
                  Text($r('app.string.db_updt_err', this._tasks[index].url))
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('Sinclair')
                }
              }
              Progress({ value: this._tasks[index].index, total: this._tasks[index].count })
                .color($r('app.color.highlight'))
                .borderRadius(0)
                .style({strokeRadius: 0, strokeWidth: 5})
            }
            .alignItems(HorizontalAlign.Start)
          })
        }
        .width('100%')
        .margin({
          top: 20,
          bottom: 10
        })
        .padding({left:10, right: 10})

        // 按钮
        Row({ space: 20 }) {
          if (this.finished) { // 更新完成
            AppButton({
              weight: 1, click: () => {
                this.controller.close();
              }
            }) {
              Text($r('app.string.dialog_accept'))
                .width('100%')
                .fontColor($r('app.color.button_text'))
                .fontFamily('Sinclair')
                .textAlign(TextAlign.Center)
            }
          } else { // 取消更新
            AppButton({weight: 1, click: () => {
              this.controller.close();
            }}) {
              Text($r('app.string.dialog_cancel'))
                .width('100%')
                .fontColor($r('app.color.button_text_alert'))
                .fontFamily('Sinclair')
                .textAlign(TextAlign.Center)
            }
          }
        }
        .margin(10)
        .height(40)
      }
      .margin(5)
      .backgroundColor($r('app.color.background_primary'))
    }
    .margin({ left: 10, right: 10, bottom: 20 })
    .borderColor($r('app.color.border_highlight'))
    .borderWidth(2)
    .backgroundColor($r('app.color.transparent'))
  }
}