import { DatabaseDao } from './dao/DatabaseDao'
import { GroupDao } from './dao/GroupDao'
import { GroupStratagemsDao } from './dao/GroupStratagemsDao'
import { StratagemDao } from './dao/StratagemDao'
import DatabaseModel from './model/DatabaseModel'
import StratagemModel from './model/StratagemModel'

/**
 * 数据库服务
 */
class DatabaseService {
  // 数据访问层
  private groupDao: GroupDao = new GroupDao()
  private stratagemDao: StratagemDao = new StratagemDao()
  private groupStratagemsDao: GroupStratagemsDao = new GroupStratagemsDao()
  private databaseDao: DatabaseDao = new DatabaseDao()

  initDBService(context: Context) {
    // 初始化数据访问层
    this.groupDao.init(context);
    this.stratagemDao.init(context);
    this.groupStratagemsDao.init(context);
    this.databaseDao.init(context);
  }

  async GetDbList(): Promise<DatabaseModel[]> {
    return await this.databaseDao.getDBList();
  }

  async addDb(db: DatabaseModel) {
    let value = await this.databaseDao.existDb(db.id);
    if (value) {
      this.databaseDao.updateDb(db);
    }
    else {
      this.databaseDao.addDb(db);
    }
  }

  async addStratagem(stratagem: StratagemModel) {
    let value = await this.stratagemDao.existStratagem(stratagem.id, stratagem.dbId);
    if (value) {
      this.stratagemDao.updateStratagem(stratagem);
    }
    else {
      this.stratagemDao.addStratagem(stratagem);
    }
  }
}

let databaseService = new DatabaseService()

export default databaseService as DatabaseService