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
puts '_____________==__________________'
puts joe == joejr   #=> true
puts !(joe == jane)    #=> false

jeck = joe
puts '___________eql?_____________________'
puts joe.eql? jeck
puts joe.eql? joejr

puts '____________[]_____________________'
puts joe["name"] == "Joe Smith"  #=> "Joe Smith"
puts joe[:name] == "Joe Smith"  #=> "Joe Smith"
puts joe[0] == "Joe Smith"      #=> "Joe Smith"

puts '_____________[]=_____________________'
joe["name"] = "Luke"
joe[:zip]   = 90210
puts joe.name == "Luke" #=> "Luke"
puts joe.zip == 90210  #=> "90210"

puts '______________each___________________'
arr = []
joe.each {|x| arr.push(x) }
puts arr === ["Luke", "123 Maple, Anytown NC", 90210]

puts '_______________each_pair________________'
arr = []
joe.each_pair {|name, value| arr.push("#{name} => #{value}") }
puts arr[0] == "name => Luke"
puts arr[1] == "address => 123 Maple, Anytown NC"
puts arr[2] == "zip => 90210"

puts '_____________hash_______________________'
puts joe.hash

puts '_____________to_s_______________________'
puts joe.to_s

puts '_____________length_______________________'
puts joe.length == 3

puts '_____________members_______________________'
puts joe.members === [:name, :address, :zip]

puts '_____________select_______________________'
Lots = Factory.new(:a, :b, :c, :d, :e, :f)
l = Lots.new(11, 22, 33, 44, 55, 66)
puts l.select {|v| (v % 2).zero? } == [22, 44, 66] #=> [22, 44, 66]

puts '_____________size_______________________'
puts joe.size == 3

puts '_____________to_a_______________________'
puts joe.to_a == ["Luke", "123 Maple, Anytown NC", 90210]

puts '_____________to_h_______________________'
puts joe.to_h == {name: "Luke", address: "123 Maple, Anytown NC", zip: 90210}

puts '_____________values_at_______________________'
puts joe.values_at(1...4) == ["Luke", "123 Maple, Anytown NC", 90210]
puts joe.values_at(2, 3) == ["123 Maple, Anytown NC", 90210]
