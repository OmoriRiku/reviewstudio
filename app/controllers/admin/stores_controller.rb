class Admin::StoresController < ApplicationController
  before_action :is_admin_login_authenticate,     only: [:new, :create, :edit, :update, :destroy]
  before_action :set_store,                       only: [:show, :edit, :update, :destroy]
  before_action :sort_store_review,               only: [:show]
  before_action :sort_studio_price,               only: [:show]

  def new ## 新規登録ページ
    @store = Store.new # ビューへ渡すための空のモデルオブジェクト生成
  end
  
  def create ## 新規登録機能
    @store = Store.new(store_params) #  データを受け取り新規登録するためのモデルオブジェクト生成
    if @store.save #  データを保存する
      flash[:notice] = "店舗を作成いたしました!" #  フラッシュメッセージの表示
      redirect_to store_path(@store.id) #  保存できたら店舗の詳細ページへ遷移する
    else
      render :new #  保存できなければ再度新規登録ページを表示する
    end
  end
  
  def index ## 一覧ページ
    @stores = Store.all.page(params[:page]).per(8) # 店舗の全データを取得したのち、８件ずつページネーション
  end

  def show ## 詳細ページ
  end

  def edit ## 編集ページ
  end

  def update ## 更新機能
    if @store.update(store_params) # データを更新する
      flash[:notice] = '店舗を更新いたしました' # フラッシュメッセージの表示
      redirect_to store_path(@store) # 更新できたら店舗の詳細ページへ遷移する
    else
      render :edit # 更新できなければ再度編集ページを表示する
    end
  end

  def destroy ## 削除機能
    @store.destroy #  店舗を削除する
    redirect_to stores_path, notice: "店舗を削除しました" # 店舗の一覧ページへ遷移する
  end
  
  def address_search_store  # 分割したキーワードごとに検索するメソッド
    keyword = params[:word] # 検索フォームから入力された単語をインスタンス変数へ渡す
    if keyword.present? # keywordに文字が入力されているか判定する
      @result = [] # 空の配列を生成
      keyword.split(/[[:blank:]]+/).each do |keyword| # 空白で文字列を分割
        next if keyword == "" # 入力された文字が空であればスキップする
        @result += Store.where('address LIKE ?', "%#{keyword}%") # Storeモデルのaddressカラムから該当の文字列を探索し、生成した配列へ代入していく
      end
      @result.uniq! # 同じ文字列を配列へ代入しないようにするため
    else
      redirect_to request.referer, notice: '検索ワードが入力されていません'
    end
  end
  
  private
  
  def sort_studio_price ## 店舗別スタジオ料金のソート機能(価格の安い順：個人、３名、４名以上の料金)
    sort_studio_price = params[:sort_studio_price] # なにをソートするのかといった情報をlink_toから受け取る(例：personal_price ASCなど)
    @sort_studio_price = @store.studios.order(sort_studio_price) # ORDER句でソートした情報をshow.htmlで呼び出し用の変数へ代入する
  end
  
  def sort_store_review ## レビューのソート機能（新着順、評価の高い順、評価の低い順）
    sort_store_review = params[:sort_store_review] # なにをソートするのかといった情報をlink_toから受け取る(例：rate DESCなど)
    @sort_store_review = @store.store_reviews.order(sort_store_review)  # ORDER句でソートした情報をshow.htmlで呼び出し用の変数へ代入する
  end
  
  def set_store ## Storeモデルから特定のIDを取得するメソッド
    @store = Store.find(params[:id])
  end
  
  def store_params ## ストロングパラメーター
    params.require(:store).permit(:name, :telephone_number, :store_image, :introduction, :post_code, :address)
  end
end
