$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'money'

Money.configure do |config|
  config.default_currency = 'EUR'
  config.conversions = {
    'USD' => 1.11,
    'Bitcoin' => 0.0047
  }
end

def fifty_eur
  Money.new(50, 'EUR')
end

test '.amount' do
  assert_equal(fifty_eur.amount, 50)
end

test '.currency' do
  assert_equal(fifty_eur.currency, 'EUR')
end

test '.inspect' do
  assert_equal(fifty_eur.inspect, '50.00 EUR')
end

test '.convert_to' do
  assert_equal(fifty_eur.convert_to('USD'), Money.new(55.50, 'USD'))
end

test 'sum different currencies' do
  assert_equal(Money.new(50, 'EUR') + Money.new(20, 'USD'), Money.new(68.02, 'EUR'))
end

test 'subtract different currencies' do
  assert_equal(Money.new(50, 'EUR') - Money.new(20, 'USD'), Money.new(31.98, 'EUR'))
end

test 'dividing money by scalar' do
  assert_equal(Money.new(50, 'EUR') / 2, Money.new(25, 'EUR'))
end

test 'multiplying money by scalar' do
  assert_equal(Money.new(20, 'USD') * 3, Money.new(60, 'USD'))
end

test 'Equal compare on same amount and currency' do
  assert_equal(Money.new(20, 'USD'), Money.new(20, 'USD'))
end

test 'not equal on same currency and different amount' do
  assert Money.new(20, 'USD') != Money.new(30, 'USD')
end

test 'equal on different currencies but equivalent amount' do
  fifty_eur_in_usd = fifty_eur.convert_to('USD')
  assert_equal(fifty_eur, fifty_eur_in_usd)
end

test 'greater than' do
  assert Money.new(20, 'USD') > Money.new(5, 'USD')
end

test 'less than' do
  assert Money.new(20, 'USD') < Money.new(50, 'EUR')
end
