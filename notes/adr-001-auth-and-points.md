ADR-001: 認証・権限管理およびポイント付与フローの設計方針1. 決定事項（ユーザー権限）
User テーブルの role カラム（文字列またはenum）で tourist（観光客）と admin（管理者/加盟店）を区別する。
写真投稿・ポイント利用画面は tourist のみアクセス可能とし、投稿承認一覧画面は admin のみアクセス可能とする。
2. 決定事項（写真承認とポイント付与の整合性）
PhotoPost の初期ステータスは pending（審査中）とする。
管理者が「承認（approved）」を実行した際、トランザクション処理内で以下の3つを同時に更新する。
PhotoPost.status を approved に更新
PointTransaction に獲得履歴（amount: spot.reward_points, type: "earn"）を作成
User.current_points に spot.reward_points を加算