cmake_minimum_required(VERSION 3.15)
# CとC++が混在する可能性があるためC/CXXに限定しない方が良い
project(CLion_Tutorial)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

if(${TARGET_TYPE} STREQUAL "ARM")
    # *重要*:ARM用にクロスコンパイルするための設定.TopのCMakeLists.txtに記述する必要がありそう
    include(CMakeForceCompiler)
    CMAKE_FORCE_C_COMPILER(${TOOLCHAIN_PATH}/arm-none-eabi-gcc GNU)
    CMAKE_FORCE_CXX_COMPILER(${TOOLCHAIN_PATH}/arm-none-eabi-g++ GNU)
    # *重要*:アセンブラファイルのコンパイルを有効化する(設定しないとスタートアップコードがコンパイルされない)
    enable_language(ASM)
endif()

# ビルド時のコメントを詳細に表示するか
set(CMAKE_VERBOSE_MAKEFILE OFF)

## ============= 共通 ===============
add_subdirectory(App/Common/Calc)

## ============= ターゲット毎 ===============
if(${TARGET_TYPE} STREQUAL "HOST")
    add_subdirectory(ThirdParty/googletest)
    add_subdirectory(ThirdParty/cpputest)
    add_subdirectory(App/Host)
    add_subdirectory(Test/Host)
    add_subdirectory(Test/Common/googletest)
    add_subdirectory(Test/Common/cpputest)
elseif(${TARGET_TYPE} STREQUAL "ARM")
    add_subdirectory(Test/Embedded)
    add_subdirectory(App/Embedded/nRF)
else()
    message(FATAL_ERROR "Invalid Target Type!!! Check 'TARGET_TYPE' Variable.")
endif()

