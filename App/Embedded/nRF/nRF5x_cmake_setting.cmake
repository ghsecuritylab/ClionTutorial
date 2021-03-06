
# =========== ターゲットとするCPU固有の設定 ===========
if (NRF_TARGET MATCHES "nrf52840_xxa")
    set(CPU_FLAGS "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DARM_MATH_CM4 -DAPP_TIMER_V2 -DAPP_TIMER_V2_RTC1_ENABLED -DBOARD_PCA10056 -DCONFIG_GPIO_AS_PINRESET -DFLOAT_ABI_HARD -DNRF52840_XXAA -DNRF_SD_BLE_API_VERSION=7 -DS140 -DSOFTDEVICE_PRESENT -D__HEAP_SIZE=8192 -D__STACK_SIZE=8192")
    set(SOFTDEVICE_PATH "${NRF_COMPONENTS_DIR}/softdevice/s140/hex/s140_nrf52_7.0.1_softdevice.hex")
    list(APPEND SDK_INCLUDE_DIRS
            "${NRF_COMPONENTS_DIR}/softdevice/s140/headers"
            "${NRF_COMPONENTS_DIR}/softdevice/s140/headers/nrf52"
            )

    list(APPEND SDK_SOURCE_FILES
            "${NRFX_DIR}/mdk/system_nrf52840.c"
            "${NRFX_DIR}/mdk/gcc_startup_nrf52840.S"
            )
elseif (NRF_TARGET MATCHES "nrf52832_xxaa")
    set(CPU_FLAGS "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DARM_MATH_CM4 -DAPP_TIMER_V2 -DAPP_TIMER_V2_RTC1_ENABLED -DBOARD_PCA10040 -DCONFIG_GPIO_AS_PINRESET -DFLOAT_ABI_HARD -DNRF52 -DNRF52832_XXAA -DNRF52_PAN_74 -DNRF_SD_BLE_API_VERSION=7 -DS132 -DSOFTDEVICE_PRESENT -D__HEAP_SIZE=8192 -D__STACK_SIZE=8192")
    set(SOFTDEVICE_PATH "${NRF_COMPONENTS_DIR}/softdevice/s132/hex/s132_nrf52_7.0.1_softdevice.hex")

    list(APPEND SDK_INCLUDE_DIRS
            "${NRF_COMPONENTS_DIR}/softdevice/s132/headers"
            "${NRF_COMPONENTS_DIR}/softdevice/s132/headers/nrf52"
            )

    list(APPEND SDK_SOURCE_FILES
            "${NRFX_DIR}/mdk/system_nrf52.c"
            "${NRFX_DIR}/mdk/gcc_startup_nrf52.S"
            )
endif ()
# ===============================================

set(COMMON_FLAGS "-g3 -mthumb -mabi=aapcs ${CPU_FLAGS}")
# =========== C/C++/ASMのフラグ設定 ==========
set(CMAKE_C_FLAGS "${COMMON_FLAGS} -Wall -Wimplicit-function-declaration -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O3")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -fno-use-cxa-atexit -fno-exceptions -fno-rtti  -Wall -Wimplicit-function-declaration -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O3")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS}")

# -lc -lnosys -lmはLINKER_FLAGSの最後に設定する
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
set(CMAKE_EXE_LINKER_FLAGS "${CPU_FLAGS} -L ${NRFX_DIR}/mdk -T${NRF_LINKER_SCRIPT} -Wl,--gc-sections -Wl,-Map=${EXECUTABLE_NAME}.map --specs=nano.specs -u _printf_float -lc -lnosys -lm")

# 重要：LINKERの設定
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <LINK_FLAGS> -o <TARGET> <OBJECTS>")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <LINK_FLAGS> -o <TARGET> <OBJECTS>")

