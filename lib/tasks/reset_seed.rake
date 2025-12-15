namespace :db do
  desc "本番環境でも安全に、テスト用データを削除して seeds データだけにする"
  task reset_seed_safe: :environment do
    puts "===== 注意 ====="
    puts "本番環境で使用する場合は管理者アカウントが消えないことを確認してください"
    puts "続行するには y を入力してください:"
    
    answer = STDIN.gets.chomp
    unless answer.downcase == "y"
      puts "中止しました"
      next
    end

    # 管理者アカウントは残す例
    puts "非管理者ユーザーを削除中…"
    User.where(admin: false).destroy_all

    puts "全投稿を削除中…"
    Post.destroy_all

    puts "seeds データを投入中…"
    Rake::Task["db:seed"].reenable   # 再実行するためにリセット
    Rake::Task["db:seed"].invoke

    puts "完了しました！"
  end
end
