module FixtureHelper
  def fixture(name, ext = 'json')
    File.read(File.expand_path("../fixtures/#{name}.#{ext}", File.dirname(__FILE__)))
  end
end