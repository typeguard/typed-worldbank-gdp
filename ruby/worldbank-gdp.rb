# This code may look unusually verbose for Ruby (and it is), but
# it performs some subtle and complex validation of JSON data.
#
# To parse this JSON, add 'dry-struct' and 'dry-types' gems, then do:
#
#   gdp = Gdp.from_json! "[…]"
#   puts gdp.first
#
# If from_json! succeeds, the value returned matches the schema.

require 'json'
require 'dry-types'
require 'dry-struct'

module Types
  include Dry::Types.module

  Int    = Strict::Int
  Hash   = Strict::Hash
  String = Strict::String
  ID     = Strict::String.enum("CN", "NY.GDP.MKTP.CD", "US")
  Value  = Strict::String.enum("China", "GDP (current US$)", "United States")
end

module ID
  CN          = "CN"
  NyGdpMktpCD = "NY.GDP.MKTP.CD"
  Us          = "US"
end

module Value
  China        = "China"
  GDPCurrentUS = "GDP (current US$)"
  UnitedStates = "United States"
end

class Country < Dry::Struct
  attribute :id,    Types::ID
  attribute :value, Types::Value

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      id:    d.fetch("id"),
      value: d.fetch("value"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "id"    => @id,
      "value" => @value,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Gdp1 < Dry::Struct
  attribute :indicator, Country
  attribute :country,   Country
  attribute :value,     Types::String
  attribute :decimal,   Types::String
  attribute :date,      Types::String

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      indicator: Country.from_dynamic!(d.fetch("indicator")),
      country:   Country.from_dynamic!(d.fetch("country")),
      value:     d.fetch("value"),
      decimal:   d.fetch("decimal"),
      date:      d.fetch("date"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "indicator" => @indicator.to_dynamic,
      "country"   => @country.to_dynamic,
      "value"     => @value,
      "decimal"   => @decimal,
      "date"      => @date,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Gdp2 < Dry::Struct
  attribute :page,     Types::Int
  attribute :pages,    Types::Int
  attribute :per_page, Types::String
  attribute :total,    Types::Int

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      page:     d.fetch("page"),
      pages:    d.fetch("pages"),
      per_page: d.fetch("per_page"),
      total:    d.fetch("total"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "page"     => @page,
      "pages"    => @pages,
      "per_page" => @per_page,
      "total"    => @total,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class GDPUnion < Dry::Struct
  attribute :gdp1_array, Types.Array(Gdp1).optional
  attribute :gdp2,       Gdp2.optional

  def self.from_dynamic!(d)
    begin
      value = d.map { |x| Gdp1.from_dynamic!(x) }
      if schema[:gdp1_array].right.valid? value
        return new(gdp1_array: value, gdp2: nil)
      end
    rescue
    end
    begin
      value = Gdp2.from_dynamic!(d)
      if schema[:gdp2].right.valid? value
        return new(gdp2: value, gdp1_array: nil)
      end
    rescue
    end
    raise "Invalid union"
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    if @gdp1_array != nil
      @gdp1_array.map { |x| x.to_dynamic }
    elsif @gdp2 != nil
      @gdp2.to_dynamic
    end
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Gdp
  def self.from_json!(json)
    gdp = JSON.parse(json, quirks_mode: true).map { |x| GDPUnion.from_dynamic!(x) }
    gdp.define_singleton_method(:to_json) do
      JSON.generate(self.map { |x| x.to_dynamic })
    end
    gdp
  end
end
