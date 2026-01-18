import 'dart:convert';

ModelVisitationDetail modelVisitationDetailFromJson(String str) => ModelVisitationDetail.fromJson(json.decode(str));

class ModelVisitationDetail {
  final Order? order;
  final List<OrderPicDetail> orderPicDetail;
  final List<OrderKeteranganDetail> orderKeteranganDetails;
  final List<OrderLampiranDetail> orderLampiranDetails;
  ModelVisitationDetail({required this.order, required this.orderPicDetail, required this.orderKeteranganDetails, required this.orderLampiranDetails});

  factory ModelVisitationDetail.fromJson(Map<String, dynamic> json) {
    return ModelVisitationDetail(
      order: json["order"] == null ? null : Order.fromJson(json["order"]),
      orderPicDetail: json["orderPICDetail"] == null ? [] : List<OrderPicDetail>.from(json["orderPICDetail"]!.map((x) => OrderPicDetail.fromJson(x))),
      orderKeteranganDetails:
          json["orderKeteranganDetails"] == null
              ? []
              : List<OrderKeteranganDetail>.from(json["orderKeteranganDetails"]!.map((x) => OrderKeteranganDetail.fromJson(x))),
      orderLampiranDetails:
          json["orderLampiranDetails"] == null ? [] : List<OrderLampiranDetail>.from(json["orderLampiranDetails"]!.map((x) => OrderLampiranDetail.fromJson(x))),
    );
  }
}

class Order {
  Order({
    required this.visitationOid,
    required this.visitationCode,
    required this.visitationDate,
    required this.visitationStatus,
    required this.visitationRemarks,
    required this.customerName,
    required this.customerId,
    required this.attndOid,
  });

  final String? visitationOid;
  final String? visitationCode;
  final DateTime? visitationDate;
  final String? visitationStatus;
  final dynamic visitationRemarks;
  final String? customerName;
  final String? attndOid;
  final int? customerId;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      attndOid: json["attnd_oid"],
      visitationOid: json["visitation_oid"],
      visitationCode: json["visitation_code"],
      visitationDate: DateTime.tryParse(json["visitation_date"] ?? ""),
      visitationStatus: json["visitation_status"],
      visitationRemarks: json["visitation_remarks"],
      customerName: json["customer_name"],
      customerId: json["customer_id"],
    );
  }
}

class OrderKeteranganDetail {
  OrderKeteranganDetail({required this.visitationdOid, required this.visitationdRemarks});

  final String? visitationdOid;
  final String? visitationdRemarks;

  factory OrderKeteranganDetail.fromJson(Map<String, dynamic> json) {
    return OrderKeteranganDetail(visitationdOid: json["visitationd_oid"], visitationdRemarks: json["visitationd_remarks"]);
  }
}

class OrderLampiranDetail {
  OrderLampiranDetail({required this.visitationdOid, required this.visitationdRemarks, required this.visitationdImage});

  final String? visitationdOid;
  final String? visitationdRemarks;
  final String? visitationdImage;

  factory OrderLampiranDetail.fromJson(Map<String, dynamic> json) {
    return OrderLampiranDetail(
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
      visitationdImage: json["visitationd_image"],
    );
  }
}

class OrderPicDetail {
  OrderPicDetail({required this.visitationdOid, required this.visitationdRemarks, required this.visitationdJabatan});

  final String? visitationdOid;
  final String? visitationdRemarks;
  final String? visitationdJabatan;

  factory OrderPicDetail.fromJson(Map<String, dynamic> json) {
    return OrderPicDetail(
      visitationdOid: json["visitationd_oid"],
      visitationdRemarks: json["visitationd_remarks"],
      visitationdJabatan: json["visitationd_jabatan"],
    );
  }
}
