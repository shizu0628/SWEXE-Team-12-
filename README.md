> 📖 これは基本設計書（`README.md`）の見本です。「結局なにを書けばいいの？」の答えとして、欠勤連絡アプリの例をここまで書けばOK、という分量・粒度のサンプルにしています。**この内容をコピーして自分たちの`README.md`として保存し、そのまま自分たちの内容に書き換えていってください。** ゼロから書くより早いはずです。

# 基本設計書：SpotLink

- チーム番号：チーム12
- メンバー：吉田晃大、守屋望生

## 課題
- **選んだ課題**：情報システムを活用した地域観光の認知拡大および周遊促進における課題

- **誰の課題か**：
自治体・観光協会・地域加盟店

- **なぜこの課題を選んだか**：
多くの地域が観光客の「周遊不足」や「一極集中」に悩んでいる中、紙のスタンプラリー等では集計や不正防止に限界がある。ITを活用して「観光客の発信」と「地域内での消費」を自動で循環させる仕組みを作ることで、持続可能な地域活性化に貢献できると考えたため。

## 0. 考えを整理する3つの問い
- **開発目的**：
訪問者による写真投稿（口コミ発信）とポイント還元を組み合わせることで、地域の認知拡大を狙うとともに、観光客の「周遊行動」と「地域店舗での消費」を促進すること。

- **想定ユーザ**：
観光客（一般ユーザー）： お得に旅行を楽しみたい、または地域の魅力をSNS感覚で投稿・共有したい20〜30代を中心とする旅行者。

店舗・自治体（管理者）： 投稿された写真の確認・承認作業を行い、観光客の周遊データやポイント利用状況を把握したい地域事業者や自治体担当者。
- **機能**：
写真投稿・申請機能： 撮影した写真と位置情報（GPS）を選択し、スポットでの体験・口コミとともにポイント発行申請を送信する機能。

投稿検証・承認機能（管理者向け）： 届いた投稿写真や位置データが指定基準を満たしているかをチェックし、ワンタップで「承認」または「却下」を選択する機能。

ステータス確認・デジタルポイント管理機能： 自分の申請状況（審査中／承認／却下）をリアルタイムで確認し、付与されたポイントを加盟店（QR決済など）で利用できる機能。
## 1. ユーザーストーリー
US-01（観光客）： 写真を投稿してポイントをもらいたい

US-02（管理者）： 投稿された写真を確認・承認したい

US-03（観光客）： 審査状況とポイント残高を確認したい

全体（システム全体）を一言で表すなら：

「観光写真の投稿・承認でポイントがもらえる仕組み」

## 2. 画面イメージ（ワイヤーフレーム）
![alt text](image.jpg)

## 3. ページ遷移図
flowchart LR
  Login[ログイン/トップ] --> Top[マイページ/スポット一覧]
  Top --> PostForm[写真投稿・申請フォーム]
  PostForm --> PostConfirm[申請完了画面]
  PostConfirm --> Top
  Top --> StatusCheck[投稿ステータス・ポイント確認（観光客）]
  Top --> PointUse[ポイント利用画面（QR提示）]
  Top --> AdminList[投稿承認一覧（管理者）]
  AdminList --> AdminAction[承認 / 却下判断]
  AdminAction --> AdminList

## 4. データモデル（ER図）
- 詳細な設計検討・決定理由：[DB設計とポイント利用の設計方針](notes/db-and-point-usage.md)

```mermaid
erDiagram
erDiagram
  USER ||--o{ PHOTO_POST : "投稿する"
  SPOT ||--o{ PHOTO_POST : "対象スポット"
  USER ||--o{ POINT_TRANSACTION : "保有/利用"

  USER {
    int id PK
    string name
    string email
    string role "観光客 or 管理者/加盟店"
    int current_points "保有ポイント"
  }

  SPOT {
    int id PK
    string name
    string description
    int reward_points "付与ポイント数"
  }

  PHOTO_POST {
    int id PK
    int user_id FK
    int spot_id FK
    string image_url
    string status "審査中/承認/却下"
    datetime created_at
  }

  POINT_TRANSACTION {
    int id PK
    int user_id FK
    int amount "増減ポイント"
    string type "獲得 or 利用"
    datetime created_at
  }
```
- 関連は１（User）：多（AbsenceRequest）。外部キー`user_id`を持つ＝参照元はAbsenceRequest側。
- `User has_many :absence_requests` / `AbsenceRequest belongs_to :user`

## 5. 開発着手の許可基準に対する自己チェック
- [✓] 課題の具体性：身近な実在のペインに基づいているか？
- [✓] 連動性：ユーザーストーリーと画面・データモデルが破綻なく繋がっているか？
- [✓] ボリュームの妥当性：第14回までに2名で作りきれる規模感か？
