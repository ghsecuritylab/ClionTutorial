cmake_minimum_required(VERSION 3.15)
# CとC++が混在する可能性があるためC/CXXに限定しない方が良い
project(CLion_Tutorial)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 14)

# subdirectoryを追加対象にする
## libraryを含む(add_library)
add_subdirectory(App/Common)
add_subdirectory(ThirdParty)

## mainを含む(add_executable)
add_subdirectory(Test/Common/googletest)
add_subdirectory(Test/Common/cpputest)
add_subdirectory(Test/Host)
add_subdirectory(Test/Embedded)
add_subdirectory(App/Host)
add_subdirectory(App/Embedded)



