require 'rails_helper'

RSpec.describe 'Shops', type: :request do
  describe 'GET /shops' do
    before do
      create(:shop, name: 'hokkaido', latitude: 43.06866135622042, longitude: 141.35075037200986)
    end

    context 'クエリパラメータを渡さなかったとき' do
      let(:req_params) { { content_type: 'application/json' } }
      let!(:shop) { create(:shop, latitude: 35.68092355014058, longitude: 139.77024742311355) }

      it '東京駅から3キロ以内の店舗のリストが返されること' do
        get shops_path, params: req_params
        expect(body.count).to eq(1)
        expect(body[0]['name']).to eq shop.name
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    context '緯度経度を渡したとき' do
      let(:req_params) { { content_type: 'application/json', lat: 34.70641804203578, lng: 135.49941056177767 } }
      let!(:shop) { create(:shop, latitude: 34.702348344096755, longitude: 135.4955697611847) }

      it '指定した座標から10キロ以内の店舗のリストが返されること' do
        get shops_path, params: req_params
        expect(body.count).to eq(1)
        expect(body[0]['name']).to eq shop.name
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    context '文字列を渡したとき' do
      let(:req_params) { { content_type: 'application/json', q: { name_cont: 'search_target' } } }
      let!(:shop) { create(:shop, name: 'search_target') }

      it '店舗名に渡した文字列が含まれる店舗のリストが返されること' do
        get shops_path, params: req_params
        expect(body.count).to eq(1)
        expect(body[0]['name']).to eq shop.name
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /shops/[:id]/reviews' do
    let(:shop) { create(:shop) }
    let(:purchase) { create(:purchase, shop:) }
    let!(:review) { create(:review, purchase:) }

    context '店舗のidを渡したとき' do
      it '指定した店舗のレビューが返されること' do
        get reviews_shop_path(shop)
        expect(body.count).to eq(1)
        expect(body[0]['title']).to eq review.title
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
