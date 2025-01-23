import { preferences } from '@kit.ArkData'
import { Context } from '@ohos.arkui.UIContext'
import { PREFERENCES_FILE_NAME } from './Constants'

class PreferencesUtil {
  pref: preferences.Preferences | null = null

  /**
   * 加载首选项
   * @param context
   */
  loadPreference(context: Context) {
    let name = PREFERENCES_FILE_NAME;
    this.pref = preferences.getPreferencesSync(context, { name });
  }

  /**
   * 存储首选项
   * @param key 键
   * @param value 值
   */
  putVal(key: string, value: preferences.ValueType) {
    this.pref?.putSync(key, value);
    this.pref?.flush();
  }

  /**
   * 获取首选项
   * @param key 键
   * @param defaultVal 默认值
   * @returns 值
   */
  getVal(key: string, defaultVal: preferences.ValueType): preferences.ValueType {
    try {
      if (this.pref == null) {
        return defaultVal;
      }
      return this.pref.getSync(key, defaultVal);
    }catch (e){
      return defaultVal;
    }
  }
}

export default new PreferencesUtil()