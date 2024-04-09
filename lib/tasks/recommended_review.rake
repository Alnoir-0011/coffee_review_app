require 'matrix'

namespace :recommended_review do
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

      similarity_users_liked_reviews = similarity_users.map do |a|
                                         a[0].liked_reviews
                                       end.flatten.uniq { |review| review.id }
      user.recommended_reviews = similarity_users_liked_reviews.difference(user.liked_reviews).take(10)
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
end
