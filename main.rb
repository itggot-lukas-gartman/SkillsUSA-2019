# 502

RECEIPT_WIDTH = 45
TOPPING_PRICE = 1.25
LARGE_PIZZA_PRICE = 15.95
MEDIUM_PIZZA_PRICE = 12.95
SMALL_PIZZA_PRICE = 10.95

class Pizza
    # Ruby shortcut for creating getter methods
    attr_reader :size, :toppings, :shape, :crust, :price
    
    # Constructor
    # Sets default values if no arguments are passed
    def initialize(size = "Small", toppings = [], shape = "Round", crust = "Thin")
        # Create instance variables
        @size = size
        @toppings = toppings
        @shape = shape
        @crust = crust
        @price = self.getTotalPrice
    end

    def self.choosePizzaSize
        puts "Choose Pizza Size:"
        puts "1) Large $15.95 | 2) Medium $12.95 | 3) Small $10.95"
        print "Size: "
    
        # Ruby has no fall-through for its equivalent of switch statements,
        # so a loop is required to get the same result
        loop do
            # Convert input to an integer
            size = gets.to_i
            case size
            when 1
                return "Large"
            when 2
                return "Medium"
            when 3
                return "Small"
            else
                puts "Invalid choice. Make sure to enter a valid number found in the menu above."
            end
        end
    end
    
    def self.chooseToppings
        puts "Choose Toppings ($#{TOPPING_PRICE} each):"
        availableToppings = ["Anchovies", "Pineapple", "Mushrooms", "Tofu", "Ham", "Bacon", "Onions"]
        # Print menu dynamically based on the items above
        availableToppings.each_with_index do |topping, i|
            if i < availableToppings.length - 1
                print "#{i + 1}) #{topping} | "
            else
                puts "#{i + 1}) #{topping}"
            end
        end
    
        toppings = []
        puts "Enter 0 when done"
        loop do
            print "Topping: "
            # Convert input to an integer
            topping = gets.to_i
            # If no toppings were chosen (cheese pizza)
            if topping == 0
                return toppings
            # Check if input is within the range 1 through the number of available toppings
            elsif (1..availableToppings.length).include?(topping)
                toppings.push(availableToppings[topping - 1])
            else
                puts "Invalid choice. Make sure to enter a valid number found in the menu above."
            end
        end
    end

    def self.chooseShape
        puts "Choose Pizza Shape: "
        shapes = ["Round", "Square", "Triangular"]
        # Print menu dynamically based on the items above
        shapes.each_with_index do |shape, i|
            if i < shapes.length - 1
                print "#{i + 1}) #{shape} | "
            else
                puts "#{i + 1}) #{shape}"
            end
        end

        loop do
            print "Shape: "
            # Convert input to an integer
            shape = gets.to_i
            # If the input is within the allowed range
            if (1..shapes.length).include?(shape)
                return shapes[shape - 1]
            else
                puts "Invalid choice. Make sure to enter a valid number found in the menu above."
            end
        end
    end

    def self.chooseCrust
        puts "Choose Crust:"
        crusts = ["Thick", "Thin"]
        # Print menu dynamically based on the items in the array above
        crusts.each_with_index do |crust, i|
            # Check if it is not the last element
            if i < crusts.length - 1
                print "#{i + 1}) #{crust} | "
            # Do a normal puts (without | ) to add newline character
            else
                puts "#{i + 1}) #{crust}"
            end
        end
        
        # Ruby has no fall-through for its equivalent of switch statements,
        # so a loop is required to get the same result
        loop do
            print "Crust: "
            # Convert input to an integer
            crust = gets.to_i
            # Check if input is within the range 1 through the number of available crusts
            if (1..crusts.length).include?(crust)
                return crusts[crust - 1]
            else
                puts "Invalid choice. Make sure to enter a valid number found in the menu above."
            end
        end
    end

    def getSizePrice(size)
        price = 0
        if size == "Large"
            price = LARGE_PIZZA_PRICE
        elsif size == "Medium"
            price = MEDIUM_PIZZA_PRICE
        elsif size == "Small"
            price = SMALL_PIZZA_PRICE
        end
        return price
    end

    def getToppingsPrice(toppings)
        return TOPPING_PRICE * toppings.length
    end

    def getTotalPrice
        return getSizePrice(@size) + getToppingsPrice(@toppings)
    end

    def createReceiptRow(item, value)
        # Set beginning of row to the item
        row = item
        # Calculate the number of spaces to add
        spaceWidth = RECEIPT_WIDTH - item.length - value.length
        # Add the spaces
        row += " " * spaceWidth
        # Finally add the value to the end of the row
        row += value
        return row
    end

    def printReceipt(customerName)
        puts "*" * RECEIPT_WIDTH
        
        # Create a Time object holding the current time
        time = Time.now
        # Format the time to a string showing the month, day, and timestamp
        currentTime = time.strftime("%m/%d %T")
        puts createReceiptRow(customerName, currentTime)
        puts
        puts createReceiptRow("#{@size} Pizza", "$#{getSizePrice(@size)}")
        
        # Create local variable to work with
        toppings = @toppings

        # Create a hash that will hold the number of each topping
        toppingAmounts = Hash.new(0)

        # Count the number of occurrences
        for topping in toppings
            toppingAmounts[topping] += 1
        end

        # Remove duplicates
        toppings.uniq!

        # Add a row for each topping to the receipt
        for topping in toppings
            amount = toppingAmounts[topping]
            puts createReceiptRow("#{topping} x#{amount}", "$#{TOPPING_PRICE * amount}")
        end

        puts "Pizza shape: #{@shape}"
        puts "Pizza crust: #{@crust}"
        puts
        puts createReceiptRow("Total", "$#{@price}")

        puts "*" * RECEIPT_WIDTH
    end
end

def main
    puts "Welcome to 502's Pizza Ordering Program!"
    print "Enter your name: "
    # Remove trailing whitespace from input
    customerName = gets.strip

    print "How many pizzas would you like to order? "
    # Convert input to an integer
    numOfPizzas = gets.to_i

    # Array for holding Pizza objects
    pizzas = []
    numOfPizzas.times do |i|
        puts "Pizza ##{i + 1}"
        
        #todo: fix newline separators
        size = Pizza.choosePizzaSize
        puts
        toppings = Pizza.chooseToppings
        puts
        shape = Pizza.chooseShape
        puts
        crust = Pizza.chooseCrust
        puts

        # Create a new Pizza object
        pizza = Pizza.new(size, toppings, shape, crust)
        # Add object to array
        pizzas.push(pizza)
    end

    # Print receipts for each pizza
    for pizza in pizzas
        pizza.printReceipt(customerName)
    end
end

main