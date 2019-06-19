import 'Employee.dart';

class EmployeeList {
  final List<Employee> employeelist;

  EmployeeList({
    this.employeelist,
  });

  factory EmployeeList.fromJson(List<dynamic> parsedJson) {

    List<Employee> employees = parsedJson.map((i)=>Employee.fromJson(i)).toList();

    return new EmployeeList(employeelist: employees);
  }
}

