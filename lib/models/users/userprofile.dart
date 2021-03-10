class Userprofile {
  int employeeId;
  String employeeName;
  String pwd;
  String firstName;
  String lastName;
  String address;
  String createUser;
  int createDate;
  int updateDate;
  String mobile;
  String language;
  String tel;
  String gender;
  String email;
  int dateofJoin;
  String vehicle;
  String vehicleNo;
  String licenseNumber;
  String currentFleet;
  String icNumber;

  Userprofile({  
    this.employeeId,
    this.employeeName,
    this.pwd,
    this.firstName,
    this.lastName,
    this.address,
    this.createUser,
    int createDate,
    int updateDate,
    this.mobile,
    this.language,
    this.tel,
    this.gender,
    this.email,
    int dateofJoin,
    this.vehicle,
    this.vehicleNo,
    this.icNumber,
    }
  );

  factory Userprofile.fromJson(Map<String, dynamic> json) {
    return Userprofile
    (
      employeeId: json['employeeId'] as int,
      employeeName: json['employeeName'] as String,
      pwd: json['pwd'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      address: json['address'] as String,
      mobile: json['mobile'] as String,
      language: json['language'] as String,
      email: json['email'] as String,
      tel: json['tel'] as String,
      gender: json['gender'] as String,
      vehicle: json['vehicle'] as String,
      vehicleNo: json['vehicleNo'] as String,
    );
  }
}
