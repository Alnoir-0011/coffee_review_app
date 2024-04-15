require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    
    it 'is invalid without email' do
      user = build(:user, email: '')
      expect(user).to be_invalid
      expect(user.errors[:email]).to eq ['を入力してください']
    end
    
    it 'is invalid without name' do
      user = build(:user, name: '')
      expect(user).to be_invalid
      expect(user.errors[:name]).to eq ['を入力してください']
    end
    
    it 'is invalid without password' do
      user = build(:user, password: '')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は8文字以上で入力してください']
    end
    
    it 'is invalid without password_confirmation' do
      user = build(:user, password_confirmation: '')
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to eq ['とパスワードの入力が一致しません', 'を入力してください']
    end
    
    it 'is valid without image' do
      user = build(:user, avatar: nil)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'is valid without role' do
      user = build(:user, role: nil)
      expect(user).to be_invalid
      expect(user.errors[:role]).to eq ['を入力してください']
    end

    it 'is invalid with a duplicate email' do
      user = create(:user)
      user_with_duplicate_email = build(:user, email: user.email)
      expect(user_with_duplicate_email).to be_invalid
      expect(user_with_duplicate_email.errors[:email]).to eq ['はすでに存在します']
    end

    it 'is valid with a duplicate name' do
      user = create(:user)
      user_with_duplicate_name = build(:user, name: user.name)
      expect(user_with_duplicate_name).to be_valid
      expect(user_with_duplicate_name.errors).to be_empty
    end

    it 'is valid with another email' do
      user = create(:user)
      user_with_another_email = build(:user)
      expect(user_with_another_email).to be_valid
      expect(user_with_another_email.errors).to be_empty
    end
  end
end
