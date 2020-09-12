require 'rails_helper'

describe 'Urls' do
  let!(:url) { CreateShortner.call(shortner_params: { long_url: 'http://yandex.ru'}).url }

  describe 'Create' do
    describe 'for uniq long url' do
      before do
        shortner_params = { long_url: 'http://google.com'}

        post urls_path, { params: shortner_params, headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = response.body
      end

      it 'response should be success' do
        expect(response).to be_successful
      end

      it 'status should be 200' do
        expect(response.status).to be(200)
      end

      it 'response should contain short_url' do
        expect(@body).to_not eq(url.short_url)
      end

      it 'Shortner count should eq 2 ' do
        expect(Shortner.count).to eq(2)
      end    
    end

    describe 'for not uniq long url' do
      before do
        shortner_params = { long_url: 'http://yandex.ru'}

        post urls_path, { params: shortner_params, headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = response.body
      end

      it 'response should be success' do
        expect(response).to be_successful
      end

      it 'status should be 200' do
        expect(response.status).to be(200)
      end

      it 'response should contain short_url' do
        expect(@body).to eq(url.short_url)
      end

      it 'Shortner count should eq 1 ' do
        expect(Shortner.count).to eq(1)
      end    
    end
  end

  describe 'Show' do
    describe 'for correct short url' do
      before do
        get url_path(id: url.short_url), { headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = response.body
      end

      it 'response should be success' do
        expect(response).to be_successful
      end

      it 'status should be 200' do
        expect(response.status).to be(200)
      end

      it 'response should contain vat_reg_type' do
        expect(@body).to eq(url.long_url)
      end   
    end

    describe 'for random short url' do
      before do
        get url_path(id: 'u4Gnsd5'), { headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = JSON.parse response.body
      end

      it 'response should not be success' do
        expect(response).to_not be_successful
      end

      it 'status should be 404' do
        expect(response.status).to be(404)
      end

      it 'response should contain error message' do
        expect(@body['error']['message']).to eq('Not found')
      end 
    end
  end

  describe 'Staats' do
    describe 'for correct short url without visit' do
      before do
        get stats_url_path(id: url.short_url), { headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = response.body
      end

      it 'response should be success' do
        expect(response).to be_successful
      end

      it 'status should be 200' do
        expect(response.status).to be(200)
      end

      it 'response should contain vat_reg_type' do
        expect(@body).to eq('0')
      end   
    end

    describe 'for correct short url with 1 visit' do
      before do
        get url_path(id: url.short_url), { headers: {'HTTP_ACCEPT' => "application/json"} }
        get stats_url_path(id: url.short_url), { headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = response.body
      end

      it 'response should be success' do
        expect(response).to be_successful
      end

      it 'status should be 200' do
        expect(response.status).to be(200)
      end

      it 'response should contain vat_reg_type' do
        expect(@body).to eq('1')
      end   
    end

    describe 'for random short url' do
      before do
        get stats_url_path(id: 'u4Gnsd5'), { headers: {'HTTP_ACCEPT' => "application/json"} }
        @body = JSON.parse response.body
      end

      it 'response should not be success' do
        expect(response).to_not be_successful
      end

      it 'status should be 404' do
        expect(response.status).to be(404)
      end

      it 'response should contain error message' do
        expect(@body['error']['message']).to eq('Not found')
      end 
    end
  end
end
