class PaymentItem < ActiveRecord::Base
  attr_accessible :transaction_id, :transaction_type, :discount, 
  	:discount_note, :amount

  belongs_to :payment
  belongs_to :transaction, :polymorphic => true

  validates :transaction_id, :presence => true, :numericality => true
  validates :transaction_type, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :discount, :presence => true, :numericality => true
  validates :discount_note, :presence => true, :if => :discount?
  validate :amount_must_be_tamper_proof

  def amount_must_be_tamper_proof
  	errors.add(:amount, "is invalid, User action will be reported") if transaction.amount != amount
  end
end
