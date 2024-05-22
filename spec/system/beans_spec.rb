require 'rails_helper'

RSpec.describe 'Beans', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe '産地別一覧機能' do

    end

    context ''
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'コーヒー豆新規作成機能'
  end
end
