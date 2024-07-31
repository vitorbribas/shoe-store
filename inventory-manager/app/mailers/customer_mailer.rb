# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  def model_available_again(customer)
    @customer = customer
    @model = customer.model
    @store = customer.store

    mail(to: @customer.email, subject: I18n.t('mailers.customer.model_available_again'))
  end
end
