class Payments {
  String? paymentId;
  String? paymentAmount;
  String? paymentDate;
  String? paymentStatus;
  String? paymentReceipt;
  String? membershipId;
  String? membershipName;

  Payments(
      {this.paymentId,
      this.paymentAmount,
      this.paymentDate,
      this.paymentStatus,
      this.paymentReceipt,
      this.membershipId,
      this.membershipName});

  Payments.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id']?.toString();
    paymentAmount = json['payment_amount']?.toString();
    paymentDate = json['payment_date'];
    paymentStatus = json['payment_status'];
    paymentReceipt = json['payment_receipt']?.toString();
    membershipId = json['membership_id']?.toString();
    membershipName = json['membership_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['payment_amount'] = paymentAmount;
    data['payment_date'] = paymentDate;
    data['payment_status'] = paymentStatus;
    data['payment_receipt'] = paymentReceipt; 
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    return data;
  }
}
