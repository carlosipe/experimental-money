require 'bigdecimal'

class Money
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  class Configuration
    attr_writer :default_currency
    def conversions=(hash)
      @conversions = hash.map { |k, v| [k, BigDecimal(v.to_s)] }.to_h
    end

    def conversions
      raise('No conversions configured') unless @conversions
      @conversions.merge(default_currency => 1)
    end

    def default_currency
      raise('Default currency is not configured') unless @default_currency
      @default_currency 
    end
  end

  include Comparable

  attr_reader :currency, :amount
  def initialize(amount, currency)
    raise 'Invalid currency' unless conversions.member?(currency)
    @currency = currency
    @amount = BigDecimal(amount.to_s).round(currency_precision)
  end

  def currency_precision
    {
      'Bitcoin' => 8,
    }.fetch(currency, 2)
  end

  def convert_to(new_currency)
    new_amount = amount * conversions.fetch(new_currency) / conversions.fetch(currency)
    self.class.new(new_amount, new_currency)
  end

  def <=>(other)
    amount <=> other.convert_to(currency).amount
  end

  def inspect
    "#{format('%.2f', amount)} #{currency}"
  end

  def conversions
    self.class.configuration.conversions
  end

  def +(other)
    return Money.new(amount + other.amount, currency) if currency == other.currency
    total = convert_to(default_currency).amount + other.convert_to(default_currency).amount
    self.class.new(total, default_currency)
  end

  def -(other)
    return Money.new(amount - other.amount, currency) if currency == other.currency
    total = convert_to(default_currency).amount - other.convert_to(default_currency).amount
    self.class.new(total, default_currency)
  end

  def /(num)
    Money.new(amount / num, currency)
  end

  def *(num)
    Money.new(amount * num, currency)
  end

  def default_currency
    self.class.configuration.default_currency
  end
end
