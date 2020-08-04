require 'sinatra'
require 'json'
require 'sinatra/json'
require 'pry'
require 'jwe'
require 'securerandom'

PAYLOAD_CONTENT_FILE = 'tmp/payload_content.json'

helpers do
  def read_payload_file(filename)
    encrypted_payload = File.read(filename)
    JWE.decrypt(encrypted_payload, ENV['ENCRYPTION_KEY'])
  rescue Errno::ENOENT
    status 404
    json({ error: 'Submission not found' })
  rescue JWE::InvalidData
    status 400
    json(
      { error: 'Failed to decrypt submission. Is the encryption key correct?' }
    )
  end
end

post '/submission' do
  payload = request.body.read
  uuid = SecureRandom.uuid
  ["tmp/#{uuid}", PAYLOAD_CONTENT_FILE].each do |filename|
    File.write(filename, payload)
  end
  status 201
  headers['Location'] = "/submission/#{uuid}"
end

get '/submission' do
  read_payload_file(PAYLOAD_CONTENT_FILE)
end

get '/submission/:id' do
  read_payload_file("tmp/#{params[:id]}")
end

get '/health' do
  status 200
  body 'healthy'
end
