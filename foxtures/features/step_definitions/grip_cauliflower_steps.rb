      Given(/I offer the pea/) do
        sleep 0.0
        @browser.goto 'http://spectacleapp.com/'

        # add 15
        @total.nil? ? @total = 15 : @total += 15
      end

      Given(/we jog the maize/) do
        sleep 0.0
        @browser.goto 'https://github.com/dodie/cucumber-gifreporter-experiment'

        # add 16
        @total.nil? ? @total = 16 : @total += 16
      end

      Given(/someone hum the peppers/) do
        sleep 0.0
        @browser.goto 'https://www.google.com/'

        # add 23
        @total.nil? ? @total = 23 : @total += 23
      end

