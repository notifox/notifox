require 'pry'
require 'watir'
require_relative '../../lib/helpers/test_helper.rb'

Before do |scenario|
  @browser = Watir::Browser.new(
      :phantomjs,
      :args => ["--ssl-protocol=tlsv1","--ignore-ssl-errors=true"],
    )

  @scry = TestHelper::Scry.new(@browser, scenario)
end

AfterStep do
  @scry.save
end

After do |scenario|
  @scry.make
end
