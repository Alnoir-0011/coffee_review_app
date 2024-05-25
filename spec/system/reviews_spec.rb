require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  let(:user) { create(:user) }
  let(:purchase) { create(:purchase, user:) }

  describe 'ログイン前' do
    context 'レビュー作成ページにアクセス' do
      it 'アクセスに失敗する' do
        visit new_purchase_review_path(purchase)
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_current_path login_path, ignore_query: true
      end
    end

    context 'レビュー編集ページにアクセス' do
      let(:review) { create(:review, purchase:) }

      it 'アクセスに失敗する' do
        visit edit_review_path(review)
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_current_path login_path, ignore_query: true
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'レビュー新規作成機能' do
      context 'フォームの入力値が正常' do
        it 'レビューの新規作成に成功する' do
          visit new_purchase_review_path(purchase)
          fill_in 'タイトル', with: 'testtitle'
          select '中挽き', from: '挽き方'
          check '全自動マシン'
          select 'イタリアン', from: '飲み方'
          choose '3'
          fill_in '内容', with: 'testcontent'
          attach_file '画像', Rails.root.join('public/images/noimage.jpg').to_s
          click_button '登録する'
          expect(page).to have_content 'レビューを投稿しました'
          expect(page).to have_content purchase.bean.name
          expect(page).to have_content 'testtitle'
          expect(page).to have_current_path mypage_reviews_path, ignore_query: true
          click_on 'testtitle'
          expect(page).to have_selector 'p', text: '中挽き'
          expect(page).to have_selector 'span', text: '全自動マシン'
          expect(page).to have_content '3'
          expect(page).to have_content 'testcontent'
          expect(page).to have_selector "img[src$='noimage.jpg']"
        end
      end

      context 'タイトルが未入力' do
        it 'レビューの新規作成に失敗する' do
          visit new_purchase_review_path(purchase)
          fill_in 'タイトル', with: ''
          select '中挽き', from: '挽き方'
          check '全自動マシン'
          select 'イタリアン', from: '飲み方'
          choose '3'
          fill_in '内容', with: 'testcontent'
          attach_file '画像', Rails.root.join('public/images/noimage.jpg').to_s
          click_button '登録する'
          expect(page).not_to have_content 'レビューを投稿しました'
          expect(page).to have_current_path new_purchase_review_path(purchase), ignore_query: true
        end
      end

      context '購入記録が豆のままかつ挽き方が粉砕済み' do
        let(:whole_beans_purchase) { create(:purchase, store_grind_option: 'beans', user:) }

        it 'レビューの新規作成に失敗する' do
          visit new_purchase_review_path(whole_beans_purchase)
          fill_in 'タイトル', with: 'testtitle'
          select '粉砕済み', from: '挽き方'
          check '全自動マシン'
          select 'イタリアン', from: '飲み方'
          choose '3'
          fill_in '内容', with: 'testcontent'
          attach_file '画像', Rails.root.join('public/images/noimage.jpg').to_s
          click_button '登録する'
          expect(page).to have_content '粉砕前です'
          expect(page).to have_current_path new_purchase_review_path(whole_beans_purchase), ignore_query: true
        end
      end

      context '購入記録が豆のまま以外' do
        let(:grinded_purchase) { create(:purchase, store_grind_option: 'medium', user:) }

        it '挽き方が粉砕済みに設定されている' do
          visit new_purchase_review_path(grinded_purchase)
          expect(page).to have_select '挽き方', selected: '粉砕済み', disabled: true
        end
      end

      context '飲み方が未入力' do
        it 'レビューの新規作成に失敗する' do
          visit new_purchase_review_path(purchase)
          fill_in 'タイトル', with: 'testtitle'
          select '中挽き', from: '挽き方'
          check '全自動マシン'
          choose '3'
          fill_in '内容', with: 'testcontent'
          attach_file '画像', Rails.root.join('public/images/noimage.jpg').to_s
          click_button '登録する'
          expect(page).to have_content 'を入力してください'
          expect(page).to have_current_path new_purchase_review_path(purchase), ignore_query: true
        end
      end

      context '評価が未入力' do
        it 'レビューの新規作成に失敗する' do
          visit new_purchase_review_path(purchase)
          fill_in 'タイトル', with: 'testtitle'
          select '中挽き', from: '挽き方'
          check '全自動マシン'
          select 'イタリアン', from: '飲み方'
          fill_in '内容', with: 'testcontent'
          attach_file '画像', Rails.root.join('public/images/noimage.jpg').to_s
          click_button '登録する'
          expect(page).to have_content 'を選択してください'
          expect(page).to have_current_path new_purchase_review_path(purchase), ignore_query: true
        end
      end

      context 'レビューが存在する購入記録のレビュー作成ページにアクセス' do
        it 'アクセスに失敗する' do
          create(:review, purchase:)
          visit new_purchase_review_path(purchase)
          expect(page).to have_content 'レビューがすでに存在します'
          expect(page).to have_current_path mypage_reviews_path, ignore_query: true
        end
      end
    end

    describe 'レビュー編集機能' do
      let(:review) { create(:review, purchase:) }

      context 'フォームの入力値が正常' do
        it 'レビューの編集に成功する' do
          visit edit_review_path(review)
          fill_in 'タイトル', with: 'updatetitle'
          select '細挽き', from: '挽き方'
          uncheck '全自動マシン'
          check 'ドリッパー'
          select 'アメリカン', from: '飲み方'
          choose '4'
          fill_in '内容', with: 'updatecontent'
          attach_file '画像', Rails.root.join('public/images/updateimage.jpg').to_s
          click_button '更新する'
          expect(page).to have_content 'レビューを更新しました'
          expect(page).to have_content 'updatetitle'
          expect(page).to have_content purchase.bean.name
          expect(page).to have_current_path mypage_reviews_path, ignore_query: true
          click_on 'updatetitle'
          expect(page).to have_selector 'p', text: '細挽き'
          expect(page).not_to have_selector 'span', text: '全自動マシン'
          expect(page).to have_selector 'span', text: 'ドリッパー'
          expect(page).to have_content '4'
          expect(page).to have_content 'updatecontent'
          expect(page).to have_selector "img[src$='updateimage.jpg']"
        end
      end

      context 'タイトルが未入力' do
        it 'レビューの編集に失敗する' do
          visit edit_review_path(review)
          fill_in 'タイトル', with: ''
          select '細挽き', from: '挽き方'
          uncheck '全自動マシン'
          check 'ドリッパー'
          select 'アメリカン', from: '飲み方'
          choose '4'
          fill_in '内容', with: 'updatecontent'
          attach_file '画像', Rails.root.join('public/images/updateimage.jpg').to_s
          click_button '更新する'
          expect(page).not_to have_content 'レビューを投稿しました'
          expect(page).to have_current_path edit_review_path(review), ignore_query: true
        end
      end

      context '購入記録が豆のままかつ挽き方が粉砕済み' do
        let(:whole_beans_purchase) { create(:purchase, store_grind_option: 'beans', user:) }
        let(:medium_fine_review) { create(:review, fineness: 'medium_fine', purchase: whole_beans_purchase) }

        it 'レビューの編集に失敗する' do
          visit edit_review_path(medium_fine_review)
          fill_in 'タイトル', with: 'updatetitle'
          select '粉砕済み', from: '挽き方'
          uncheck '全自動マシン'
          check 'ドリッパー'
          select 'アメリカン', from: '飲み方'
          choose '4'
          fill_in '内容', with: 'updatecontent'
          attach_file '画像', Rails.root.join('public/images/updateimage.jpg').to_s
          click_button '更新する'
          expect(page).to have_content '粉砕前です'
          expect(page).to have_current_path edit_review_path(medium_fine_review), ignore_query: true
        end
      end

      context '購入記録が豆のまま以外' do
        let(:grinded_purchase) { create(:purchase, store_grind_option: 'medium', user:) }
        let(:grinded_review) { create(:review, fineness: 'grinded', purchase: grinded_purchase) }

        it '挽き方が粉砕済みに設定されている' do
          visit edit_review_path(grinded_review)
          expect(page).to have_select '挽き方', selected: '粉砕済み', disabled: true
        end
      end
    end
  end
end
