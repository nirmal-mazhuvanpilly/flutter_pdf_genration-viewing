class ReportsModel {
  ReportsModel({
    this.status,
    this.data,
    this.apiId,
    this.message,
  });

  bool status;
  List<Datum> data;
  int apiId;
  String message;

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        apiId: json["api_id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "api_id": apiId,
        "message": message,
      };
}

class Datum {
  Datum({
    this.egpCardNo,
    this.mobile,
    this.paymentMode,
    this.totalPaid,
  });

  String egpCardNo;
  String mobile;
  String paymentMode;
  int totalPaid;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        egpCardNo: json["EgpCardNo"],
        mobile: json["Mobile"],
        paymentMode: json["PaymentMode"],
        totalPaid: json["TotalPaid"],
      );

  Map<String, dynamic> toJson() => {
        "EgpCardNo": egpCardNo,
        "Mobile": mobile,
        "PaymentMode": paymentMode,
        "TotalPaid": totalPaid,
      };
}
