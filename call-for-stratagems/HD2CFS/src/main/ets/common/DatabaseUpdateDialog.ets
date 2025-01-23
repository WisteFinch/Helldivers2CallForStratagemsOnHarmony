import DatabaseService from "../database/DatabaseService"
import DatabaseModel from "../database/model/DatabaseModel"
import StratagemModel from "../database/model/StratagemModel"
import { downloadToFileDir, fetchData } from "./HttpUtils"

enum UpdateStage {
  Idle,
  DownloadingIndex,
  DownloadingDb,
  DownloadingImg,
  Done,
  Err,
}

enum UpdateErr {
  DownloadIndexErr,
  ParseIndexErr,
  DownloadDbErr,
  ParseDbErr,
  DownloadImgErr
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
  confirm: (value: string) => void = () => {
  }
  title: ResourceStr = $r('app.string.db_updt_title')
  @Link tasks: string[]
  @State _tasks: TaskItem[] = []
  @State taskIndex: number = 0
  @State finished: boolean = false

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
        this._tasks[this.taskIndex].stage = UpdateStage.DownloadingIndex;
        this._tasks[this.taskIndex].txt = baseUrl;
        this._tasks = [...this._tasks];
        let indexRes: string;
        try {
          indexRes = await fetchData(this.tasks[this.taskIndex]);
        } catch (_err) {
          throw new Error(UpdateErr.DownloadIndexErr.toString());
        }
        // 解析索引信息
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
        await DatabaseService.addDb(new DatabaseModel(dbId, dbName, dbNameZh, baseUrl, '0'));

        // 获取数据库信息
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
          const row = dbObjs[this._tasks[this.taskIndex].index];
          const stratagem: StratagemModel = new StratagemModel(row[0],
            dbId,
            row[1],
            row[2],
            row[3],
            JSON.parse(row[4])); /*TODO: 解析错误检查*/
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
        await DatabaseService.addDb(new DatabaseModel(dbId, dbName, dbNameZh, baseUrl, date));
        this._tasks[this.taskIndex].stage = UpdateStage.Done;
        this._tasks[this.taskIndex].txt = dbId;
        this._tasks = [...this._tasks];
      } catch (err) {
        this._tasks[this.taskIndex].stage = UpdateStage.Err;
        this._tasks[this.taskIndex].err = (err as Error).message;
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

  build() {
    Column({ space: 20 }) {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
      Column() {
        Text($r('app.string.db_updt_task', this.taskIndex.toString(), this._tasks.length.toString()))
        Progress({ value: this.taskIndex, total: this._tasks.length })
      }
      .alignItems(HorizontalAlign.Start)

      ForEach(this.tasks, (_i: string, index: number) => {
        Column() {
          if (this._tasks[index].stage == UpdateStage.Idle) {
            Text($r('app.string.db_updt_idle', this._tasks[index].url))
          } else if (this._tasks[index].stage == UpdateStage.DownloadingIndex) {
            Text($r('app.string.db_updt_dl_idx', this._tasks[index].txt))
          } else if (this._tasks[index].stage == UpdateStage.DownloadingDb) {
            Text($r('app.string.db_updt_dl_db', this._tasks[index].txt))
          } else if (this._tasks[index].stage == UpdateStage.DownloadingImg) {
            Text($r('app.string.db_updt_dl_img', this._tasks[index].index.toString(),
              this._tasks[index].count.toString(), this._tasks[index].txt))
          } else if (this._tasks[index].stage == UpdateStage.Done) {
            Text($r('app.string.db_updt_done', this._tasks[index].txt))
          } else if (this._tasks[index].stage == UpdateStage.Err) {
            if (this._tasks[index].err == UpdateErr.DownloadIndexErr.toString()) {
              Text($r('app.string.db_updt_err_dl_idx', this._tasks[index].txt))
            } else if (this._tasks[index].err == UpdateErr.ParseIndexErr.toString()) {
              Text($r('app.string.db_updt_err_parse_idx', this._tasks[index].txt))
            } else if (this._tasks[index].err == UpdateErr.DownloadDbErr.toString()) {
              Text($r('app.string.db_updt_err_dl_db', this._tasks[index].txt))
            } else if (this._tasks[index].err == UpdateErr.ParseDbErr.toString()) {
              Text($r('app.string.db_updt_err_parse_db', this._tasks[index].txt))
            } else if (this._tasks[index].err == UpdateErr.DownloadImgErr.toString()) {
              Text($r('app.string.db_updt_err_dl_img', this._tasks[index].txt))
            }
          }
          Progress({ value: this._tasks[index].index, total: this._tasks[index].count })
        }
        .alignItems(HorizontalAlign.Start)
      })
      Row({ space: 20 }) {
        if (this.finished) { // 更新完成
          Button($r('app.string.dialog_accept'))
            .onClick(() => {
              this.controller.close()
            })
            .fontColor($r('app.color.button_text'))
            .backgroundColor($r('app.color.button_background'))
            .layoutWeight(1)
        } else { // 取消更新
          Button($r('app.string.dialog_cancel'))
            .onClick(() => {
              /*TODO: 取消更新*/
              this.controller.close()
            })
            .fontColor($r('app.color.button_text'))
            .backgroundColor($r('app.color.button_background'))
            .layoutWeight(1)
        }
      }
      .height(40)
    }
    .padding(20)
  }
}