class PointTransactionsController < ApplicationController
  # プロジェクトの認証メソッドに合わせて変更してください（例: authenticate_user!）
  before_action :require_login
  before_action :ensure_tourist

  def index
    @current_points = current_user.current_points
    @point_transactions = current_user.point_transactions.order(created_at: :desc)
  end

  def new
    @current_points = current_user.current_points
    @point_transaction = current_user.point_transactions.new
  end

  def create
    amount = point_transaction_params[:amount].to_i

    if amount <= 0
      flash.now[:alert] = "利用ポイントは1以上の数値を入力してください。"
      @current_points = current_user.current_points
      @point_transaction = current_user.point_transactions.new(amount: amount)
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      # 残高の同時更新による不整合を防ぐためレコードをロック
      current_user.lock!

      if current_user.current_points < amount
        raise ActiveRecord::Rollback
      end

      current_user.update!(current_points: current_user.current_points - amount)
      current_user.point_transactions.create!(
        transaction_type: "利用",
        amount: amount
      )
    end

    # トランザクション内でロールバックされたか（履歴が保存されたか）を確認
    if current_user.point_transactions.where(transaction_type: "利用", amount: amount).exists? && current_user.saved_change_to_current_points?
      redirect_to point_transactions_path, notice: "#{amount}ポイントを利用しました。"
    else
      flash.now[:alert] = "保有ポイントが不足しています。（現在の保有ポイント: #{current_user.current_points}pt）"
      @current_points = current_user.current_points
      @point_transaction = current_user.point_transactions.new(amount: amount)
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "処理中にエラーが発生しました: #{e.record.errors.full_messages.join(', ')}"
    @current_points = current_user.current_points
    @point_transaction = current_user.point_transactions.new(amount: amount)
    render :new, status: :unprocessable_entity
  end

  private

  def point_transaction_params
    params.require(:point_transaction).permit(:amount)
  end

  def ensure_tourist
    unless current_user&.role == "tourist"
      redirect_to root_path, alert: "アクセス権限がありません。"
    end
  end
end