# =========== ソースファイル/インクルードディレクトリ設定 ==========
list(APPEND SDK_INCLUDE_DIRS
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${NRF_SDK_DIR}/integration/nrfx/legacy"
        "${NRF_SDK_DIR}/integration/nrfx"
        "${NRF_COMPONENTS_DIR}"
        "${NRF_COMPONENTS_DIR}/boards"
        "${NRF_COMPONENTS_DIR}/softdevice/common"
        "${NRFX_DIR}"
        "${NRFX_DIR}/drivers"
        "${NRFX_DIR}/drivers/include"
        "${NRFX_DIR}/hal"
        "${NRFX_DIR}/mdk"
        "${NRFX_DIR}/templates"
        "${NRF_SDK_DIR}/external/segger_rtt"
        "${NRF_SDK_DIR}/external/fprintf"
        "${NRF_SDK_DIR}/external/utf_converter"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/generic/message "
        "${NRF_COMPONENTS_DIR}/nfc/t2t_lib"
        "${NRF_COMPONENTS_DIR}/nfc/t4t_parser/hl_detection_procedure"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_ancs_c"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_ias_c"
        "${NRF_COMPONENTS_DIR}/libraries/pwm"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/cdc/acm"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/hid/generic"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/msc"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/hid"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/conn_hand_parser/le_oob_rec_parser"
        "${NRF_COMPONENTS_DIR}/libraries/log"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_gls"
        "${NRF_COMPONENTS_DIR}/libraries/fstorage"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/text"
        "${NRF_COMPONENTS_DIR}/libraries/mutex"
        "${NRF_COMPONENTS_DIR}/libraries/gfx"
        "${NRF_COMPONENTS_DIR}/libraries/bootloader/ble_dfu"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/common"
        "${NRF_COMPONENTS_DIR}/libraries/fifo"
        "${NRF_COMPONENTS_DIR}/boards"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/generic/record"
        "${NRF_COMPONENTS_DIR}/nfc/t4t_parser/cc_file"
        "${NRF_COMPONENTS_DIR}/ble/ble_advertising"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_bas_c"
        "${NRF_COMPONENTS_DIR}/libraries/experimental_task_manager"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_hrs_c"
        "${NRF_COMPONENTS_DIR}/softdevice/s140/headers/nrf52"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/le_oob_rec"
        "${NRF_COMPONENTS_DIR}/libraries/queue"
        "${NRF_COMPONENTS_DIR}/libraries/pwr_mgmt"
        "${NRF_COMPONENTS_DIR}/ble/ble_dtm"
        "${NRF_COMPONENTS_DIR}/toolchain/cmsis/include"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_rscs_c"
        "${NRF_COMPONENTS_DIR}/ble/common"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_lls"
        "${NRF_COMPONENTS_DIR}/nfc/platform"
        "${NRF_COMPONENTS_DIR}/libraries/bsp"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/ac_rec"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_bas"
        "${NRF_COMPONENTS_DIR}/libraries/mpu"
        "${NRF_COMPONENTS_DIR}/libraries/experimental_section_vars"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_ans_c"
        "${NRF_COMPONENTS_DIR}/libraries/slip"
        "${NRF_COMPONENTS_DIR}/libraries/delay"
        "${NRF_COMPONENTS_DIR}/libraries/csense_drv"
        "${NRF_COMPONENTS_DIR}/libraries/memobj"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_nus_c"
        "${NRF_COMPONENTS_DIR}/softdevice/common"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_ias"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/hid/mouse"
        "${NRF_COMPONENTS_DIR}/libraries/low_power_pwm"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/conn_hand_parser/ble_oob_advdata_parser"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_dfu"
        "${NRF_COMPONENTS_DIR}/libraries/svc"
        "${NRF_COMPONENTS_DIR}/libraries/atomic"
        "${NRF_COMPONENTS_DIR}"
        "${NRF_COMPONENTS_DIR}/libraries/scheduler"
        "${NRF_COMPONENTS_DIR}/libraries/cli"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_lbs"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_hts"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_cts_c"
        "${NRF_COMPONENTS_DIR}/libraries/crc16"
        "${NRF_COMPONENTS_DIR}/nfc/t4t_parser/apdu"
        "${NRF_COMPONENTS_DIR}/libraries/util"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/cdc"
        "${NRF_COMPONENTS_DIR}/libraries/csense"
        "${NRF_COMPONENTS_DIR}/libraries/balloc"
        "${NRF_COMPONENTS_DIR}/libraries/ecc"
        "${NRF_COMPONENTS_DIR}/libraries/hardfault"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_cscs"
        "${NRF_COMPONENTS_DIR}/libraries/uart"
        "${NRF_COMPONENTS_DIR}/libraries/hci"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/hid/kbd"
        "${NRF_COMPONENTS_DIR}/libraries/timer"
        "${NRF_COMPONENTS_DIR}/softdevice/s140/headers"
        "${NRF_COMPONENTS_DIR}/nfc/t4t_parser/tlv"
        "${NRF_COMPONENTS_DIR}/libraries/sortlist"
        "${NRF_COMPONENTS_DIR}/libraries/spi_mngr"
        "${NRF_COMPONENTS_DIR}/libraries/led_softblink"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/conn_hand_parser"
        "${NRF_COMPONENTS_DIR}/libraries/sdcard"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/parser/record"
        "${NRF_COMPONENTS_DIR}/ble/ble_link_ctx_manager"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_nus"
        "${NRF_COMPONENTS_DIR}/libraries/twi_mngr"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_hids"
        "${NRF_COMPONENTS_DIR}/libraries/strerror"
        "${NRF_COMPONENTS_DIR}/libraries/crc32"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/ble_oob_advdata"
        "${NRF_COMPONENTS_DIR}/nfc/t2t_parser"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/ble_pair_msg"
        "${NRF_COMPONENTS_DIR}/libraries/usbd/class/audio"
        "${NRF_COMPONENTS_DIR}/nfc/t4t_lib"
        "${NRF_COMPONENTS_DIR}/ble/peer_manager"
        "${NRF_COMPONENTS_DIR}/libraries/mem_manager"
        "${NRF_COMPONENTS_DIR}/libraries/ringbuf"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_tps"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/parser/message"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_dis"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/uri"
        "${NRF_COMPONENTS_DIR}/ble/nrf_ble_gatt"
        "${NRF_COMPONENTS_DIR}/ble/nrf_ble_qwr"
        "${NRF_COMPONENTS_DIR}/libraries/gpiote"
        "${NRF_COMPONENTS_DIR}/libraries/button"
        "${NRF_COMPONENTS_DIR}/libraries/twi_sensor"
        "${NRF_COMPONENTS_DIR}/libraries/usbd"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/ep_oob_rec"
        "${NRF_COMPONENTS_DIR}/libraries/atomic_fifo"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_lbs_c"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/ble_pair_lib"
        "${NRF_COMPONENTS_DIR}/libraries/crypto"
        "${NRF_COMPONENTS_DIR}/ble/ble_racp"
        "${NRF_COMPONENTS_DIR}/libraries/fds"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/launchapp"
        "${NRF_COMPONENTS_DIR}/libraries/atomic_flags"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_hrs"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_rscs"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/connection_handover/hs_rec"
        "${NRF_COMPONENTS_DIR}/nfc/ndef/conn_hand_parser/ac_rec_parser"
        "${NRF_COMPONENTS_DIR}/libraries/stack_guard"
        "${NRF_COMPONENTS_DIR}/libraries/log"
        "${NRF_COMPONENTS_DIR}/libraries/log/src"
        "${NRF_COMPONENTS_DIR}/libraries/util"
        "${CMAKE_CURRENT_SOURCE_DIR}/CMSIS_DSP/Include"
        )

