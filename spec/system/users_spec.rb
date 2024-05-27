require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'ユーザー名', with: 'testuser'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード(確認)', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザーを登録しました'
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'メールアドレス', with: ''
          fill_in 'ユーザー名', with: 'testuser'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード(確認)', with: 'password'
          click_button '登録'
          expect(page).to have_current_path new_user_path, ignore_query: true
        end
      end

      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'ユーザー名', with: 'testuser'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード(確認)', with: 'password'
          click_button '登録'
          expect(page).to have_content 'はすでに存在します'
          expect(page).to have_current_path new_user_path, ignore_query: true
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'ユーザー名', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード(確認)', with: 'password'
          click_button '登録'
          expect(page).to have_current_path new_user_path, ignore_query: true
        end
      end
    end
  end
end
