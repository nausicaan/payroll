#=
employee:
- Julia version: 1.5.2
- Author: Byron Stuike
- Date: 2020-08-03
=#

include("commission.jl")
include("salary.jl")
include("hourly.jl")

abstract type AbstractEmployee end

mutable struct Employee <: AbstractEmployee
	name::String
	id::String
	department::String
	group::String
end

mutable struct Hourly
	employee::Employee
	payRate::Float64
	hoursWorked::Float64
end

mutable struct Salary
	employee::Employee
	annualPay::Float64
end

mutable struct Commission
	employee::Employee
	numWeeks::Int
	baseSalary::Float64
	weeklySales::Float64
	yearlySales::Float64
	comRate::Float64
end

abstract type AbstractWage end

# mutable struct Wage <: AbstractWage
#    wage::Float64
# end

function calcWeeklyPay(hoursWorked::Float64, payRate::Float64)
	wage = 0.0
	RegHours::Float64 = 40.0
	otRate::Float64 = 1.5
	ot::Float64 = 0.0

	if hoursWorked > RegHours
		ot = (hoursWorked - RegHours) * (payRate * otRate)
		wage = ot + (payRate * RegHours)
	else hoursWorked <= RegHours
		wage = payRate * hoursWorked
	end
	return wage
end

abstract type AbstractSeller end

mutable struct Earned <: AbstractSeller
   earned::Float64
end

function calcComTopSeller(emp)
	earned = calcTopSeller(emp)
	return earned
end