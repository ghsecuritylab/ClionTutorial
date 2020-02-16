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
SET(TOOLCHAIN_PATH "D:/arm-none-eabi-gcc_2018-q2-update/bin" CACHE STRING description)

# 必要な変数を設定
set(NRFJPROG "nrfjprog.exe")
set(NRF_SDK_DIR "${CMAKE_HOME_DIRECTORY}/ThirdParty/nRF_SDK" CACHE STRING description)
set(NRF_COMPONENTS_DIR "${NRF_SDK_DIR}/components" CACHE STRING description)
set(NRFX_DIR "${NRF_SDK_DIR}/modules/nrfx" CACHE STRING description)

## ------------------ Cache -----------------------------
SET(CMAKE_AR  ${TOOLCHAIN_PATH}/arm-none-eabi-ar.exe CACHE STRING description FORCE)
SET(CMAKE_OBJCOPY  ${TOOLCHAIN_PATH}/arm-none-eabi-objcopy.exe CACHE STRING description FORCE)
SET(CMAKE_OBJDUMP  ${TOOLCHAIN_PATH}/arm-none-eabi-objdump.exe CACHE STRING description FORCE)
SET(SIZE  ${TOOLCHAIN_PATH}/arm-none-eabi-size.exe CACHE STRING description FORCE)

## ------------- カスタムターゲットの設定 ------------------
macro(nRF5x_custom_command_setup)
    add_custom_command(TARGET ${EXECUTABLE_NAME}
            POST_BUILD
            COMMAND ${SIZE} --format=SysV -x ${EXECUTABLE_NAME}.elf
            COMMAND ${SIZE} ${EXECUTABLE_NAME}.elf
            COMMAND ${CMAKE_OBJCOPY} -O binary ${EXECUTABLE_NAME}.elf "${EXECUTABLE_NAME}.bin"
            COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE_NAME}.elf "${EXECUTABLE_NAME}.hex"
            COMMENT "post build steps for ${EXECUTABLE_NAME}")

    add_custom_target("FLASH_${EXECUTABLE_NAME}" ALL
            DEPENDS ${EXECUTABLE_NAME}
            COMMAND ${NRFJPROG} --program ${EXECUTABLE_NAME}.hex -f ${NRF_TARGET} --sectorerase
            COMMAND sleep 0.5s
            COMMAND ${NRFJPROG} --reset -f ${NRF_TARGET}
            COMMENT "flashing ${EXECUTABLE_NAME}.hex"
            )

    add_custom_target(FLASH_SOFTDEVICE ALL
            COMMAND ${NRFJPROG} --program ${SOFTDEVICE_PATH} -f ${NRF_TARGET} --sectorerase
            COMMAND sleep 0.5s
            COMMAND ${NRFJPROG} --reset -f ${NRF_TARGET}
            COMMENT "flashing SoftDevice"
            )

    add_custom_target(FLASH_ERASE ALL
            COMMAND ${NRFJPROG} --eraseall -f ${NRF_TARGET}
            COMMENT "erasing flashing"
            )

    add_custom_target(NRFJPROG_TEST ALL
            COMMAND ${NRFJPROG}
            )

    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
        set(TERMINAL "sh")
    else()
        set(TERMINAL "gnome-terminal")
    endif()

    add_custom_target(START_JLINK ${EXECUTABLE_NAME}
            COMMAND ${TERMINAL} "${DIR_OF_nRF5x_CMAKE}/runJLinkGDBServer-${NRF_TARGET}"
            COMMAND ${TERMINAL} "${DIR_OF_nRF5x_CMAKE}/runJLinkExe-${NRF_TARGET}"
            COMMAND sleep 2s
            COMMAND ${TERMINAL} "${DIR_OF_nRF5x_CMAKE}/runJLinkRTTClient"
            COMMENT "started JLink commands"
            )
endmacro(nRF5x_custom_command_setup)
