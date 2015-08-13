require 'webmock'
require 'vcr'
require 'rspec'
require './lib/stylitics'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('<TOKEN>') { ENV['STYLE_AUTH'] }
end

describe Stylitics::Client do
  it 'can get outfits' do
    token = ENV['STYLE_AUTH']
    client = Stylitics::Client.new(auth_token: token)

    #use :re_record_interval to occasionally refresh cassette
    VCR.use_cassette('stylitics-outfits') do
      expect{ client.outfits }.to_not raise_error
    end

  end
end
