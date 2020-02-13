# 実行ファイル生成
add_executable(Embedded_main.exe main.c)

# ライブラリのリンク
target_link_libraries(Embedded_main.exe Calc)
