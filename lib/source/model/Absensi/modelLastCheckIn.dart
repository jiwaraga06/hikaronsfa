import 'dart:convert';

// List<ModelLastCheckIn> modelLastCheckInfromJson(String str) => List<ModelLastCheckIn>.from(jsonDecode(str).map((x) => ModelLastCheckIn.fromJson(x)));
ModelLastCheckIn modelLastCheckInFromJson(String str) => ModelLastCheckIn.fromJson(jsonDecode(str));

class ModelLastCheckIn {
  ModelLastCheckIn({
    required this.attndOid,
    required this.attndType,
    required this.attndSalesId,
    required this.attndCustId,
    required this.attndCustName,
    required this.attndDateIn,
    required this.attndTimeIn,
    required this.attndLatitudeIn,
    required this.attndLongitudeIn,
    required this.attndImageIn,
    required this.attndLocDescIn,
    required this.attndDateOut,
    required this.attndTimeOut,
    required this.attndLatitudeOut,
    required this.attndLongitudeOut,
    required this.attndImageOut,
    required this.attndLocDescOut,
    required this.attndCurrentStatus,
    required this.attndCurrentType,
    required this.attndVisitationOid,
  });

  final String? attndOid;
  final String? attndType;
  final int? attndSalesId;
  final int? attndCustId;
  final String? attndCustName;
  final String? attndDateIn;
  final String? attndTimeIn;
  final String? attndLatitudeIn;
  final String? attndLongitudeIn;
  final String? attndImageIn;
  final String? attndLocDescIn;
  final String? attndDateOut;
  final String? attndTimeOut;
  final String? attndLatitudeOut;
  final String? attndLongitudeOut;
  final String? attndImageOut;
  final String? attndLocDescOut;
  final String? attndCurrentStatus;
  final String? attndCurrentType;
  final String? attndVisitationOid;

  factory ModelLastCheckIn.fromJson(Map<String, dynamic> json) {
    return ModelLastCheckIn(
      attndOid: json["attnd_oid"],
      attndType: json["attnd_type"],
      attndSalesId: json["attnd_sales_id"],
      attndCustId: json["attnd_cust_id"],
      attndCustName: json["attnd_cust_name"],
      attndDateIn: json["attnd_date_in"],
      attndTimeIn: json["attnd_time_in"],
      attndLatitudeIn: json["attnd_latitude_in"],
      attndLongitudeIn: json["attnd_longitude_in"],
      attndImageIn: json["attnd_image_in"],
      attndLocDescIn: json["attnd_loc_desc_in"],
      attndDateOut: json["attnd_date_out"],
      attndTimeOut: json["attnd_time_out"],
      attndLatitudeOut: json["attnd_latitude_out"],
      attndLongitudeOut: json["attnd_longitude_out"],
      attndImageOut: json["attnd_image_out"],
      attndLocDescOut: json["attnd_loc_desc_out"],
      attndCurrentStatus: json["attnd_current_status"],
      attndCurrentType: json["attnd_current_type"],
      attndVisitationOid: json["attnd_visitation_oid"],
    );
  }
}
