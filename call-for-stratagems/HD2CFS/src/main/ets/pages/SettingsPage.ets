import {
  INPUT_OPTIONS,
  INPUT_TYPE_OPTIONS,
  LANGUAGE_OPTIONS,
  PREFERENCES_DELAY,
  PREFERENCES_INPUT_DOWN,
  PREFERENCES_INPUT_DOWN_DSP,
  PREFERENCES_INPUT_LEFT,
  PREFERENCES_INPUT_LEFT_DSP,
  PREFERENCES_INPUT_OPEN,
  PREFERENCES_INPUT_OPEN_DSP,
  PREFERENCES_INPUT_RIGHT,
  PREFERENCES_INPUT_RIGHT_DSP,
  PREFERENCES_INPUT_UP,
  PREFERENCES_INPUT_UP_DSP,
  PREFERENCES_LANG_STRATAGEM,
  PREFERENCES_LANG_STRATAGEM_DSP,
  PREFERENCES_RETRY,
  PREFERENCES_SERVER_ADDR,
  PREFERENCES_SERVER_PORT,
  PREFERENCES_SIMPLIFIED_MODE,
  PREFERENCES_SYNC_PORT,
  PREFERENCES_TYPE_OPEN,
  PREFERENCES_TYPE_OPEN_DSP
} from '../common/Constants';
import PreferencesUtil from '../common/PreferencesUtil';
import { ListItemGroupHead, PageHead } from '../common/UiUtils';

/**
 * 下拉菜单
 * @param opts 选项数组
 * @param key 键
 * @param defaultVal 默认值
 * @param dsp 显示键
 * @param defaultDsp 默认显示
 */
@Builder
function SettingSelect(opts: SelectOption[], key: string, defaultVal: number, dsp: string, defaultDsp: string) {
  Select(opts)
    .font({ family: 'Sinclair' })
    .optionFont({ family: 'Sinclair' })
    .selectedOptionFontColor($r("app.color.text_stress"))
    .selectedOptionFont({ weight: FontWeight.Bold, family: 'Sinclair' })
    .menuBackgroundColor($r('app.color.background_secondary'))
    .selectedOptionBgColor($r('app.color.stress'))
    .backgroundColor($r('app.color.background_secondary'))
    .borderRadius(0)
    .layoutWeight(1)
    .selected(Number(PreferencesUtil.getVal(key, defaultVal)))
    .value(PreferencesUtil.getVal(dsp, defaultDsp).toString())
    .onSelect((index: number, value: string) => {
      PreferencesUtil.putVal(key, index);
      PreferencesUtil.putVal(dsp, value);
    })
}

/**
 * 设置页
 */
