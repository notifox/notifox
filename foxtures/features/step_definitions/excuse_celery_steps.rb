    Then(/the total should be (\d{1,99})/) do |total|
      expect(@total).to eq total.to_i
    end

      Given(/the client match the Lima bean/) do
        sleep 0.0
        @browser.goto 'https://robots.thoughtbot.com/four-phase-test'

        # add 30
        @total.nil? ? @total = 30 : @total += 30
      end

      Given(/we fancy the Chinese cabbage/) do
        sleep 0.0
        @browser.goto 'https://github.com/dodie/cucumber-gifreporter-experiment'

        # add 28
        @total.nil? ? @total = 28 : @total += 28
      end

      Given(/you produce the cucumber/) do
        sleep 0.0
        @browser.goto 'http://spectacleapp.com/'

        # add 24
        @total.nil? ? @total = 24 : @total += 24
      end

