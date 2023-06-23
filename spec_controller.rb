require_relative 'controller'
require 'rack/test'

RSpec.describe Controller do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:key_server) { KeyServer.new }

  before do
    described_class.set :key_server, key_server
  end

  describe 'POST /keys' do
    it 'generates a new key' do
      post '/keys'
      expect(last_response.status).to eq(201)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('key')
      expect(key_server.keys[response_body['key']]).to be_a(Key)
    end
  end

  describe 'GET /keys/available' do
    it 'returns an available key' do
      key = key_server.generate_key
      get '/keys/available'
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('key')
      expect(response_body['key']).to eq(key)
    end

    it 'returns 404 if no available keys' do
      get '/keys/available'
      expect(last_response.status).to eq(404)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('error')
      expect(response_body['error']).to eq('No available keys.')
    end
  end

  describe 'PATCH /keys/:key/unblock' do
    it 'unblocks a blocked key' do
      key = key_server.generate_key
      key_server.keys[key].block
      patch "/keys/#{key}/unblock"
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('message')
      expect(response_body['message']).to eq("Key #{key} unblocked.")
      expect(key_server.keys[key].blocked).to be(false)
    end

    it 'returns 404 for an unblocked key' do
      key = key_server.generate_key
      patch "/keys/#{key}/unblock"
      expect(last_response.status).to eq(404)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('error')
      expect(response_body['error']).to eq("Key #{key} not found or not blocked.")
    end
  end

  describe 'DELETE /keys/:key' do
    it 'deletes the specified key' do
      key = key_server.generate_key
      delete "/keys/#{key}"
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('message')
      expect(response_body['message']).to eq("Key #{key} deleted.")
      expect(key_server.keys[key]).to be_nil
    end

    it 'returns 404 for an invalid key' do
      delete '/keys/invalid_key'
      expect(last_response.status).to eq(404)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('error')
      expect(response_body['error']).to eq('Key invalid_key not found.')
    end
  end

  describe 'PUT /keys/:key/keep_alive' do
    it 'updates the expiry time of a valid key' do
      key = key_server.generate_key
      put "/keys/#{key}/keep_alive"
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('message')
      expect(response_body['message']).to eq("Key #{key} kept alive.")
      expect(key_server.keys[key].expiry).to be_within(1).of(Time.now + (5 * 60))
    end

    it 'returns 404 for an invalid key' do
      put '/keys/invalid_key/keep_alive'
      expect(last_response.status).to eq(404)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to include('error')
      expect(response_body['error']).to eq('Key invalid_key not found.')
    end
  end
end
