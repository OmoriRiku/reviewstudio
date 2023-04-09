class Studio < ApplicationRecord
  has_one_attached :studio_image
  
  def get_studio_image
    (studio_image.attached?) ? studio_image : "no_image.jpg"
  end

  
  has_many    :studio_reviews       # スタジオレビューとのリレーション
                                    # スタジオはスタジオレビューを複数持っている
  
  belongs_to  :store                # 店舗とのリレーション
                                    # 店舗はスタジオを複数持っている
  
  belongs_to  :use                  # 用途とのリレーション
                                    # 用途はスタジオを複数持っている
end