list(APPEND SDK_SOURCE_FILES
        "${NRF_SDK_DIR}/integration/nrfx/legacy/nrf_drv_clock.c"
        "${NRF_SDK_DIR}/integration/nrfx/legacy/nrf_drv_uart.c"
        "${NRF_COMPONENTS_DIR}/boards/boards.c"
        "${NRF_COMPONENTS_DIR}/softdevice/common/nrf_sdh.c"
        "${NRF_COMPONENTS_DIR}/softdevice/common/nrf_sdh_soc.c"
        "${NRFX_DIR}/drivers/src/nrfx_clock.c"
        "${NRFX_DIR}/drivers/src/nrfx_gpiote.c"
        "${NRFX_DIR}/drivers/src/nrfx_uart.c"
        "${NRFX_DIR}/drivers/src/nrfx_uarte.c"
        "${NRFX_DIR}/drivers/src/prs/nrfx_prs.c"
        "${NRFX_DIR}/soc/nrfx_atomic.c"
        "${NRF_COMPONENTS_DIR}/libraries/log/src/nrf_log_backend_rtt.c"
        "${NRF_COMPONENTS_DIR}/libraries/log/src/nrf_log_backend_serial.c"
        "${NRF_COMPONENTS_DIR}/libraries/log/src/nrf_log_default_backends.c"
        "${NRF_COMPONENTS_DIR}/libraries/log/src/nrf_log_frontend.c"
        "${NRF_COMPONENTS_DIR}/libraries/log/src/nrf_log_str_formatter.c"
        "${NRF_COMPONENTS_DIR}/libraries/button/app_button.c"
        "${NRF_COMPONENTS_DIR}/libraries/util/app_error.c"
        "${NRF_COMPONENTS_DIR}/libraries/util/app_error_handler_gcc.c"
        "${NRF_COMPONENTS_DIR}/libraries/util/app_error_weak.c"
        "${NRF_COMPONENTS_DIR}/libraries/fifo/app_fifo.c"
        "${NRF_COMPONENTS_DIR}/libraries/scheduler/app_scheduler.c"
        "${NRF_COMPONENTS_DIR}/libraries/timer/app_timer2.c"
        "${NRF_COMPONENTS_DIR}/libraries/uart/app_uart_fifo.c"
        "${NRF_COMPONENTS_DIR}/libraries/util/app_util_platform.c"
        "${NRF_COMPONENTS_DIR}/libraries/timer/drv_rtc.c"
        "${NRF_COMPONENTS_DIR}/libraries/hardfault/hardfault_implementation.c"
        "${NRF_COMPONENTS_DIR}/libraries/util/nrf_assert.c"
        "${NRF_COMPONENTS_DIR}/libraries/atomic_fifo/nrf_atfifo.c"
        "${NRF_COMPONENTS_DIR}/libraries/atomic_flags/nrf_atflags.c"
        "${NRF_COMPONENTS_DIR}/libraries/atomic/nrf_atomic.c"
        "${NRF_COMPONENTS_DIR}/libraries/balloc/nrf_balloc.c"
        "${NRF_COMPONENTS_DIR}/libraries/memobj/nrf_memobj.c"
        "${NRF_COMPONENTS_DIR}/libraries/pwr_mgmt/nrf_pwr_mgmt.c"
        "${NRF_COMPONENTS_DIR}/libraries/ringbuf/nrf_ringbuf.c"
        "${NRF_COMPONENTS_DIR}/libraries/experimental_section_vars/nrf_section_iter.c"
        "${NRF_COMPONENTS_DIR}/libraries/sortlist/nrf_sortlist.c"
        "${NRF_COMPONENTS_DIR}/libraries/strerror/nrf_strerror.c"
        "${NRF_COMPONENTS_DIR}/libraries/uart/retarget.c"
        "${NRF_COMPONENTS_DIR}/boards/boards.c"
        "${NRFX_DIR}/mdk/system_nrf52840.c"
        "${NRFX_DIR}/soc/nrfx_atomic.c"
        "${NRFX_DIR}/drivers/src/nrfx_clock.c"
        "${NRFX_DIR}/drivers/src/nrfx_gpiote.c"
        "${NRFX_DIR}/drivers/src/prs/nrfx_prs.c"
        "${NRFX_DIR}/drivers/src/nrfx_uart.c"
        "${NRFX_DIR}/drivers/src/nrfx_uarte.c"
        "${NRF_COMPONENTS_DIR}/libraries/bsp/bsp.c"
        "${NRF_COMPONENTS_DIR}/libraries/bsp/bsp_btn_ble.c"
        "${NRF_COMPONENTS_DIR}/ble/common/ble_advdata.c"
        "${NRF_COMPONENTS_DIR}/ble/ble_advertising/ble_advertising.c"
        "${NRF_COMPONENTS_DIR}/ble/common/ble_conn_params.c"
        "${NRF_COMPONENTS_DIR}/ble/common/ble_conn_state.c"
        "${NRF_COMPONENTS_DIR}/ble/ble_link_ctx_manager/ble_link_ctx_manager.c"
        "${NRF_COMPONENTS_DIR}/ble/common/ble_srv_common.c"
        "${NRF_COMPONENTS_DIR}/ble/nrf_ble_gatt/nrf_ble_gatt.c"
        "${NRF_COMPONENTS_DIR}/ble/nrf_ble_qwr/nrf_ble_qwr.c"
        "${NRF_COMPONENTS_DIR}/ble/ble_services/ble_nus/ble_nus.c"
        "${NRF_COMPONENTS_DIR}/softdevice/common/nrf_sdh.c"
        "${NRF_COMPONENTS_DIR}/softdevice/common/nrf_sdh_ble.c"
        "${NRF_COMPONENTS_DIR}/softdevice/common/nrf_sdh_soc.c"
        "${NRF_SDK_DIR}/external/utf_converter/utf.c"
        "${NRF_SDK_DIR}/external/fprintf/nrf_fprintf.c"
        "${NRF_SDK_DIR}/external/fprintf/nrf_fprintf_format.c"
        "${NRF_SDK_DIR}/external/segger_rtt/SEGGER_RTT.c"
        "${NRF_SDK_DIR}/external/segger_rtt/SEGGER_RTT_Syscalls_GCC.c"
        "${NRF_SDK_DIR}/external/segger_rtt/SEGGER_RTT_printf.c"
        )

# toolchain specific
list(APPEND SDK_INCLUDE_DIRS
        "${NRF_COMPONENTS_DIR}/toolchain/cmsis/include"
        )