@Component
export struct SettingsPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      List({ space: 20 }) {
        // 连接
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_conn_hdr')) }) {
          ListItem() {
            List({ space: 5 }) {
              // 服务器地址
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_conn_server'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(1)
                  TextInput({
                    placeholder: $r('app.string.set_conn_addr'),
                    text: PreferencesUtil.getVal(PREFERENCES_SERVER_ADDR, '127.0.0.1').toString()
                  })
                    .caretColor($r('app.color.caret'))
                    .caretColor($r('app.color.caret'))
                    .backgroundColor($r('app.color.background_secondary'))
                    .borderRadius(0)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_SERVER_ADDR, value);
                    })
                  TextInput({
                    placeholder: $r('app.string.set_conn_port'),
                    text: PreferencesUtil.getVal(PREFERENCES_SERVER_PORT, 23333).toString()
                  })
                    .caretColor($r('app.color.caret'))
                    .backgroundColor($r('app.color.background_secondary'))
                    .borderRadius(0)
                    .fontFamily('Sinclair')
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_SERVER_PORT, Number(value));
                    })
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 重试次数
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_conn_retry'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_RETRY, 5).toString()
                  })
                    .caretColor($r('app.color.caret'))
                    .backgroundColor($r('app.color.background_secondary'))
                    .borderRadius(0)
                    .fontFamily('Sinclair')
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_RETRY, Number(value));
                    })
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 扫码&测试连接
              ListItem() {
                Row({ space: 5 }) {
                  // 扫码
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Column({ space: 6 }) {
                      Image($r('app.media.ic_scan'))
                        .width(40)
                        .height(40)
                      Text($r('app.string.set_conn_scan'))
                        .fontColor($r('app.color.text_primary'))
                        .fontWeight(FontWeight.Medium)
                        .fontFamily('Sinclair')
                    }
                    .alignItems(HorizontalAlign.Center)
                  }
                  .height('100%')
                  .backgroundColor($r('app.color.button_background'))
                  .borderColor($r('app.color.border'))
                  .borderWidth(2)
                  .layoutWeight(1)

                  // 测试连接
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Column({ space: 6 }) {
                      Image($r('app.media.ic_sync'))
                        .width(40)
                        .height(40)
                      Text($r('app.string.set_conn_test'))
                        .fontColor($r('app.color.text_primary'))
                        .fontWeight(FontWeight.Medium)
                        .fontFamily('Sinclair')
                    }
                    .alignItems(HorizontalAlign.Center)
                  }
                  .height('100%')
                  .backgroundColor($r('app.color.button_background'))
                  .borderColor($r('app.color.border'))
                  .borderWidth(2)
                  .layoutWeight(1)
                }
                .alignItems(VerticalAlign.Center)
              }
              .height(100)
              .backgroundColor($r('app.color.transparent'))
            }
            .width('100%')
            .height('warp_content')
          }
          .backgroundColor($r('app.color.transparent'))
        }
        .backgroundColor($r('app.color.transparent'))


        // 同步
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_sync_hdr')) }) {
          ListItem() {
            List({ space: 5 }) {
              // 端口
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_port'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_SYNC_PORT, 23333).toString()
                  })
                    .caretColor($r('app.color.caret'))
                    .backgroundColor($r('app.color.background_secondary'))
                    .borderRadius(0)
                    .fontFamily('Sinclair')
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_SYNC_PORT, Number(value));
                    })
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入延迟
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_delay'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_DELAY, 50).toString()
                  })
                    .caretColor($r('app.color.caret'))
                    .backgroundColor($r('app.color.background_secondary'))
                    .borderRadius(0)
                    .fontFamily('Sinclair')
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_DELAY, Number(value));
                    })
                  Text($r('app.string.set_unit_ms'))
                    .fontColor($r('app.color.text_secondary'))
                    .fontFamily('Sinclair')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入：打开战略配备列表
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_input_open'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_OPTIONS, PREFERENCES_INPUT_OPEN, 2, PREFERENCES_INPUT_OPEN_DSP, 'Left Ctrl')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 类型：打开战略配备列表
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_type_open'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_TYPE_OPTIONS, PREFERENCES_TYPE_OPEN, 0, PREFERENCES_TYPE_OPEN_DSP, 'Hold')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入：上
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_input_up'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_OPTIONS, PREFERENCES_INPUT_UP, 42, PREFERENCES_INPUT_UP_DSP, 'W')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入：下
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_input_down'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_OPTIONS, PREFERENCES_INPUT_DOWN, 38, PREFERENCES_INPUT_DOWN_DSP, 'S')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入：左
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_input_left'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_OPTIONS, PREFERENCES_INPUT_LEFT, 20, PREFERENCES_INPUT_LEFT_DSP, 'A')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 输入：右
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_sync_input_right'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(INPUT_OPTIONS, PREFERENCES_INPUT_RIGHT, 23, PREFERENCES_INPUT_RIGHT_DSP, 'D')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 同步配置
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row({ space: 6 }) {
                    Text($r('app.string.set_sync_apply'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('app.color.button_text'))
                      .fontFamily('Sinclair')
                  }
                  .width('100%')
                  .height('100%')
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width('100%')
                .height(50)
                .borderColor($r('app.color.border'))
                .borderWidth(2)
                .padding(5)
                .backgroundColor($r('app.color.background_primary'))
              }
            }
            .width('100%')
            .height('warp_content')
          }
          .backgroundColor($r('app.color.transparent'))
        }
        .backgroundColor($r('app.color.transparent'))

        // 控制
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_ctrl_hdr')) }) {
          ListItem() {
            List({ space: 5 }) {
              // 精简模式
              ListItem() {
                Row() {
                  Column() {
                    Text($r('app.string.set_ctrl_simplified_mode'))
                      .fontColor($r('app.color.text_primary'))
                      .fontWeight(FontWeight.Medium)
                      .fontFamily('Sinclair')
                    Text($r('app.string.set_ctrl_simplified_mode_desc'))
                      .fontColor($r('app.color.text_primary'))
                      .fontColor($r('app.color.text_secondary'))
                      .fontFamily('Sinclair')
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width('80%')

                  Blank()
                  Toggle({
                    type: ToggleType.Switch,
                    isOn: Boolean(PreferencesUtil.getVal(PREFERENCES_SIMPLIFIED_MODE, false))
                  })
                    .selectedColor($r('app.color.stress'))
                    .onChange((isOn: boolean) => {
                      PreferencesUtil.putVal(PREFERENCES_SIMPLIFIED_MODE, isOn);
                    })
                }
                .width('100%')
                .alignItems(VerticalAlign.Center)
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))

              // 语言：战略配备名称
              ListItem() {
                Row({ space: 5 }) {
                  Text($r('app.string.set_ctrl_lang_stratagem'))
                    .fontColor($r('app.color.text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                    .layoutWeight(2)
                  SettingSelect(LANGUAGE_OPTIONS, PREFERENCES_LANG_STRATAGEM, 0, PREFERENCES_LANG_STRATAGEM_DSP,
                    'System Language')
                }
              }
              .padding(5)
              .backgroundColor($r('app.color.background_primary'))
            }
            .width('100%')
            .height('warp_content')
          }
          .backgroundColor($r('app.color.transparent'))
        }
        .backgroundColor($r('app.color.transparent'))

        // 信息
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_info_hdr')) }) {
          ListItem() {
            List({ space: 5 }) {
              // 数据库
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row() {
                    Column() {
                      Text($r('app.string.set_info_db'))
                        .fontColor($r('app.color.button_text'))
                        .fontWeight(FontWeight.Medium)
                        .fontFamily('Sinclair')
                      Text('[hd2_db] 2024-12-26T14:02:42Z')
                        .fontColor($r('app.color.text_secondary'))
                        .fontFamily('Sinclair')
                    }
                    .alignItems(HorizontalAlign.Start)

                    Blank()
                    Text($r('app.string.set_info_latest'))
                      .fontColor($r('app.color.text_secondary'))
                      .fontFamily('Sinclair')
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width('100%')
                .height(50)
                .borderColor($r('app.color.border'))
                .borderWidth(2)
                .padding(5)
                .backgroundColor($r('app.color.background_primary'))
                .onClick(() => {
                  this.pageInfos.pushPath({ name: 'DatabasePage' });
                })
              }

              // 软件
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row() {
                    Column() {
                      Text($r('app.string.set_info_app'))
                        .fontColor($r('app.color.button_text'))
                        .fontWeight(FontWeight.Medium)
                        .fontFamily('Sinclair')
                      Text('v1.0.0')
                        .fontColor($r('app.color.text_secondary'))
                        .fontFamily('Sinclair')
                    }
                    .alignItems(HorizontalAlign.Start)

                    Blank()
                    Text($r('app.string.set_info_latest'))
                      .fontColor($r('app.color.text_secondary'))
                      .fontFamily('Sinclair')
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width('100%')
                .height(50)
                .borderColor($r('app.color.border'))
                .borderWidth(2)
                .padding(5)
                .backgroundColor($r('app.color.background_primary'))
              }

              // 关于
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Text($r('app.string.set_info_about'))
                    .fontColor($r('app.color.button_text'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('Sinclair')
                }
                .align(Alignment.Start)
                .width('100%')
                .height(50)
                .borderColor($r('app.color.border'))
                .borderWidth(2)
                .padding(5)
                .backgroundColor($r('app.color.background_primary'))
              }
            }
            .width('100%')
            .height('warp_content')
          }
          .backgroundColor($r('app.color.transparent'))
        }
        .backgroundColor($r('app.color.transparent'))
      }
      .width('100%')
      .height('100%')
      .padding({top: 10, left: 10, bottom: 10, right: 15})
      .backgroundColor($r('app.color.transparent'))
      .scrollBarColor('#8d874f')
    }
    .title(PageHead($r('app.string.set_page_title')))
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
