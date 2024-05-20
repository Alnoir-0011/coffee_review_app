require 'rails_helper'

RSpec.describe 'Purchases', type: :system do
  let(:user) { create(:user) }
  let(:bean) { create(:bean) }
  let(:shop) { create(:shop) }

  describe 'ログイン前' do
    context '購入記録作成ページにアクセス' do
      it 'アクセスに失敗する' do
        visit new_purchase_path
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_current_path login_path
      end
    end

    context '購入記録編集ページにアクセス' do
      it 'アクセスに失敗する' do
        purchase = create(:purchase)
        visit edit_purchase_path(purchase)
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_current_path login_path
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user)
    end

    describe '購入記録新規作成' do
      context 'フォームの入力値が正常' do
        it '購入記録の新規作成に成功する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content '購入記録を作成しました'
          expect(page).to have_content shop.name
          expect(page).to have_content bean.name
          expect(page).to have_current_path mypage_purchases_path
        end
      end

      context '店名が未入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: ''
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).not_to have_content '購入記録を作成しました'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '店名を選択しない' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content '店舗が存在しません'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '商品名が未入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).not_to have_content '購入記録を作成しました'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '商品名を選択しない' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content '商品が存在しません'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '焙煎が未入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'を入力してください'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '焙煎前のコーヒー豆を焙煎済みで選択' do
        it '購入記録の新規作成に失敗する' do
          raw_bean = create(:bean, roast: 'raw')
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: raw_bean.name
          find("li[data-autocomplete-label='#{raw_bean.name}']").click
          select '焙煎済み', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'このコーヒー豆は焙煎済みで登録できません'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '焙煎済みのコーヒー豆の焙煎を焙煎済み以外で選択' do
        it '購入記録の新規作成に失敗する' do
          roasted_bean = create(:bean, roast: 'medium')
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: roasted_bean.name
          find("li[data-autocomplete-label='#{roasted_bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'このコーヒー豆は焙煎済みです'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '挽き方が未入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'を入力してください'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '粉砕済みのコーヒー豆を粉砕前で選択' do
        it '購入記録の新規作成に失敗する' do
          grinded_bean = create(:bean, roast: 'medium', fineness: 'medium')
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: grinded_bean.name
          find("li[data-autocomplete-label='#{grinded_bean.name}']").click
          select '焙煎済み', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'このコーヒー豆は粉砕済みです'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '粉砕前のコーヒー豆を粉砕済みで登録' do
        it '購入記録の新規作成に失敗する' do
          whole_bean = create(:bean, roast: 'medium', fineness: 'beans')
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: whole_bean.name
          find("li[data-autocomplete-label='#{whole_bean.name}']").click
          select '焙煎済み', from: '焙煎'
          select '粉砕済み', from: '挽き方'
          fill_in '購入日', with: Date.yesterday
          click_button '登録する'
          expect(page).to have_content 'このコーヒー豆は粉砕前です'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '購入日が未入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          click_button '登録する'
          expect(page).not_to have_content '購入記録を作成しました'
          expect(page).to have_current_path new_purchase_path
        end
      end

      context '購入日に未来の日付を入力' do
        it '購入記録の新規作成に失敗する' do
          visit new_purchase_path
          fill_in '店名', with: shop.name
          find("li[data-autocomplete-label='#{shop.name}']").click
          fill_in '商品名', with: bean.name
          find("li[data-autocomplete-label='#{bean.name}']").click
          select 'ミディアム', from: '焙煎'
          select '粉砕前', from: '挽き方'
          fill_in '購入日', with: Date.tomorrow
          click_button '登録する'
          expect(page).to have_content 'は未来の日付は登録できません'
          expect(page).to have_current_path new_purchase_path
        end
      end
    end

    describe '購入記録編集' do
      let(:purchase) { create(:purchase, user:) }
      let(:another_shop) { create(:shop) }
      let(:another_bean) { create(:bean) }

      context 'フォームの入力値が正常' do
        it '購入記録の編集に成功する' do
          visit edit_purchase_path(purchase)
          fill_in '店名', with: another_shop.name
          find("li[data-autocomplete-label='#{another_shop.name}']").click
          fill_in '商品名', with: another_bean.name
          find("li[data-autocomplete-label='#{another_bean.name}']").click
          select 'ハイ', from: '焙煎'
          select '中挽き', from: '挽き方'
          fill_in '購入日', with: Time.zone.today
          click_button '更新する'
          expect(page).to have_content '購入記録を更新しました'
          expect(page).to have_current_path mypage_purchases_path
        end
      end

      context '焙煎前のコーヒー豆を焙煎済みで選択' do
        it '購入記録の編集に失敗する' do
          raw_bean = create(:bean, roast: 'raw')
          fullcity_purchase = create(:purchase, store_roast_option: 'fullcity', bean: raw_bean, user:)
          visit edit_purchase_path(fullcity_purchase)
          select '焙煎済み', from: '焙煎'
          click_button '更新する'
          expect(page).to have_content 'このコーヒー豆は焙煎済みで登録できません'
          expect(page).to have_current_path edit_purchase_path(fullcity_purchase)
        end
      end

      context '焙煎済みのコーヒー豆の焙煎を焙煎済み以外で選択' do
        it '購入記録の編集に失敗する' do
          roasted_bean = create(:bean, roast: 'medium')
          roasted_purchase = create(:purchase, store_roast_option: 'roasted', bean: roasted_bean, user:)
          visit edit_purchase_path(roasted_purchase)
          select 'ライト', from: '焙煎'
          click_button '更新する'
          expect(page).to have_content 'このコーヒー豆は焙煎済みです'
          expect(page).to have_current_path edit_purchase_path(roasted_purchase)
        end
      end

      context '粉砕済みのコーヒー豆を粉砕前で選択' do
        it '購入記録の編集に失敗する' do
          grinded_bean = create(:bean, roast: 'medium', fineness: 'medium')
          grinded_purchase = create(:purchase, bean: grinded_bean, store_roast_option: 'roasted',
                                               store_grind_option: 'grinded', user:)
          visit edit_purchase_path(grinded_purchase)
          select '中挽き', from: '挽き方'
          click_button '更新する'
          expect(page).to have_content 'このコーヒー豆は粉砕済みです'
          expect(page).to have_current_path edit_purchase_path(grinded_purchase)
        end
      end

      context '粉砕前のコーヒー豆を粉砕済みで登録' do
        it '購入記録の編集に失敗する' do
          whole_bean = create(:bean, roast: 'medium', fineness: 'beans')
          beans_purchase = create(:purchase, bean: whole_bean, store_roast_option: 'roasted',
                                             store_grind_option: 'beans', user:)
          visit edit_purchase_path(beans_purchase)
          select '粉砕済み', from: '挽き方'
          click_button '更新する'
          expect(page).to have_content 'このコーヒー豆は粉砕前です'
          expect(page).to have_current_path edit_purchase_path(beans_purchase)
        end
      end

      context '購入日が未入力' do
        it '購入記録の編集に失敗する' do
          visit edit_purchase_path(purchase)
          fill_in '購入日', with: ''
          click_button '更新する'
          expect(page).not_to have_content '購入記録を作成しました'
          expect(page).to have_current_path edit_purchase_path(purchase)
        end
      end

      context '購入日に未来の日付を入力' do
        it '購入記録の編集に失敗する' do
          visit edit_purchase_path(purchase)
          fill_in '購入日', with: Date.tomorrow
          click_button '更新する'
          expect(page).to have_content 'は未来の日付は登録できません'
          expect(page).to have_current_path edit_purchase_path(purchase)
        end
      end
    end
  end
end
