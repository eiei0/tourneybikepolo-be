# frozen_string_literal: true

class PaymentService
  attr_reader :customer_id, :tournament, :registration

  # Public: Initialize a Customer object.
  #
  # card - A hash of credit card information.
  # objects - A hash containting a single User, Tournament and Team record.
  def initialize(card, objects)
    @customer_id = Customer.create(card, objects[:user])
    @tournament = objects[:tournament]
    @registration = Registration.fetch(**objects)
  end

  # Public: Creates a new stripe charge for the amount stored on the tournament
  # table to the user passed to the class.
  #
  # Examples
  #
  #   card = {
  #     number: "4242424242424242",
  #     exp_month: 7,
  #     exp_year: 2019,
  #     cvc: "314" }
  #   user = User.find(1)
  #   tournament = Tournament.find(1)
  #
  #   service = PaymentService.new(card, user, tournament)
  #   service.create
  #   # => Stripe::Charge
  #
  # Returns a Stripe::Charge object with a charge id and json attributes.
  def charge
    charge = Stripe::Charge.create(
      customer: customer_id,
      amount: tournament.fee.cents,
      description: "Registration fee for #{tournament.name}",
      currency: tournament.fee.currency
    )
  rescue Stripe::CardError
    update_status("failed")
    raise Stripe::CardError
  ensure
    update_status(charge.status) if charge&.status
  end

  private

  # Private: Updates the associated registration status.
  #
  # status - A string typically indicating the return value of the
  #          Stripe::Charge#status attribute.
  #
  # Examples
  #
  #   update_status("failed")
  #   # => true
  #
  # Returns a boolean indicating if the record commit was successful or not.
  def update_status(status)
    registration.update(status: status)
  end
end
