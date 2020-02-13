# 実行ファイル生成
add_executable(Test_Common.exe test_common.cpp)
# Google Testライブラリをリンク
target_link_libraries(Test_Common.exe gtest gtest_main Calc)
## ライブラリ利用時のインクルードディレクトリ設定
target_include_directories(Test_Common.exe PRIVATE ${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})
