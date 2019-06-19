class Employee{
   final String employeeId;
   final String employeeName;
   final String userName;
   final String password;
   final String emailId;
   final String phoneNumber;
   final String designantionName;
   final String merchantId;
   final String merchantName;
   Employee(
       this.employeeId,this.employeeName,this.userName,this.password,this.emailId,this.phoneNumber,this.designantionName,this.merchantId,this.merchantName
       );
   factory Employee.fromJson(Map<String, dynamic> json){
     return new Employee(
       json["employeeId"].toString(),
        json["employeeName"],
         json["userName"],
          json["password"],
         json["emailId"],
           json["phoneNumber"],
        json["designantionName"],
       json["merchantId"],
       json["merchantName"],
     );
   }


}

