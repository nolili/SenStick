#ifndef senstick_sensor_manager_h
#define senstick_sensor_manager_h

#include "nrf_drv_twi.h"
#include "app_timer.h"

#include "twi_slave_nine_axes_sensor.h"
#include "twi_slave_pressure_sensor.h"
#include "twi_slave_humidity_sensor.h"
#include "twi_slave_uv_sensor.h"
#include "twi_slave_brightness_sensor.h"
#include "twi_slave_rtc.h"

#include "gpio_manager.h"

// センサデータの更新コールバック
typedef void (*sampling_callback_handler_t) (const SensorData_t *p_sensorData);
typedef void (*sensor_setting_callback_handler_t) (sensorSetting_t *p_setting);

// 物理的なセンサーデバイスの数
#define NUM_OF_SENSOR_DEVICES   7

// コンテキストの構造体宣言
typedef struct sensor_manager_s {
    bool is_sampling;
    
    gpio_manager_t *p_gpio_manager_context;
    // サンプリング時のコールバック
    sampling_callback_handler_t sampling_callback_handler;
    // 設定変更時のコールバック
    sensor_setting_callback_handler_t setting_callback_handler;
    
    // TWIインタフェースとセンサのコンテキスト
    nrf_drv_twi_t twi;
    
    nine_axes_sensor_context_t  nine_axes_sensor_context;
    pressure_sensor_context_t   pressure_sensor_context;
    humidity_sensor_context_t   humidity_sensor_context;
    uv_sensor_context_t         uv_sensor_context;
    brightness_sensor_context_t brightness_sensor_context;

    rtc_context_t rtc_context;
    
    // タイマー
    app_timer_t timer_id_data;
    app_timer_id_t timer_id;
    //    APP_TIMER_DEF(timer_id);
    
    // センサーのサンプリングまでの残りカウント時間
    int remaining_counter[NUM_OF_SENSOR_DEVICES];

    // センサー設定
    sensorSetting_t             sensor_setting;

    // センサーがあるかどうかの判定
    bool is_sensor[NUM_OF_SENSOR_DEVICES];
} sensor_manager_t;

// Senstickの、TWIおよびGPIOの統合動作を提供します。
// 例えば、センサーからデータを読みだして、フラッシュメモリに書き出す一連のシーケンスのように、周辺IOを束ねた逐次動作を提供します。

void initSensorManager(sensor_manager_t *p_context, gpio_manager_t *p_gpio_manager_context, const sensorSetting_t *p_setting,
                       sensor_setting_callback_handler_t settingCallback, sampling_callback_handler_t samplingCallback);

// センサ設定の取得/設定
void getSensorManagerSetting(sensor_manager_t *p_context, sensorSetting_t *p_setting);
void setSensorManagerSetting(sensor_manager_t *p_context, const sensorSetting_t *p_setting);

// サンプリング中?
bool isSensorManagerSampling(sensor_manager_t *p_context);

// サンプリングの開始
// この関数は、ノンブロッキング関数です。呼び出せば直ちに返ってきます。
// センサの初期化などで、通知が開始するまでに100ミリ秒かかります。
void sensorManagerStartSampling(sensor_manager_t *p_context);

// サンプリングの停止
void sensorManagerStopSampling(sensor_manager_t *p_context);

// 時計時刻を設定/取得します。
void setRTCDateTime(sensor_manager_t *p_context, ble_date_time_t *p_date);
void getRTCDateTime(sensor_manager_t *p_context, ble_date_time_t *p_date);

#endif /* senstick_sensor_manager_h */