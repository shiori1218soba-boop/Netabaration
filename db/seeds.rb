# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


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

Post.find_or_create_by!(title: "映画行ってきた", user: you) do |post|
  post.body = "面白かった！ワクワクした！"
  post.user = you
end

Post.find_or_create_by!(title: "本屋で店頭に置かれてた小説", user: asuka) do |post|
  post.body = "何気なく手に取ってみたけど感動した"
  post.user = asuka
end

Post.find_or_create_by!(title: "ふとテレビで見たんだけど", user: yuki) do |post|
  post.body = 'なんて言うアニメかわからないけど元気をもらった'
  post.user = yuki
end