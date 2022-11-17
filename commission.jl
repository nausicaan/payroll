#=
commission:
- Julia version: 1.5.2
- Author: Byron Stuike
- Date: 2020-08-03
=#

function calcTopSeller(emp)
	earned::Float32 = emp.yearlySales / emp.numWeeks
	return earned
end

function weeklyCommissionSalary(emp)
	wage::Float32 = emp.baseSalary + (emp.weeklySales * (emp.comRate / 100))
	return wage
end

#=
function printCom()
    super.print();
    println("\t\tCommission \t\$ " * String.format("%.2f", calcComWeeklySalary()))
end

function statementCom()
    text::String = super.toString() * "\n\tWeeks Worked This Year: " * getNumWeeks() * "\n\tBase Salary: " * String.format("$ %.2f", getBaseSalary()) * "\n\tWeekly Sales: " * String.format("$ %.2f", getWeeklySales()) * "\n\tYearly Sales: " * String.format("$ %.2f", getYearlySales()) * "\n\tCommission Rate: " * String.format("%.2f", getComRate()) * "%"
    return text
end

function writeComData()
    empType::Char = 'C'
    data::String = super.writeData() * empType * " " * getNumWeeks() * " " * String.format("%.2f", getBaseSalary()) * " " * String.format("%.2f", getWeeklySales()) * " " * String.format("%.2f", getYearlySales()) * " " * String.format("%.2f", getComRate())
    return data
end
=#