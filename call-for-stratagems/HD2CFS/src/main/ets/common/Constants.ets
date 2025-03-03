export const PREFERENCES_FILE_NAME: string = 'preferences'
export const PREFERENCES_SERVER_ADDR: string = 'server_addr'
export const PREFERENCES_SERVER_PORT: string = 'server_port'
export const PREFERENCES_RETRY: string = 'retry'
export const PREFERENCES_SYNC_PORT: string = 'sync_port'
export const PREFERENCES_DELAY: string = 'delay'
export const PREFERENCES_INPUT_OPEN: string = 'input_open'
export const PREFERENCES_INPUT_OPEN_DSP: string = 'input_open_dsp'
export const PREFERENCES_TYPE_OPEN: string = 'type_open'
export const PREFERENCES_TYPE_OPEN_DSP: string = 'type_open_dsp'
export const PREFERENCES_INPUT_UP: string = 'input_up'
export const PREFERENCES_INPUT_UP_DSP: string = 'input_up_dsp'
export const PREFERENCES_INPUT_DOWN: string = 'input_down'
export const PREFERENCES_INPUT_DOWN_DSP: string = 'input_down_dsp'
export const PREFERENCES_INPUT_LEFT: string = 'input_left'
export const PREFERENCES_INPUT_LEFT_DSP: string = 'input_left_dsp'
export const PREFERENCES_INPUT_RIGHT: string = 'input_right'
export const PREFERENCES_INPUT_RIGHT_DSP: string = 'input_right_dsp'
export const PREFERENCES_SIMPLIFIED_MODE: string = 'simplified_mode'
export const PREFERENCES_FASTBOOT_MODE: string = 'fastboot_mode'
export const PREFERENCES_SFX: string = 'sfx'
export const PREFERENCES_VIBRATOR: string = 'vibrator'
export const PREFERENCES_LANG_STRATAGEM: string = 'lang_stratagem'
export const PREFERENCES_LANG_STRATAGEM_DSP: string = 'lang_stratagem_dsp'

export const DATABASE_NAME: string = 'app_database.db'

