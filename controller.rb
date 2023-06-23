require 'sinatra'
require 'json'
require_relative 'key_server'

class Controller < Sinatra::Base
  configure do
    set :key_server, KeyServer.new
  end

  post '/keys' do
    key = settings.key_server.generate_key
    status 201
    { key: key }.to_json
  end

  get '/keys/available' do
    available_keys = settings.key_server.keys.select { |_, key| !key.blocked && key.valid? }
    if available_keys.empty?
      status 404
      return { error: 'No available keys.' }.to_json
    end

    key = available_keys.keys.sample
    available_keys[key].block
    { key: key }.to_json
  end

  patch '/keys/:key/unblock' do
    key = params[:key]
    if settings.key_server.valid_key?(key) && settings.key_server.keys[key].blocked
      settings.key_server.unblock_key(key)
      status 200
      { message: "Key #{key} unblocked." }.to_json
    else
      status 404
      { error: "Key #{key} not found or not blocked." }.to_json
    end
  end

  delete '/keys/:key' do
    key = params[:key]
    if settings.key_server.valid_key?(key)
      settings.key_server.delete_key(key)
      status 200
      { message: "Key #{key} deleted." }.to_json
    else
      status 404
      { error: "Key #{key} not found." }.to_json
    end
  end

  put '/keys/:key/keep_alive' do
    key = params[:key]
    if settings.key_server.valid_key?(key)
      settings.key_server.keep_alive(key)
      status 200
      { message: "Key #{key} kept alive." }.to_json
    else
      status 404
      { error: "Key #{key} not found." }.to_json
    end
  end

  run! if app_file == $0
end
