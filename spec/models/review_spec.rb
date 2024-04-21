require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      review = build(:review)
      expect(review).to be_valid
      expect(review.errors).to be_empty
    end

    it 'is invalid without title' do
      review = build(:review, title: '')
      expect(review).to be_invalid
      expect(review.errors[:title]).to eq ['を入力してください']
    end

    it 'is invalid without fineness' do
      review = build(:review, fineness: '')
      expect(review).to be_invalid
      expect(review.errors[:fineness]).to eq ['を入力してください']
    end

    it 'is invalid without evaluation' do
      review = build(:review, evaluation: '')
      expect(review).to be_invalid
      expect(review.errors[:evaluation]).to eq %w[は数値で入力してください]
    end

    it 'is valid without content' do
      review = build(:review, content: '')
      expect(review).to be_valid
      expect(review.errors).to be_empty
    end

    it 'is valid without image' do
      review = build(:review, image: nil)
      expect(review).to be_valid
      expect(review.errors).to be_empty
    end

    it 'is invalid with duplicate purchase' do
      purchase = create(:purchase)
      create(:review, purchase:)
      review_with_duplicate_purchase = build(:review, purchase:)
      expect(review_with_duplicate_purchase).to be_invalid
      expect(review_with_duplicate_purchase.errors[:purchase_id]).to eq ['1つにつきレビュー投稿は1度までしかできません']
    end

    it 'is invalid when coffee powder grind again' do
      purchase = create(:purchase, store_grind_option: 'medium')
      review = build(:review, fineness: 'medium', purchase:)
      expect(review).to be_invalid
      expect(review.errors[:fineness]).to eq ['既に粉砕済みです']
    end

    it 'is invalid when beans regist grinded' do
      purchase = create(:purchase, store_grind_option: 'beans')
      review = build(:review, fineness: 'grinded', purchase:)
      expect(review).to be_invalid
      expect(review.errors[:fineness]).to eq ['粉砕前です']
    end
  end
end
