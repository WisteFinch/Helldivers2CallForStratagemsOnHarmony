import { DatabaseDao } from './dao/DatabaseDao'
import { GroupDao } from './dao/GroupDao'
import { GroupStratagemsDao } from './dao/GroupStratagemsDao'
import { StratagemDao } from './dao/StratagemDao'

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
    this.groupDao.init(context)
    this.stratagemDao.init(context)
    this.groupStratagemsDao.init(context)
    this.databaseDao.init(context)
  }
}

let databaseService = new DatabaseService()

export default databaseService as DatabaseService