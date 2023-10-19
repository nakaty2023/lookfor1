require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET #home' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
