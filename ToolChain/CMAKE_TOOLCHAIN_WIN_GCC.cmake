#THIS FILE IS AUTO GENERATED FROM THE TEMPLATE! DO NOT CHANGE!
SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)
cmake_minimum_required(VERSION 3.7)

# ターゲット種別を判別するための変数を定義
SET(TARGET_TYPE "HOST" CACHE STRING description FORCE)

# ------------------ Cache -----------------------------
SET(TOOLCHAIN_PATH "D:/msys64/mingw64/bin" CACHE STRING description)
SET(CMAKE_C_COMPILER_WORKS 1)
SET(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/gcc.exe CACHE STRING description FORCE)
SET(CMAKE_CXX_COMPILER_WORKS 1)
SET(CMAKE_CXX_COMPILER  ${TOOLCHAIN_PATH}/g++.exe CACHE STRING description FORCE)
SET(CMAKE_ASM_COMPILER  ${TOOLCHAIN_PATH}/gcc.exe CACHE STRING description FORCE)
SET(CMAKE_AR  ${TOOLCHAIN_PATH}/ar.exe CACHE STRING description FORCE)
SET(CMAKE_LD  ${TOOLCHAIN_PATH}/ld.exe CACHE STRING description FORCE)
SET(CMAKE_OBJCOPY  ${TOOLCHAIN_PATH}/objcopy.exe CACHE STRING description FORCE)
SET(CMAKE_OBJDUMP  ${TOOLCHAIN_PATH}/objdump.exe CACHE STRING description FORCE)
SET(SIZE  ${TOOLCHAIN_PATH}/size.exe CACHE STRING description FORCE)