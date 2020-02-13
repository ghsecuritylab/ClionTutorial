# 実行ファイル生成
add_executable(Host_main.exe main.c)

# ライブラリのリンク
target_link_libraries(Host_main.exe Calc)
