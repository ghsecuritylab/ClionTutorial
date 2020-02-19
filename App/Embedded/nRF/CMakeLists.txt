set(EXECUTABLE_NAME Embedded_nRF)

# ターゲットに応じた設定
set(NRF_TARGET "nrf52840_xxaa")
set(NRF_LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/ble_app_uart_gcc_nrf52.ld")
set(NRF_SDK_CONFIG "${CMAKE_CURRENT_SOURCE_DIR}/sdk_config.h")
set(SOFTDEVICE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/s140_nrf52_7.0.1_softdevice.hex)

# 設定値の確認
variable_check()

# 別に記述したcmakeファイルの内容を展開する
include("nRF5x_cmake_setting.cmake")

# 実行ファイル生成
add_executable(${EXECUTABLE_NAME}.elf main.c ${SDK_SOURCE_FILES})

# インクルードファイルの設定
target_include_directories(${EXECUTABLE_NAME}.elf PRIVATE
                           ${SDK_INCLUDE_DIRS}
                           ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Include
                          )

# ライブラリのリンク設定(add_executable以降に記載.リンカの-lオプションを付ける事に相当)
target_link_libraries(${EXECUTABLE_NAME}.elf "${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/libarm_cortexM4lf_math.a")

# カスタムコマンド/カスタムターゲットの設定
custom_command_setup()
