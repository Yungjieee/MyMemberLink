class Memberships {
  String? membershipId;
  String? membershipName;
  String? membershipDescription;
  String? membershipPrice;
  List<String>? membershipBenefits;
  List<String>? membershipTerms;
  String? membershipDuration;

  Memberships(
      {this.membershipId,
      this.membershipName,
      this.membershipDescription,
      this.membershipPrice,
      this.membershipBenefits,
      this.membershipTerms,
      this.membershipDuration});

  Memberships.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    membershipDescription = json['membership_description'];
    membershipPrice = json['membership_price'];
    membershipBenefits = List<String>.from(json['membership_benefits']);
    membershipTerms = List<String>.from(json['membership_terms']);
    membershipDuration = json['membership_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['membership_name'] = membershipName;
    data['membership_description'] = membershipDescription;
    data['membership_price'] = membershipPrice;
    data['membership_benefits'] = membershipBenefits;
    data['membership_terms'] = membershipTerms;
    data['membership_duration'] = membershipDuration;
    return data;
  }
}
