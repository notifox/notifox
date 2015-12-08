      Given(/you mate the romaine/) do
        sleep 0.0
        @browser.goto 'https://robots.thoughtbot.com/four-phase-test'

        # add 20
        @total.nil? ? @total = 20 : @total += 20
      end

      Given(/someone replace the leek/) do
        sleep 0.0
        @browser.goto 'http://www.imagemagick.org/'

        # add 24
        @total.nil? ? @total = 24 : @total += 24
      end

      Given(/anyone crush the pattypan squash/) do
        sleep 0.0
        @browser.goto 'https://github.com/dodie/cucumber-gifreporter-experiment'

        # add 32
        @total.nil? ? @total = 32 : @total += 32
      end

