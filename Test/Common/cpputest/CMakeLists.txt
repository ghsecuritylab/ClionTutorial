# 実行ファイル生成
add_executable(Test_Common_cpputest.exe test_main.cpp TestCalc.cpp)
# CppUTestライブラリをリンク
target_link_libraries(Test_Common_cpputest.exe CppUTest CppUTestExt Calc)
## ライブラリ利用時のインクルードディレクトリ設定
#target_include_directories(Test_Common_cpputest.exe PRIVATE ${CppUTestRootDirectory}/include)
target_include_directories(Test_Common_cpputest.exe PRIVATE ${CMAKE_HOME_DIRECTORY}/ThirdParty/cpputest/include)
