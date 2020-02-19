# 重要：ARM用にクロスコンパイルするためにCMAKE_FORCE_C/CXXを設定するために必要
cmake_minimum_required(VERSION 3.15)
SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR arm)

# ターゲット種別を判別するための変数を定義
SET(TARGET_TYPE "ARM" CACHE STRING description FORCE)

# *重要*:ARM用にクロスコンパイルをするために設定(設定しないとCmakeのテスト動作でエラー発生)
SET(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ライブラリは静的に生成する様に設定
SET(BUILD_SHARED_LIBS OFF)

# ツールチェインパスの設定
SET(TOOLCHAIN_PATH "D:/arm-none-eabi-gcc_2018-q2-update/bin" CACHE STRING description FORCE)

# 必要な変数を設定
set(NRFJPROG "C:/Program Files (x86)/Nordic Semiconductor/nrf5x/bin/nrfjprog.exe" CACHE STRING description FORCE)
set(NRF_SDK_DIR "${CMAKE_HOME_DIRECTORY}/ThirdParty/nRF_SDK" CACHE STRING description FORCE)
set(NRF_COMPONENTS_DIR "${NRF_SDK_DIR}/components" CACHE STRING description FORCE)
set(NRFX_DIR "${NRF_SDK_DIR}/modules/nrfx" CACHE STRING description FORCE)

## ------------------ Cache -----------------------------
SET(CMAKE_AR  ${TOOLCHAIN_PATH}/arm-none-eabi-ar.exe CACHE STRING description FORCE)
SET(CMAKE_OBJCOPY  ${TOOLCHAIN_PATH}/arm-none-eabi-objcopy.exe CACHE STRING description FORCE)
SET(CMAKE_OBJDUMP  ${TOOLCHAIN_PATH}/arm-none-eabi-objdump.exe CACHE STRING description FORCE)
SET(SIZE  ${TOOLCHAIN_PATH}/arm-none-eabi-size.exe CACHE STRING description FORCE)

## =============================== マクロ：カスタムターゲットの設定 =================================
macro(custom_command_setup)
    # PRE_BUILDを設定しておくと,ターゲットのビルド前に処理が実行される
    # POST_BUILDを設定しておくと,ターゲットのビルド後に処理が実行される
    add_custom_command(TARGET ${EXECUTABLE_NAME}.elf
            POST_BUILD
            COMMAND ${SIZE} --format=SysV -x ${EXECUTABLE_NAME}.elf
            COMMAND ${SIZE} ${EXECUTABLE_NAME}.elf
            COMMAND ${CMAKE_OBJCOPY} -O binary ${EXECUTABLE_NAME}.elf "${EXECUTABLE_NAME}.bin"
            COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE_NAME}.elf "${EXECUTABLE_NAME}.hex"
            COMMENT "post build steps for ${EXECUTABLE_NAME}")


    # DEPENDSを設定しておくと、事前に依存するターゲットのビルドが実行される
    add_custom_target("FLASH_${EXECUTABLE_NAME}"
            DEPENDS ${EXECUTABLE_NAME}
            COMMAND ${NRFJPROG} -f nrf52 --program ${EXECUTABLE_NAME}.hex --verify --sectorerase
            COMMAND ${NRFJPROG} -f nrf52 --reset
            COMMENT "flashing ${EXECUTABLE_NAME}.hex"
            )

    add_custom_target(FLASH_SOFTDEVICE
            COMMAND ${NRFJPROG} -f nrf52 --program ${SOFTDEVICE_PATH} --verify --sectorerase
            COMMAND ${NRFJPROG} -f nrf52 --reset
            COMMENT "flashing SoftDevice"
            )

    add_custom_target(FLASH_ERASE_ALL
            COMMAND ${NRFJPROG} -f nrf52 --eraseall
            COMMENT "erasing flashing"
            )

endmacro(custom_command_setup)


# ============================= マクロ：変数設定値を確認 ==========================
macro(variable_check)
message(STATUS "========================================================================")
message(STATUS "NRF_TARGET : ${NRF_TARGET}")
message(STATUS "NRF_LINKER_SCRIPT : ${NRF_LINKER_SCRIPT}")
message(STATUS "sdk_config : ${NRF_SDK_CONFIG}")
message(STATUS "SoftDevice : ${SOFTDEVICE_PATH}")
message(STATUS "NRF_COMPONENTS_DIR : ${NRF_COMPONENTS_DIR}")
message(STATUS "NRFX_DIR : ${NRFX_DIR}")
message(STATUS "========================================================================")
message(STATUS "C_COMPILER : ${CMAKE_C_COMPILER}")
message(STATUS "CXX_COMPILER : ${CMAKE_CXX_COMPILER}")
message(STATUS "NRFJPROG : ${NRFJPROG}")
message(STATUS "========================================================================")

# =========== nrfjprogのパスが存在するかを確認 ===========
if(EXISTS ${NRFJPROG})
else ()
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) don't exist.")
endif ()
# =========== nRF SDKのパスが存在するかを確認 ===========
if(EXISTS ${NRF_SDK_DIR})
else ()
    message(FATAL_ERROR "The path to the nRF SDK directory don't exist.")
endif ()

# =========== nRF SDK componentsのパスが存在するかを確認 ===========
if(EXISTS ${NRF_COMPONENTS_DIR})
else ()
    message(FATAL_ERROR "The path to the nRF SDK components directory don't exist.")
endif ()
# =========== nrfxのパスが存在するかを確認 ===========
if(EXISTS ${NRFX_DIR})
else ()
    message(FATAL_ERROR "The path to the nrfx directory don't exist.")
endif ()
# =========== Linker Scriptが存在するかを確認 ===========
if(EXISTS ${NRF_LINKER_SCRIPT})
else ()
    message(FATAL_ERROR "The path to the Linker Script(.ld file) don't exist.")
endif ()
# =========== sdk_config.hファイルが存在するかを確認 ===========
if(EXISTS ${NRF_SDK_CONFIG})
else ()
    message(FATAL_ERROR "The path to the sdk_config.h file don't exist.")
endif ()
# =========== softdeviceが存在するかを確認 ===========
if(EXISTS ${NRF_SDK_CONFIG})
else ()
    message(FATAL_ERROR "The path to the softdevice(.hex file) don't exist.")
endif ()
# =========== nRFのターゲットが設定されているかを確認 ===========
if(NRF_TARGET MATCHES "nrf52840_xxaa")

elseif (NRF_TARGET MATCHES "nrf52832_xxaa")

elseif (NOT NRF_TARGET)
    message(FATAL_ERROR "nRF target must be defined")
else ()
    message(FATAL_ERROR "Only nRF52840_xxaa,nRF52832_xxaa are supported right now")
endif ()
endmacro(variable_check)
