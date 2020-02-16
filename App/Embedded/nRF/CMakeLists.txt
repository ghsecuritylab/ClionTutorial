set(EXECUTABLE_NAME Embedded_nRF)

# ターゲットに応じた設定
set(NRF_TARGET "nrf52840_xxaa")
set(NRF_LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/ble_app_uart_gcc_nrf52.ld")
set(NRF_SDK_CONFIG "${CMAKE_CURRENT_SOURCE_DIR}/sdk_config.h")

# 別に記述したcmakeファイルの内容を展開する
include("nRF5x_cmake_setting.cmake")

# 実行ファイル生成
add_executable(${EXECUTABLE_NAME} main.c ${SDK_SOURCE_FILES})
SET(CMAKE_EXECUTABLE_SUFFIX ".elf")

# インクルードファイルの設定
target_include_directories(${EXECUTABLE_NAME} PRIVATE
                           ${SDK_INCLUDE_DIRS}
                           ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Include
                          )

# ライブラリのリンク設定(add_executable以降に記載.リンカの-lオプションを付ける事に相当)
target_link_libraries(${EXECUTABLE_NAME} "${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/libarm_cortexM4lf_math.a")

# カスタムコマンド/カスタムターゲットの設定
nRF5x_custom_command_setup()
