require 'rails_helper'

RSpec.describe Bean, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      bean = build(:bean)
      expect(bean).to be_valid
      expect(bean.errors).to be_empty
    end

    it 'is invalid without name' do
      bean = build(:bean, name: '')
      expect(bean).to be_invalid
      expect(bean.errors[:name]).to eq ['を入力してください']
    end

    it 'is invalid without roast' do
      bean = build(:bean, roast: '')
      expect(bean).to be_invalid
      expect(bean.errors[:roast]).to eq ['を入力してください']
    end

    it 'is invalid without fineness' do
      bean = build(:bean, fineness: '')
      expect(bean).to be_invalid
      expect(bean.errors[:fineness]).to eq ['を入力してください']
    end

    it 'is invalid without region_id' do
      bean = build(:bean, region_id: nil)
      expect(bean).to be_invalid
      expect(bean.errors[:region]).to eq ['を入力してください']
    end

    it 'is valid with duplicate name' do
      bean = create(:bean)
      bean_with_duplicate_name = build(:bean, name: bean.name)
      expect(bean_with_duplicate_name).to be_valid
      expect(bean_with_duplicate_name.errors).to be_empty
    end

    it 'is invalid with raw and fined' do
      bean = build(:bean, fineness: 'coarsely')
      expect(bean).to be_invalid
      expect(bean.errors[:fineness]).to eq ['焙煎前のコーヒー豆は粉砕済みでは登録できません']
    end

    it 'is valid with roasted and not fined' do
      bean = build(:bean, roast: 'light')
      expect(bean).to be_valid
      expect(bean.errors).to be_empty
    end

    it 'is valid with roasted and fined' do
      bean = build(:bean, roast: 'light', fineness: 'coarsely')
      expect(bean).to be_valid
      expect(bean.errors).to be_empty
    end
  end
end
