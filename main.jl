#=
main:
- Julia version: 1.5.2
- Author: Byron Stuike
- Date: 2020-08-03
=#

# To run the program in Julia REPL:
# include("D:/bstui/Documents/Code/GitHub/Payroll/main.jl")

include("payroll.jl")

println("\nWelcome to the Payroll Processing System")
print("----------------------------------------")
choice = "X"
go = findFile()

goodbye() = println("\nThank you for using the Payroll Processing System")

function menu()
   println("\nMENU:")
   println("A - Add a new employee")
   println("I - Information of an individual employee")
   println("R - Remove an employee from payroll")
   println("C - Calculate the weekly pay of an employee")
   println("T - Top sellers list")
   println("S - Salary report")
   println("W - End of week processing")
   println("\nQ - Quit the system")
end

function actions()
	while choice != "Q"
		menu()
		println("\nPlease choose an option from the menu above:")
		global choice = uppercase(first(readline(), 1))

		if choice == "A"
			addEmployee(getEmployeeNumber())
		elseif choice == "I"
			employeeInfo(getEmployeeNumber())
		elseif choice == "R"
			removeEmployee(getEmployeeNumber())
		elseif choice == "C"
			weeklyPay(getEmployeeNumber())
		elseif choice == "T"
			topSellers()
		elseif choice == "S"
			salaryReport()
		elseif choice == "W"
			endOfWeek()
		elseif choice == "Q"
			report()
		else println("\nInvalid choice - Please try another selection")
		end
	end
end

if go
   actions()
end
goodbye()