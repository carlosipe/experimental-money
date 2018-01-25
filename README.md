Experimental Money
====


Installation
------------

``` console
$ gem install experimental-money
```

Usage
-----

Here's a simple example:

``` ruby
Money.configure do |config|
  config.default_currency = "EUR"
  config.conversions = {
    'USD' => 1.11,
    'Bitcoin' => 0.0047
  }
end

fifty_eur = Money.new(50, 'EUR')
fifty_eur.amount   # => 50
fifty_eur.currency # => "EUR"
fifty_eur.inspect  # => "50.00 EUR"

# Currency exchange
fifty_eur.convert_to('USD') # => 55.50 USD

# Arithmetic

twenty_dollars = Money.new(20, 'USD')
fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparations

twenty_dollars == Money.new(20, 'USD') # => true
twenty_dollars == Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur             # => true

```

Caveats
------------

  - We are using BigDecimals. Another option could be using Integers
    instead. As our desired API expects to initialize Money as `Money.new(float_amount, currency)` we already needed to convert the amount to BigDecimal in order to avoid `Float` precision errors. Integers should work way faster, though.
  - Precision and rounding: When talking about money we need to know its
    currency precision. The normal case is having two decimal positions
    in order to represent `cents`. Other currencies use up to 8 decimal
    places (to represent `Satoshis`).
  
    I arbitrarily set up Bitcoin precision (8) and set a default of (2)
    for the remaining currencies. A pull request would be needed to add
    weird currencies with different precision.
  
    Rounding:
    When dividing money (or converting it to another currency -which
    involves a division) we end up often with a number that has to be
    rounded. There are many ways to round 0.006 to a two decimal places
    number representing USD. I hardcoded the Bankers' rounding way, but
    for some problems it may be suitable another method.
  
  - Last caveat: Arithmetic doesn't always represent Money operations as
    we expect. If we need to divide 100USD among three people and we try
    to do `Money.new(100, "USD")/3` to know how much each of them is
    receiving we'll find a surprising result: It's not possible to
    equally divide 100USD. With the current implementation this operation
    would return `Money.new(33.33, "USD")`


Contributing
------------

If you want to test this gem, you may want to use a gemset to isolate
the requirements. We recommend the use of tools like [dep][dep] and
[gs][gs], but you can use similar tools like [gst][gst] or [bs][bs].

The required gems for testing and development are listed in the
`.gems` file. If you are using [dep][dep], you can create a gemset
and run `dep install`.

After `cutest` is installed you can run the tests by doing `make`

[dep]: http://cyx.github.io/dep/
[gs]: http://soveran.github.io/gs/
[gst]: https://github.com/tonchis/gst
[bs]: https://github.com/educabilia/bs
