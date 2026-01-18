import 'dart:convert';


ModelOrderDetail modelOrderDetailFromJson(String str) => ModelOrderDetail.fromJson(json.decode(str));

class ModelOrderDetail {
  ModelOrderDetail({
    required this.orderOid,
    required this.orderCode,
    required this.orderStatus,
    required this.orderDate,
    required this.ptnrName,
    required this.orderRemarks,
    required this.orderPo,
    required this.detail,
  });

  final String? orderOid;
  final String? orderCode;
  final String? orderStatus;
  final DateTime? orderDate;
  final String? ptnrName;
  final String? orderRemarks;
  final String? orderPo;
  final List<Detail> detail;

  factory ModelOrderDetail.fromJson(Map<String, dynamic> json) {
    return ModelOrderDetail(
      orderOid: json["order_oid"],
      orderCode: json["order_code"],
      orderStatus: json["order_status"],
      orderDate: DateTime.tryParse(json["order_date"] ?? ""),
      ptnrName: json["ptnr_name"],
      orderRemarks: json["order_remarks"],
      orderPo: json["order_po"],
      detail: json["detail"] == null ? [] : List<Detail>.from(json["detail"]!.map((x) => Detail.fromJson(x))),
    );
  }
}

class Detail {
  Detail({
    required this.designId,
    required this.designName,
    required this.orderdQtyRoll,
    required this.orderdQtyMtr,
    required this.orderdPrice,
    required this.orderdDesignId,
    required this.orderdPtId,
    required this.colorCode,
  });

  final int? designId;
  final String? designName;
  final String? orderdQtyRoll;
  final String? orderdQtyMtr;
  final String? orderdPrice;
  final int? orderdDesignId;
  final int? orderdPtId;
  final String? colorCode;

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      designId: json["design_id"],
      designName: json["design_name"],
      orderdQtyRoll: json["orderd_qty_roll"],
      orderdQtyMtr: json["orderd_qty_mtr"],
      orderdPrice: json["orderd_price"],
      orderdDesignId: json["orderd_design_id"],
      orderdPtId: json["orderd_pt_id"],
      colorCode: json["color_code"],
    );
  }
}
