# ユーザー（観光客・管理者）の初期データ
tourist = User.find_or_create_by!(email: "tourist@example.com") do |user|
  user.name = "観光 太郎"
  user.role = "tourist"
  user.current_points = 500
end

admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "地域観光 管理者"
  user.role = "admin"
  user.current_points = 0
end

# 観光スポットの初期データ
spot1 = Spot.find_or_create_by!(name: "飯塚歴史資料館") do |spot|
  spot.description = "地域の歴史と文化を学べる定番スポットです。"
  spot.reward_points = 100
end

spot2 = Spot.find_or_create_by!(name: "旧伊藤伝右衛門邸") do |spot|
  spot.description = "美しい日本庭園と歴史的建造物が見どころです。"
  spot.reward_points = 200
end

# サンプル投稿とポイント履歴（重複作成防止）
if PhotoPost.count.zero?
  PhotoPost.create!(
    user: tourist,
    spot: spot1,
    image_url: "https://example.com/sample_photo1.jpg",
    status: "承認"
  )
  PhotoPost.create!(
    user: tourist,
    spot: spot2,
    image_url: "https://example.com/sample_photo2.jpg",
    status: "審査中"
  )
end

if PointTransaction.count.zero?
  PointTransaction.create!(
    user: tourist,
    amount: 500,
    transaction_type: "獲得"
  )
end