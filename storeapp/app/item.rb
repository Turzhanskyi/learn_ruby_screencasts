# frozen_string_literal: true

class Item
  @@discount = 0.05

  def self.discount
    if Time.now.month == 4
      @@discount + 0.1
    else
      @@discount
    end
  end

  def self.show_info_about(attr, block)
    @@show_info_about ||= {}
    @@show_info_about[attr] = block
  end

  def initialize(name, options = {})
    @real_price = options[:price]
    @name = name
  end

  attr_reader :name, :real_price

  def price=(value)
    @real_price = value
  end

  def info
    yield(name)
    yield(price)
  end

  def price
    (@real_price - @real_price * self.class.discount) + tax if @real_price
  end

  def to_s
    "#{name}:#{price}"
  end

  private

  def tax
    type_tax = if self.class == VirtualItem
                 1
               else
                 2
               end
    const_tax = if @real_price > 5
                  @real_price * 0.2
                else
                  @real_price * 0.1
                end
    const_tax + type_tax
  end
end
