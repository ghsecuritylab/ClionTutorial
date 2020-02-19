# ~/.gdbinitに下記の様に記載する事でプロジェクト下の.gdbinitファイルの内容が反映される
# set auto-load local-gdbinit on
# add-auto-load-safe-path /

# remote接続後に実施される処理
define target hookpost-remote
    echo Hook post- remote called!!\n
    load
    monitor reset
    monitor halt
    b main
end

