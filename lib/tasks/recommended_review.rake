require 'matrix'

namespace :recommended_review do
  desc 'いいねを利用して推薦'
  task recommended_review: :environment do
    sample_ids = Review.all.pluck(:id).shuffle.take(100)

    User.find_each do |user|
      user_liked_review_ids = user.likes.pluck(:review_id)
      user_vector = create_vector(sample_ids, user_liked_review_ids)

      similarity_users = []

      User.find_each do |another_user|
        next if another_user.id == user.id

        another_liked_review_ids = another_user.likes.pluck(:review_id)
        another_vector = create_vector(sample_ids, another_liked_review_ids)

        similarity = user_vector.dot(another_vector) / user_vector.norm / another_vector.norm

        similarity_users << [another_user, similarity]

        if similarity_users.length > 10
          similarity_users.sort_by! { |a| a[1] }
          similarity_users.shift
        end
      end

      similarity_users_liked_reviews = similarity_users.map { |a| a[0].liked_reviews }
      similarity_users_liked_reviews.flatten!.uniq!

      user.recommended_reviews = similarity_users_liked_reviews.difference(user.liked_reviews).take(10)
    end
  end

  desc '購入記録を利用して推薦'
  task recommend_with_purchase: :environment do
    bean_ids = Bean.pluck(:id)

    User.find_each do |user|
      user_purchases = user.purchases.group(:bean_id).count
      user_vector = create_purchase_vector(bean_ids, user_purchases)

      similarity_users = []

      User.find_each do |another_user|
        next if another_user.id == user.id

        another_purchases = another_user.purchases.group(:bean_id).count
        another_vector = create_vector(bean_ids, another_purchases)

        similarity = user_vector.dot(another_vector) / user_vector.norm / another_vector.norm

        similarity_users << [another_user, similarity]

        if similarity_users.length > 10
          similarity_users.sort_by! { |a| a[1] }
          similarity_users.shift
        end
      end

      similarity_users_purchard_bean_ids = similarity_users.map { |a| a[0].purchases.pluck(:bean_id) }
                                                           .flatten.uniq.difference(user.purchases.pluck(:bean_id))
      recommended_beans = similarity_users_purchard_bean_ids.map { |id| Bean.find(id) }

      user.recommended_reviews = recommended_beans.map { |bean| bean.reviews.order(like_count: :desc).limit(1) }
                                                  .flatten
    end
  end
end

def create_vector(sample, target)
  array = []

  sample.each do |id|
    array << if target.include?(id)
               1
             else
               0
             end
  end
  Vector.elements(array)
end

def create_purchase_vector(sample, target)
  array = []

  sample.each do |id|
    array << if target.key?(id)
               target[id]
             else
               0
             end
  end
  Vector.elements(array)
end
