class PhotoPostsController < ApplicationController
  def index
    @photo_posts = active_user.photo_posts.includes(:spot).order(created_at: :desc)
  end

  def new
    @photo_post = PhotoPost.new(spot_id: params[:spot_id])
    @spots = Spot.order(:id)
  end

  def create
    @photo_post = active_user.photo_posts.build(photo_post_params)
    @photo_post.status = "審査中"

    if @photo_post.save
      redirect_to photo_posts_path, notice: "写真を投稿しました（現在「審査中」です）"
    else
      @spots = Spot.order(:id)
      flash.now[:alert] = "投稿に失敗しました。入力内容を確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def photo_post_params
    params.require(:photo_post).permit(:spot_id, :image_url)
  end

  # 相方のログイン機能マージ前でも単独で動作確認できるようにする補助メソッド
  def active_user
    if defined?(current_user) && current_user
      current_user
    else
      User.find_by(role: "tourist") || User.first
    end
  end
end