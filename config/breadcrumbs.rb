crumb :root do
  link t('tops.index.title'), root_path
end

crumb :beans do |region|
  link t('beans.index.title'), beans_path(region: region.id)
  parent :root
end

crumb :bean do |bean|
  link t('beans.show.title'), bean_path(bean)
  parent :beans, bean.region
end

crumb :new_purchase do
  link t('purchases.new.title'), new_purchase_path
  parent :root
end

crumb :edit_purchase do |purchase|
  link t('purchases.edit.title'), edit_purchase_path(purchase)
  parent :mypage_purchases
end

crumb :new_review do |purchase|
  link t('reviews.new.title'), new_purchase_review_path(purchase)
  parent :mypage_purchases
end

crumb :edit_review do |review|
  link t('reviews.edit.title'), edit_review_path(review)
  parent :mypage_reviews
end

crumb :mypage_purchases do
  link t('mypage.title'), mypage_purchases_path
  parent :root
end

crumb :mypage_reviews do
  link t('mypage.title'), mypage_reviews_path
  parent :root
end

crumb :shops do
  link t('shops.index.title'), shops_path
  parent :root
end

crumb :new_shop do
  link t('shops.new.title'), new_shop_path
  parent :shops
end

crumb :user_profile do |user|
  link t('user_profiles.show.title'), user_profile_path(user)
  parent :root
end

crumb :privacy_policy do
  link t('static_pages.terms_of_use.title'), privacy_policy_path
  parent :root
end

crumb :terms_of_use do
  link t('static_pages.terms_of_use.title'), terms_of_use_path
  parent :root
end
