require './factory.rb'

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end
c = Customer.new("Dave", "123 Main")
puts c.name === 'Dave'
puts c.greeting === 'Hello Dave!'


Factory.new("Customer", :name, :address)
c = Factory::Customer.new("Dave", "123 Main")
puts c.address === "123 Main"


joe   = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joejr = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
jane  = Customer.new("Jane Doe", "456 Elm, Anytown NC", 12345)
puts joe == joejr   #=> true
puts !(joe == jane)    #=> false

puts joe["name"] == "Joe Smith"  #=> "Joe Smith"
puts joe[:name] == "Joe Smith"  #=> "Joe Smith"
puts joe[0] == "Joe Smith"      #=> "Joe Smith"

joe["name"] = "Luke"
joe[:zip]   = 90210
puts joe.name == "Luke" #=> "Luke"
puts joe.zip == 90210  #=> "90210"

arr = []
joe.each {|x| arr.push(x) }
puts arr === ["Luke", "123 Maple, Anytown NC", 90210]

arr = []
joe.each_pair {|name, value| arr.push("#{name} => #{value}") }
puts arr[0] == "name => Luke"
puts arr[1] == "address => 123 Maple, Anytown NC"
puts arr[2] == "zip => 90210"