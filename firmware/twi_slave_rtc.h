#ifndef twi_slave_rtc_h
#define twi_slave_rtc_h

#include <stdint.h>
#include <stdbool.h>

#include <sdk_common.h>
#include <ble_date_time.h>

#include "nrf_drv_twi.h"
#include "senstick_data_models.h"

// RTCのコンテキスト構造体の型宣言。
typedef struct rtc_context_s {
//    bool is_calender_available;
    nrf_drv_twi_t *p_twi;
} rtc_context_t;

// RTCとのバス機能を提供します。

// 電源ON時点、タイマー動作、割り込みレベル。initはタイマー一致フラグをクリアしない。明示的に呼び出すべし。
void initRTC(rtc_context_t *p_context, nrf_drv_twi_t *p_twi);

// 時計時刻を設定/取得します。
void setTWIRTCDateTime(rtc_context_t *p_context, ble_date_time_t *p_date);
void getTWIRTCDateTime(rtc_context_t *p_context, ble_date_time_t *p_date);

// アラーム時刻を設定/取得します。
void setRTCAlarmDateTime(rtc_context_t *p_context, ble_date_time_t *p_date);
void getRTCAlarmDateTime(rtc_context_t *p_context, ble_date_time_t *p_date);

// アラーム一致によるINT出力を、クリアします
//void clearRTCAlarm(rtc_context_t *p_context);

// アラームの有効/無効
//void setRTCAlarmEnable(rtc_context_t *p_context, bool flag);
//bool getRTCAlarmEnable(rtc_context_t *p_context);

#endif /* twi_slave_rtc_h */
