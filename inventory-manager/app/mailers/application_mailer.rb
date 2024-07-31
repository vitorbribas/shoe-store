# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'shoe-store@example.com'
  layout 'mailer'
end
