# ターゲットファイルを定義
SET(SOURCES Calc.c)

# subdirectoryを追加対象にする
add_library(Calc STATIC ${SOURCES})

# ターゲット（ライブラリ）利用時に渡されるインクルードディレクトリを指定
# PRIVATE: ターゲットに必要
# PUBLIC : そのターゲットに依存するターゲットに必要(ライブラリは通常これ)
# INTERFACE : ヘッダのみのライブラリなどはこの設定
target_include_directories(Calc PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
