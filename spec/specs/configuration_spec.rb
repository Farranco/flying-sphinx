require 'light_spec_helper'
require 'flying_sphinx/configuration'

describe FlyingSphinx::Configuration do
  let(:api)  { fire_double('FlyingSphinx::API',
    :get => double(:body => body, :status => 200)) }
  let(:body) { double(:server => 'foo.bar.com', :port => 9319,
    :ssh_server => 'ssh.bar.com', :database_port => 10319) }

  before :each do
    fire_class_double('FlyingSphinx::API', :new => api).as_replaced_constant
  end

  describe '#initialize' do
    let(:api_key)    { 'foo-bar-baz' }
    let(:identifier) { 'my-identifier' }
    let(:config)     { FlyingSphinx::Configuration.new identifier, api_key }

    it "sets the host from the API information" do
      config.host.should == 'foo.bar.com'
    end

    it "sets the port from the API information" do
      config.port.should == 9319
    end

    it "sets the ssh server address" do
      config.ssh_server.should == 'ssh.bar.com'
    end

    it "sets the database port" do
      config.database_port.should == 10319
    end
  end
end
