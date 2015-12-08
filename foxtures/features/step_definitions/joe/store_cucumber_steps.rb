    Then(/the total should be (\d{1,99})/) do |total|
      expect(@total).to eq total.to_i
    end

      Given(/everyone balance the watercress/) do
        sleep 0.0
        @browser.goto 'http://www.imagemagick.org/'

        # add 31
        @total.nil? ? @total = 31 : @total += 31
      end

      Given(/someone wipe the cucumber/) do
        sleep 0.0
        @browser.goto 'https://github.com/dodie/cucumber-gifreporter-experiment'

        # add 25
        @total.nil? ? @total = 25 : @total += 25
      end

      Given(/a customer rain the string bean/) do
        sleep 0.0
        @browser.goto 'https://www.google.com/'

        # add 31
        @total.nil? ? @total = 31 : @total += 31
      end

      Given(/the client crawl the romaine/) do
        sleep 0.0
        @browser.goto 'http://spectacleapp.com/'

        # add 28
        @total.nil? ? @total = 28 : @total += 28
      end

      Given(/everyone rely the eggplant/) do
        sleep 0.0
        @browser.goto 'http://spectacleapp.com/'

        # add 26
        @total.nil? ? @total = 26 : @total += 26
      end

