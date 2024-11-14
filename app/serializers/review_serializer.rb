class ReviewSerializer
  include JSONAPI::Serializer
  attributes :title, :content, :fineness, :evaluation, :like_count, :image
  attribute :bean do |review|
    bean = review.bean
    { id: bean.id, name: bean.name }
  end
end
