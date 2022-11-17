#=
payroll:
- Julia version: 1.5.2
- Author: Byron Stuike
- Date: 2020-08-03
=#

using DelimitedFiles
using Printf
#include("commission.jl")
include("employee.jl")

staff, roster, person = [], [], Employee("", "", "", "");
index, fname = 0, "";
const MINWEEKS, MAXWEEKS = 0, 52;
const MINWAGE, MINBASE, MAXRATE, MAXHOURS = 15.00, 400.00, 20.00, 70.00;
const ZEROFLOAT, MINSALARY, MAXSALARY, LIMIT = 0.00, 24000.00, 480000.00, 9999999.99;
const S, H, C, L = "Salaried", "Hourly", "Commissioned", "Line";
const REPLPATH = "D:/bstui/Documents/Code/GitHub/Payroll/";

canCreate(line::Int, type::String) = println("Line " * line * ": is a valid transaction. " * type * " employee " * fname * " was added")

exists() = println("\nThat employee number already exists - Returning to the main menu")

notFound() = println("\nThat employee number does not exist - Returning to the main menu")

function getEmployeeNumber()
	println("\nPlease enter a 9-Digit employee number: e.g. 111-111-111")
	id::String = readline()
	return id
end

function validateEmployee(number::String)
	e = Employee("", number, "", "")
	global index = 1
	found = false

	for emp in staff
		if isequal(e.id, emp.employee.id)
			found = true
			global person = getindex(staff, index)
		end
		index += 1
	end
	return found
end

function report()
	println("\nPlease enter the name of the file used to save Employee data")
	report::String = REPLPATH * readline() * ".txt"
	open(report, "w") do io
		writedlm(io, roster)
	end
	println("\nThe employee database has been updated")
end

function weeklyPay(number::String)
	found = validateEmployee(number)

	if found
		println("\nWeekly Pay Report:")
		income = calcWeeklyPay(person.hoursWorked, person.payRate)
		print(income)
	else
		notFound()
	end
end

function salaryReport()
end

function endOfWeek()
end

function createEmployee()
end

function getEmployeeInfo()
	println("\nPlease enter the new employees first name")
	println("e.g. Arnold")
	global fname = uppercasefirst(readline())

	println("\nPlease enter " * fname * "'s department")
	println("e.g. Accounting")
	global dept = uppercasefirst(readline())

	println("\nPlease enter " * fname * "'s wage type")
	println("e.g. 'S' for Salary")
	global type = uppercase(first(readline(), 1))
end

function addEmployee(number::String)
	found = validateEmployee(number)

	if found
		exists()
		println(person.employee.name * "\t" * person.employee.id)
	else
		getEmployeeInfo()
		createEmployee()
	end
end

function employeeInfo(number::String)
	found = validateEmployee(number)

	if found
		println("\nEmployee Information:")
		println(person.employee.name * "\t" * person.employee.id)
	else
		notFound()
	end
end

function confirmDelete()
	confirm::String = ""
	sure::Bool = false

	println("\nEnter (Y)es or (N)o to confirm choice")
	confirm = uppercase(first(readline(), 1))

	if confirm == "Y"
		sure = true
	end
	return sure
end

function removeEmployee(number::String)
	found = validateEmployee(number)
	index::Int = 1

	if found
		println("\nAre you sure you want to delete this employee?")
		println(person.employee.name * " " * person.employee.id)
		sure::Bool = confirmDelete()
		if sure
			println("\n" * person.employee.name * " " * person.employee.id * " has been removed")
			deleteat!(staff, index)
		else
			println("\nDeletion aborted")
		end
	else
		notFound()
	end
end

function findFile()
	strikes::Int = 3
	tries::Int = 0
	found = false

	while tries < strikes && !found
		println("\nPlease enter the name of the Employee data file")
		println("Do not add a file extension (e.g. .txt)")
		fileName::String = readline()
		try
			open(REPLPATH * fileName * ".txt", "r")
			found = true
			loadFile(fileName)
		catch err
			println("The file " * fileName * " does not exist")
			tries += 1
			if strikes - tries > 1
				println("You have ", strikes - tries, " attempts left")
			elseif strikes - tries == 1
				println("You have ", strikes - tries, " attempt left")
			else
				println("Maximum attempts reached")
			end
			if isa(err, LoadError)
			end
		end
	end
	return found
end

function loadFile(fileName::String)
	rowCount::Int = countlines(REPLPATH * fileName * ".txt")
	global roster = readdlm(REPLPATH * fileName * ".txt")
	row::Int = 1

	while row < rowCount
		name::String = roster[row, 1]
		id::String = roster[row, 2]
		department::String = roster[row, 3]
		group::String = roster[row, 4]

		if group == "S"
			pushSalaryEmployee(row, name, id, department, group)
		elseif group == "H"
			pushHourlyEmployee(row, name, id, department, group)
		else
			pushCommissionEmployee(row, name, id, department, group)
		end
		row += 1
	end
end

function pushHourlyEmployee(row, name, id, dept, group)
	payRate = roster[row, 5]
	hoursWorked = roster[row, 6]
	hour = Hourly(Employee(name, id, dept, group), payRate, hoursWorked)
	push!(staff, hour)
end

function pushSalaryEmployee(row, name, id, dept, group)
	annualPay = roster[row, 5]
	sal = Salary(Employee(name, id, dept, group), annualPay)
	push!(staff, sal)
end

function pushCommissionEmployee(row, name, id, dept, group)
	numWeeks = roster[row, 5]
	baseSalary = roster[row, 6]
	weeklySales = roster[row, 7]
	yearlySales = roster[row, 8]
	comRate = roster[row, 9]
	com = Commission(Employee(name, id, dept, group), numWeeks, baseSalary, weeklySales, yearlySales, comRate)
	push!(staff, com)
end

function topSellers()
	quota = 1500.00
	found = false
	println("\nTop Sellers List:")

	for emp in staff
		if emp.employee.group == "C"
			total = calcComTopSeller(emp)
			if total >= quota
				found = true
				println("\t" * emp.employee.name * "\t", @sprintf("\$ %0.2f", total))
			end
		end
	end

	if !found
		println("No Employees have qualified")
	end
end

#=
function referenceCodeStash(number, row, emp, ArrayName)
	h = Hourly(Employee("me", number, "deoo"), 34.56, 12.55)
	s = Salary(Employee("you", number, "deoo"), 55345.73)
	println(h.hoursWorked)
	println(h.employee.name)
	println(s.annualPay)
	println(s.employee.name)

	e = Employee("bob", number, "dept")
	push!(staff, e)
	popfirst!(staff)
	Base.print_matrix(stdout, staff)
	findfirst(isequal("Hades"), staff)
	foreach(println, staff)

	println(e)
	println(emp)
	println("break")
	println(staff)
	println("break")
	println(staff)

	println(getindex(staff, 1))
	println(findall(iseven, ArrayName))

	testTuple = (name = roster[row,1], id = roster[row,2], dept = roster[row,3]. type = roster[row,4])

	f = Employee("John", "111-111-111", "Sales")
	push!(staff, f)
end
=#