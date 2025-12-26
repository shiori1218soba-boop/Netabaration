# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "password123"
end

you = User.find_or_create_by!(email: "you@example.com") do |user|
  user.name = "陽"
  user.password = "password"
end

asuka = User.find_or_create_by!(email: "asuka@example.com") do |user|
  user.name = "明日架"
  user.password = "password"
end

yuki = User.find_or_create_by!(email: "yuki@example.com") do |user|
  user.name = "由紀"
  user.password = "password"
end

# =========================
# グループ（オーナー指定）
# =========================
owner = asuka

movie_group = Group.find_or_create_by!(name: "新作映画について", owner_id: owner.id) do |g|
  g.introduction = "あの期待の新作映画について語ろう"
end

book_group = Group.find_or_create_by!(name: "本屋大賞を受賞したあの小説", owner_id: owner.id) do |g|
  g.introduction = "読んだ人集まれ～～～"
end

anime_group = Group.find_or_create_by!(name: "今期の覇権アニメ", owner_id: owner.id) do |g|
  g.introduction = "めっちゃ面白いからみんな見て！"
end

# =========================
# 投稿（create!）
# =========================

Post.find_or_create_by!(title: "映画行ってきた", group_id: movie_group.id) do |post|
  post.body = "面白かった！ワクワクした！"
  post.user_id = you.id
end

Post.find_or_create_by!(title: "本屋で店頭に置かれてた小説", group_id: book_group.id) do |post|
  post.body = "何気なく手に取ってみたけど感動した"
  post.user_id = asuka.id
end


Post.find_or_create_by!(title: "ふとテレビで見た", group_id: anime_group.id) do |post|
  post.body = "初めて見たアニメだったけど元気をもらった"
  post.user_id = yuki.id
end
