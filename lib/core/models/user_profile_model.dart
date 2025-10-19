import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));
String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  final List<UserProfileData> items;
  final int count;
  final bool hasMore;
  // ... (باقي حقول الـ JSON الخارجية إذا وجدت)

  UserProfile({
    required this.items,
    required this.count,
    required this.hasMore,
    // ...
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    items: List<UserProfileData>.from(json["items"].map((x) => UserProfileData.fromJson(x))),
    count: json["count"],
    hasMore: json["hasMore"],
    // ...
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "count": count,
    "hasMore": hasMore,
    // ...
  };
}


class UserProfileData {
  final int compEmpCode;
  final String? empName;
  final String? empNameE;
  final String? dNameE; // Department Name English
  final String? DNameE;
  final String? jobDesc;
  final String? jobDescE;
  final double? salary;
  final double? transport;
  final double? nature; // طبيعة عمل
  final double? food;
  final double? extra;
  final double? others;
  final double? dcsnOthr; // خصميات اخرى
  final double? allowance1;
  final double? allowance2;
  final double? allowance3;
  final int? houseMnths; // شهور بدل السكن
  final double? houseAmount;
  final int? normalDays; // ايام الدوام العادية
  final int? suddenSlryDays; // ايام الراتب المفاجئ (؟)
  final int? absenceNotAllowExtraDays; // ايام الغياب غير المسموح بها
  final int? vacationEvery; // اجازة كل (بالأشهر أو السنوات)
  final double? ticketsAmount;
  final int? ticketsEvery; // تذاكر كل (بالأشهر أو السنوات)
  final String? ticketsType; // نوع التذاكر
  final String? cityNameA; // مدينة السفر عربي
  final String? cityNameE; // مدينة السفر عربي
  final String? airlineNameA; // اسم شركة الطيران عربي
  final String? airlineNameE; // اسم شركة الطيران عربي
  // final List<Link> links; // إذا كان هناك links في هذا المستوى

  UserProfileData({
    required this.compEmpCode,
    this.empName,
    this.empNameE,
    this.dNameE,
    this.jobDesc,
    this.jobDescE,
    this.salary,
    this.transport,
    this.nature,
    this.food,
    this.extra,
    this.others,
    this.dcsnOthr,
    this.allowance1,
    this.allowance2,
    this.allowance3,
    this.houseMnths,
    this.houseAmount,
    this.normalDays,
    this.suddenSlryDays,
    this.absenceNotAllowExtraDays,
    this.vacationEvery,
    this.ticketsAmount,
    this.ticketsEvery,
    this.ticketsType,
    this.cityNameA,
    this.cityNameE,
    this.airlineNameA,
    this.airlineNameE,
    this.DNameE
    // required this.links,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
    compEmpCode: json["CompEmpCode"],
    empName: json["EmpName"],
      empNameE: json["EmpNameE"],
    dNameE: json["DName"],
    jobDesc: json["JobDesc"],
      jobDescE: json["JobDescE"],
    salary: (json["Salary"] as num?)?.toDouble(),
    transport: (json["Transport"] as num?)?.toDouble(),
    nature: (json["Nature"] as num?)?.toDouble(),
    food: (json["Food"] as num?)?.toDouble(),
    extra: (json["Extra"] as num?)?.toDouble(),
    others: (json["Others"] as num?)?.toDouble(),
    dcsnOthr: (json["DcsnOthr"] as num?)?.toDouble(),
    allowance1: (json["Allowance1"] as num?)?.toDouble(),
    allowance2: (json["Allowance2"] as num?)?.toDouble(),
    allowance3: (json["Allowance3"] as num?)?.toDouble(),
    houseMnths: json["HouseMnths"],
    houseAmount: (json["HouseAmount"] as num?)?.toDouble(),
    normalDays: json["NormalDays"],
    suddenSlryDays: json["SuddenSlryDays"],
    absenceNotAllowExtraDays: json["AbsenceNotAllowExtraDays"],
    vacationEvery: json["VacationEvery"],
    ticketsAmount: (json["TicketsAmount"] as num?)?.toDouble(),
    ticketsEvery: json["TicketsEvery"],
    ticketsType: json["TicketsType"],
    cityNameA: json["CityNameA"],
    cityNameE: json["CityNameE"],
    airlineNameA: json["AirlineNameA"],
    airlineNameE: json["AirlineNameE"],
    DNameE: json['DNameE']
    // links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "CompEmpCode": compEmpCode,
    "EmpName": empName,
    "EmpNameE": empNameE,
    "DNameE": dNameE,
    "JobDesc": jobDesc,
    "JobDescE": jobDescE,
    "Salary": salary,
    "Transport": transport,
    "Nature": nature,
    "Food": food,
    "Extra": extra,
    "Others": others,
    "DcsnOthr": dcsnOthr,
    "Allowance1": allowance1,
    "Allowance2": allowance2,
    "Allowance3": allowance3,
    "HouseMnths": houseMnths,
    "HouseAmount": houseAmount,
    "NormalDays": normalDays,
    "SuddenSlryDays": suddenSlryDays,
    "AbsenceNotAllowExtraDays": absenceNotAllowExtraDays,
    "VacationEvery": vacationEvery,
    "TicketsAmount": ticketsAmount,
    "TicketsEvery": ticketsEvery,
    "TicketsType": ticketsType,
    "CityNameA": cityNameA,
    "CityNameE": cityNameE,
    "AirlineNameA": airlineNameA,
    "AirlineNameE": airlineNameE,
    "DNamee": DNameE
    // "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}
// يمكنك إعادة استخدام Link model إذا كان الـ API يرجعه هنا