export const INPUT_OPTIONS: SelectOption[] = [
  {value: $r('app.string.opt_in_alt')},
  {value: $r('app.string.opt_in_alt_gr')},
  {value: $r('app.string.opt_in_ctrl_left')},
  {value: $r('app.string.opt_in_ctrl_right')},
  {value: $r('app.string.opt_in_shift_left')},
  {value: $r('app.string.opt_in_shift_right')},
  {value: $r('app.string.opt_in_up')},
  {value: $r('app.string.opt_in_down')},
  {value: $r('app.string.opt_in_left')},
  {value: $r('app.string.opt_in_right')},
  {value: $r('app.string.opt_in_1')},
  {value: $r('app.string.opt_in_2')},
  {value: $r('app.string.opt_in_3')},
  {value: $r('app.string.opt_in_4')},
  {value: $r('app.string.opt_in_5')},
  {value: $r('app.string.opt_in_6')},
  {value: $r('app.string.opt_in_7')},
  {value: $r('app.string.opt_in_8')},
  {value: $r('app.string.opt_in_9')},
  {value: $r('app.string.opt_in_0')},
  {value: $r('app.string.opt_in_a')},
  {value: $r('app.string.opt_in_b')},
  {value: $r('app.string.opt_in_c')},
  {value: $r('app.string.opt_in_d')},
  {value: $r('app.string.opt_in_e')},
  {value: $r('app.string.opt_in_f')},
  {value: $r('app.string.opt_in_g')},
  {value: $r('app.string.opt_in_h')},
  {value: $r('app.string.opt_in_i')},
  {value: $r('app.string.opt_in_j')},
  {value: $r('app.string.opt_in_k')},
  {value: $r('app.string.opt_in_l')},
  {value: $r('app.string.opt_in_m')},
  {value: $r('app.string.opt_in_n')},
  {value: $r('app.string.opt_in_o')},
  {value: $r('app.string.opt_in_p')},
  {value: $r('app.string.opt_in_q')},
  {value: $r('app.string.opt_in_r')},
  {value: $r('app.string.opt_in_s')},
  {value: $r('app.string.opt_in_t')},
  {value: $r('app.string.opt_in_u')},
  {value: $r('app.string.opt_in_v')},
  {value: $r('app.string.opt_in_w')},
  {value: $r('app.string.opt_in_x')},
  {value: $r('app.string.opt_in_y')},
  {value: $r('app.string.opt_in_z')},
  {value: $r('app.string.opt_in_back_quote')},
  {value: $r('app.string.opt_in_minus')},
  {value: $r('app.string.opt_in_equal')},
  {value: $r('app.string.opt_in_semicolon')},
  {value: $r('app.string.opt_in_quota')},
  {value: $r('app.string.opt_in_slash')},
  {value: $r('app.string.opt_in_comma')},
  {value: $r('app.string.opt_in_period')},
  {value: $r('app.string.opt_in_backward_slash')},
  {value: $r('app.string.opt_in_left_bracket')},
  {value: $r('app.string.opt_in_right_bracket')},
  {value: $r('app.string.opt_in_f1')},
  {value: $r('app.string.opt_in_f2')},
  {value: $r('app.string.opt_in_f3')},
  {value: $r('app.string.opt_in_f4')},
  {value: $r('app.string.opt_in_f5')},
  {value: $r('app.string.opt_in_f6')},
  {value: $r('app.string.opt_in_f7')},
  {value: $r('app.string.opt_in_f8')},
  {value: $r('app.string.opt_in_f9')},
  {value: $r('app.string.opt_in_f10')},
  {value: $r('app.string.opt_in_f11')},
  {value: $r('app.string.opt_in_f12')},
  {value: $r('app.string.opt_in_backspace')},
  {value: $r('app.string.opt_in_enter')},
  {value: $r('app.string.opt_in_delete')},
  {value: $r('app.string.opt_in_caps_lock')},
  {value: $r('app.string.opt_in_space')},
  {value: $r('app.string.opt_in_tab')},
  {value: $r('app.string.opt_in_fn')},
  {value: $r('app.string.opt_in_insert')},
  {value: $r('app.string.opt_in_home')},
  {value: $r('app.string.opt_in_end')},
  {value: $r('app.string.opt_in_esc')},
  {value: $r('app.string.opt_in_page_down')},
  {value: $r('app.string.opt_in_page_up')},
  {value: $r('app.string.opt_in_print_screen')},
  {value: $r('app.string.opt_in_scroll_lock')},
  {value: $r('app.string.opt_in_num_lock')},
  {value: $r('app.string.opt_in_pause')},
  {value: $r('app.string.opt_in_kp_minus')},
  {value: $r('app.string.opt_in_kp_plus')},
  {value: $r('app.string.opt_in_kp_asterisk')},
  {value: $r('app.string.opt_in_kp_backward_slash')},
  {value: $r('app.string.opt_in_kp0')},
  {value: $r('app.string.opt_in_kp1')},
  {value: $r('app.string.opt_in_kp2')},
  {value: $r('app.string.opt_in_kp3')},
  {value: $r('app.string.opt_in_kp4')},
  {value: $r('app.string.opt_in_kp5')},
  {value: $r('app.string.opt_in_kp6')},
  {value: $r('app.string.opt_in_kp7')},
  {value: $r('app.string.opt_in_kp8')},
  {value: $r('app.string.opt_in_kp9')},
  {value: $r('app.string.opt_in_kp_delete')},
  {value: $r('app.string.opt_in_mouse_left')},
  {value: $r('app.string.opt_in_mouse_right')},
  {value: $r('app.string.opt_in_mouse_middle')},
  {value: $r('app.string.opt_in_mouse3')},
  {value: $r('app.string.opt_in_mouse4')},
  {value: $r('app.string.opt_in_mouse5')},
  {value: $r('app.string.opt_in_wheel_up')},
  {value: $r('app.string.opt_in_wheel_down')}
]

export const INPUT_TYPE_OPTIONS: SelectOption[] = [
  {value: $r('app.string.opt_in_type_hold')},
  {value: $r('app.string.opt_in_type_press')},
  {value: $r('app.string.opt_in_type_long_press')},
  {value: $r('app.string.opt_in_type_tap')},
  {value: $r('app.string.opt_in_type_double_tap')}
]

export const LANGUAGE_OPTIONS: SelectOption[] = [
  {value: $r('app.string.opt_lang_auto')},
  {value: $r('app.string.opt_lang_zh_cn')},
  {value: $r('app.string.opt_lang_en')}
]