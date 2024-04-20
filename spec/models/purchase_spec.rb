require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      purchase = build(:purchase)
      expect(purchase).to be_valid
      expect(purchase.errors).to be_empty
    end

    it 'is invalid without store_roast_option' do
      purchase = build(:purchase, store_roast_option: '')
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_roast_option]).to eq ['を入力してください']
    end

    it 'is invalid without store_grind_option' do
      purchase = build(:purchase, store_grind_option: '')
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_grind_option]).to eq ['を入力してください']
    end

    it 'is invalid wihthout puchase_at' do
      purchase = build(:purchase, purchase_at: nil)
      expect(purchase).to be_invalid
      expect(purchase.errors[:purchase_at]).to eq ['を入力してください']
    end

    it 'is invalid with future purchase_at' do
      purchase = build(:purchase, purchase_at: Time.zone.tomorrow)
      expect(purchase).to be_invalid
      expect(purchase.errors[:purchase_at]).to eq ['は未来の日付は登録できません']
    end

    it 'is invalid when raw beans regist roasted' do
      bean = create(:bean)
      purchase = build(:purchase, store_roast_option: 'roasted', bean:)
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_roast_option]).to eq ["#{bean.name}は焙煎前です"]
    end

    it 'is invalid when roasted beans regist roast status' do
      bean = create(:bean, roast: 'light')
      purchase = build(:purchase, store_roast_option: 'light', bean:)
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_roast_option]).to eq ["#{bean.name}は焙煎済みです"]
    end

    it 'is invalid when coffee powder grind again' do
      bean = create(:bean, roast: 'light', fineness: 'medium')
      purchase = build(:purchase, store_roast_option: 'roasted', store_grind_option: 'medium', bean:)
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_grind_option]).to eq ["#{bean.name}は粉砕済みです"]
    end

    it 'is invalid when coffee beans regist grinded' do
      bean = create(:bean)
      purchase = build(:purchase, store_grind_option: 'grinded', bean:)
      expect(purchase).to be_invalid
      expect(purchase.errors[:store_grind_option]).to eq ["#{bean.name}は粉砕前です"]
    end
  end
end
