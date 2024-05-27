require 'rails_helper'

RSpec.describe 'Beans', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe '産地別一覧' do
      let!(:beans) { create_list(:bean, 10) }

      context '産地別一覧ページにアクセス' do
        let!(:other_beans) { create_list(:bean, 10, region_id: 10) }

        it '産地ごとの一覧が表示される' do
          visit beans_path(q: { region_id: '1' })
          expect(page).to have_current_path beans_path, ignore_query: true
          expect(page).to have_content Region.find(1).name
          expect(page).to have_content beans[0].name
          expect(page).not_to have_content other_beans[0].name
        end
      end

      describe '検索機能' do
        context '商品名を入力' do
          it '入力した内容を含む商品が表示されること' do
            visit beans_path(q: { region_id: '1' })
            fill_in '商品名', with: beans[0].name
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content beans[0].name
            expect(page).not_to have_content beans[1].name
            fill_in '商品名', with: beans[1].name
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content beans[1].name
            expect(page).not_to have_content beans[0].name
          end
        end

        context '焙煎度合いを選択' do
          let!(:roasted_beans) { create_list(:bean, 10, :roast_medium) }

          it '選択した焙煎度合いの商品が表示されること' do
            visit beans_path(q: { region_id: '1' })
            find('#q_roast_eq').find('option[value="30"]').select_option
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content roasted_beans[0].name
            expect(page).not_to have_content beans[0].name
            find('#q_roast_eq').find('option[value="0"]').select_option
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content beans[0].name
            expect(page).not_to have_content roasted_beans[0].name
          end
        end

        context '挽き方を選択' do
          let!(:fineness_medium_beans) { create_list(:bean, 10, :fineness_medium) }

          it '選択した挽き方の商品が表示されること' do
            visit beans_path(q: { region_id: '1' })
            find('#q_fineness_eq').find('option[value="20"]').select_option
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content fineness_medium_beans[0].name
            expect(page).not_to have_content beans[0].name
            find('#q_fineness_eq').find('option[value="0"]').select_option
            click_button '検索'
            expect(page).to have_current_path beans_path, ignore_query: true
            expect(page).to have_content beans[0].name
            expect(page).not_to have_content fineness_medium_beans[0].name
          end
        end
      end

      xdescribe 'ソート機能' do # rubocop:disable RSpec/EmptyExampleGroup
        context '名前をクリック'

        context '評価をクリック'

        context '作成日時をクリック'
      end
    end

    describe 'コーヒー豆詳細' do
      let(:bean) { create(:bean, :with_review, user:) }

      context 'コーヒー豆詳細ページにアクセス' do
        it 'コーヒー豆の詳細情報が表示されること' do
          visit bean_path(bean)
          expect(page).to have_current_path bean_path(bean), ignore_query: true
          expect(page).to have_content bean.name
          expect(page).to have_content bean.shops[0].name
          expect(page).to have_content bean.roast_i18n
          expect(page).to have_content '3.0'
          expect(page).to have_content bean.reviews[0].title
          expect(page).to have_content bean.reviews[0].content
          expect(page).to have_content bean.reviews[0].tools[0].name
        end
      end

      describe 'ソート機能' do
        context '投稿日時をクリック' do
          it '投稿日時の昇順,降順にソートされていること' do
            visit bean_path(bean)
            expect(page).to have_link '投稿日時', href: bean_path(bean, q: { s: 'created_at asc' })
            unsorted_reviews = all('.card')
            expect(unsorted_reviews[0]).to have_content bean.reviews.first.title
            click_link '投稿日時'
            expect(page).to have_content '投稿日時 ▲'
            sorted_asc_reviews = all('.card')
            expect(sorted_asc_reviews[0]).to have_content bean.reviews.first.title
            click_link '投稿日時'
            expect(page).to have_content '投稿日時 ▼'
            sorted_desc_reviews = all('.card')
            expect(sorted_desc_reviews[0]).to have_content bean.reviews.last.title
          end
        end

        context '評価をクリック' do
          let(:max_ev_purchase) { create(:purchase, bean:) }
          let(:min_ev_purchase) { create(:purchase, bean:) }
          let!(:max_evaluation_review) { create(:review, evaluation: 5, purchase: max_ev_purchase) }
          let!(:min_evaluation_review) { create(:review, evaluation: 1, purchase: min_ev_purchase) }

          it '評価の昇順,降順にソートされること' do
            visit bean_path(bean)
            expect(page).to have_link '評価', href: bean_path(bean, q: { s: 'evaluation asc' })
            unsorted_reviews = all('.card')
            expect(unsorted_reviews[0]).to have_content bean.reviews.first.title
            click_link '評価'
            expect(page).to have_content '評価 ▲'
            sorted_asc_reviews = all('.card')
            expect(sorted_asc_reviews[0]).to have_content min_evaluation_review.title
            click_link '評価'
            expect(page).to have_content '評価 ▼'
            sorted_desc_reviews = all('.card')
            expect(sorted_desc_reviews[0]).to have_content max_evaluation_review.title
          end
        end

        context 'いいね数をクリック' do
          let(:bean) { create(:bean) }
          let(:purchase) { create(:purchase, bean:) }
          let!(:liked_review) { create(:review, :with_likes, like_count: 5, purchase:) }
          let!(:purchase_with_unliked_review) { create(:purchase, :with_review, bean:) }

          it 'いいね数の昇順, 降順にソートされること' do
            visit bean_path(bean)
            expect(page).to have_link 'いいね数', href: bean_path(bean, q: { s: 'like_count asc' })
            click_link 'いいね数'
            expect(page).to have_content 'いいね数 ▲'
            sorted_asc_reviews = all('.card')
            expect(sorted_asc_reviews[0]).to have_content purchase_with_unliked_review.reviews[0].title
            click_link 'いいね数'
            expect(page).to have_content 'いいね数 ▼'
            sorted_desc_reviews = all('.card')
            expect(sorted_desc_reviews[0]).to have_content liked_review.title
          end
        end
      end
    end

    context 'コーヒー豆新規登録ページにアクセス' do
      it 'アクセスに失敗する' do
        visit new_bean_path
        expect(page).to have_content 'ログインしてください'
        expect(page).not_to have_content 'コーヒー豆登録'
        expect(page).to have_current_path login_path, ignore_query: true
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'コーヒー豆詳細' do
      let!(:bean) { create(:bean) }

      context '自分がレビューを投稿したコーヒー豆の詳細ページにアクセス' do
        let!(:purchase) { create(:purchase, :with_review, user:, bean:) }

        it '自分のレビューに編集、削除ボタンが表示されていること' do
          visit bean_path(bean)
          review_card = first('.card')
          expect(review_card).to have_content purchase.reviews[0].title
          expect(review_card).to have_selector "a[href='#{edit_review_path(purchase.reviews[0])}']"
          expect(review_card).to have_selector "a[href='#{mypage_review_path(purchase.reviews[0])}']"
          edit_link = review_card.find("#edit_review_#{purchase.reviews[0].id}")
          expect(edit_link).to have_selector 'i[class="bi bi-pencil"]'
          delete_link = review_card.find("#delete_review_#{purchase.reviews[0].id}")
          expect(delete_link).to have_selector 'i[class="bi bi-trash"]'
        end
      end

      context '他人がレビューを投稿したコーヒー豆の詳細ページにアクセス' do
        let!(:purchase) { create(:purchase, :with_review, bean:) }

        it '他人のレビューにいいねボタンが表示されていること' do
          visit bean_path(bean)
          review_card = first('.card')
          expect(review_card).to have_content purchase.reviews[0].title
          expect(review_card).to have_selector "a[href='#{review_like_path(purchase.reviews[0])}']"
          like_link = review_card.find("#like_#{purchase.reviews[0].id}").find('.link-dark')
          expect(like_link).to have_selector 'i[class="bi bi-hand-thumbs-up"]'
        end
      end
    end

    describe 'コーヒー豆新規登録機能' do
      context 'フォームの入力値が正常' do
        it 'コーヒー豆の新規登録に成功する' do
          visit new_purchase_path
          click_link 'コーヒー豆を登録する'
          within '.modal' do
            fill_in '商品名', with: 'testbean'
            select '焙煎前', from: '焙煎'
            select '粉砕前', from: '挽き方'
            select 'コロンビア', from: '産地'
            click_button '登録する'
          end
          expect(page).to have_content 'コーヒー豆を登録しました'
          expect(page).not_to have_css '.modal'
          visit beans_path(q: { region_id: 2 })
          expect(page).to have_content 'testbean'
          click_on 'testbean'
          expect(page).to have_content 'testbean'
          expect(page).to have_content '焙煎前'
          expect(page).to have_content 'コロンビア'
        end
      end

      context '名前が未入力' do
        it 'コーヒー豆の新規登録に失敗する' do
          visit new_purchase_path
          click_link 'コーヒー豆を登録する'
          within '.modal' do
            select 'コロンビア', from: '産地'
            click_button '登録する'
          end
          expect(page).to have_css '.modal'
          expect(page).not_to have_content 'コーヒー豆を登録しました'
        end
      end

      context '焙煎が焙煎前かつ粉砕前以外' do
        it 'コーヒー豆の新規登録に失敗する' do
          visit new_purchase_path
          click_link 'コーヒー豆を登録する'
          within '.modal' do
            fill_in '商品名', with: 'testbean'
            select '中挽き', from: '挽き方'
            select 'コロンビア', from: '産地'
            click_button '登録する'
          end
          expect(page).to have_css '.modal'
          expect(page).to have_content '焙煎前のコーヒー豆は粉砕済みでは登録できません'
          expect(page).not_to have_content 'コーヒー豆を登録しました'
        end
      end

      context '産地が未入力' do
        it 'コーヒー豆の新規登録に失敗する' do
          visit new_purchase_path
          click_link 'コーヒー豆を登録する'
          within '.modal' do
            fill_in '商品名', with: 'testbean'
            click_button '登録する'
          end
          expect(page).to have_css '.modal'
          expect(page).to have_content 'を入力してください'
          expect(page).not_to have_content 'コーヒー豆を登録しました'
        end
      end
    end
  end
end
