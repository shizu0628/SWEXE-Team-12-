# DB設計（関連付け）とポイント利用（減算）の設計方針

## 検討したこと
観光客が加盟店でポイントを利用（減算）する際のデータ更新方法と、各モデル間の関連付け・整合性をどう担保するか。

## 検討した選択肢
- A: `User` テーブルに `current_points`（現在保有ポイント）を持たせ、ポイント獲得・利用のたびにトランザクション内で `current_points` の増減と `PointTransaction`（履歴）への記録を同時に行う。
- B: `User` テーブルには残高カラムを持たず、利用のたびに `PointTransaction` の全履歴を毎回合計して残高を計算する。

## 決定・理由
Aを採用。今回の規模では、残高確認画面や利用時の残高不足チェックをシンプルかつ高速に実装できるメリットが大きく、トランザクション（`ActiveRecord::Base.transaction`）とバリデーション（0以上制約）を組み合わせることで残高ズレも防げるため。

### 確定したモデル関連付け（アソシエーション）
- `User`：`has_many :photo_posts` / `has_many :point_transactions`
- `Spot`：`has_many :photo_posts`
- `PhotoPost`：`belongs_to :user` / `belongs_to :spot`
- `PointTransaction`：`belongs_to :user`