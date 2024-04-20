require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'validation' do
    it 'is valid with all attirbutes' do
      shop = build(:shop)
      expect(shop).to be_valid
      expect(shop.errors).to be_empty
    end

    it 'is invalid without name' do
      shop = build(:shop, name: '')
      expect(shop).to be_invalid
      expect(shop.errors[:name]).to eq ['を入力してください']
    end

    it 'is valid without address' do
      shop = build(:shop, address: '')
      expect(shop).to be_invalid
      expect(shop.errors[:address]).to eq ['を入力してください']
    end

    it 'is invalid without place_id' do
      shop = build(:shop, place_id: '')
      expect(shop).to be_invalid
      expect(shop.errors[:place_id]).to eq ['を入力してください']
    end

    it 'is invalid without latitude' do
      shop = build(:shop, latitude: nil)
      expect(shop).to be_invalid
      expect(shop.errors[:latitude]).to eq %w[を入力してください は数値で入力してください]
    end

    it 'is invalid without longitude' do
      shop = build(:shop, longitude: nil)
      expect(shop).to be_invalid
      expect(shop.errors[:longitude]).to eq %w[を入力してください は数値で入力してください]
    end

    it 'is invalid without google_map_uri' do
      shop = build(:shop, google_map_uri: '')
      expect(shop).to be_invalid
      expect(shop.errors[:google_map_uri]).to eq ['を入力してください']
    end

    it 'is valid with duplicate name' do
      shop = create(:shop)
      shop_with_duplicate_name = build(:shop, name: shop.name)
      expect(shop_with_duplicate_name).to be_valid
      expect(shop_with_duplicate_name.errors).to be_empty
    end

    it 'is invalid with duplicate place_id' do
      shop = create(:shop)
      shop_with_duplicate_place_id = build(:shop, place_id: shop.place_id)
      expect(shop_with_duplicate_place_id).to be_invalid
      expect(shop_with_duplicate_place_id.errors[:place_id]).to eq ['はすでに存在します']
    end

    it 'is valid with another place_id' do
      create(:shop)
      shop_with_another_place_id = build(:shop)
      expect(shop_with_another_place_id).to be_valid
      expect(shop_with_another_place_id.errors).to be_empty
    end

    it 'is invalid with duplicate google_map_uri' do
      shop = create(:shop)
      shop_with_duplicate_google_map_uri = build(:shop, google_map_uri: shop.google_map_uri)
      expect(shop_with_duplicate_google_map_uri).to be_invalid
      expect(shop_with_duplicate_google_map_uri.errors[:google_map_uri]).to eq ['はすでに存在します']
    end

    it 'is valid with another google_map_uri' do
      create(:shop)
      shop_with_another_google_map_uri = build(:shop)
      expect(shop_with_another_google_map_uri).to be_valid
      expect(shop_with_another_google_map_uri.errors).to be_empty
    end

    it 'is invalid with under 20 latitude' do
      shop = build(:shop, latitude: 19.5)
      expect(shop).to be_invalid
      expect(shop.errors[:latitude]).to eq ['は20..46の範囲に含めてください']
    end

    it 'is invalid with over 46 latitude' do
      shop = build(:shop, latitude: 46.5)
      expect(shop).to be_invalid
      expect(shop.errors[:latitude]).to eq ['は20..46の範囲に含めてください']
    end

    it 'is invalid with under 120 longitude' do
      shop = build(:shop, longitude: 119.5)
      expect(shop).to be_invalid
      expect(shop.errors[:longitude]).to eq ['は120..150の範囲に含めてください']
    end

    it 'is invalid with over 150 longitude' do
      shop = build(:shop, longitude: 150.5)
      expect(shop).to be_invalid
      expect(shop.errors[:longitude]).to eq ['は120..150の範囲に含めてください']
    end
  end
end
