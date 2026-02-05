class ModelEntryOrderDetail {
  final int? generateID;
  final int? orderdDesignId;
  final String? orderdDesignName;
  final int? orderdPtId;
  final String? orderdPtName;
  final String? orderdQtyRoll;
  final String? orderdQtyMtr;
  final String? orderdPrice;
  ModelEntryOrderDetail({
    this.generateID,
    required this.orderdDesignId,
    required this.orderdDesignName,
    required this.orderdPtId,
    required this.orderdPtName,
    required this.orderdQtyRoll,
    required this.orderdQtyMtr,
    required this.orderdPrice,
  });

  ModelEntryOrderDetail copyWith({
    int? generateID,
    int? orderdDesignId,
    String? orderdDesignName,
    int? orderdPtId,
    String? orderdPtName,
    String? orderdQtyRoll,
    String? orderdQtyMtr,
    String? orderdPrice,
  }) {
    return ModelEntryOrderDetail(
      generateID: generateID ?? this.generateID,
      orderdDesignId: orderdDesignId ?? this.orderdDesignId,
      orderdDesignName: orderdDesignName ?? this.orderdDesignName,
      orderdPtId: orderdPtId ?? this.orderdPtId,
      orderdPtName: orderdPtName ?? this.orderdPtName,
      orderdQtyRoll: orderdQtyRoll ?? this.orderdQtyRoll,
      orderdQtyMtr: orderdQtyMtr ?? this.orderdQtyMtr,
      orderdPrice: orderdPrice ?? this.orderdPrice,
    );
  }

  // factory ModelEntryOrderDetail.fromJson(Map<String, dynamic> json) {
  //   return ModelEntryOrderDetail(
  //     orderdDesignId: json["orderd_design_id"],
  //     orderdPtId: json["orderd_pt_id"],
  //     orderdQtyRoll: json["orderd_qty_roll"],
  //     orderdQtyMtr: json["orderd_qty_mtr"],
  //     orderdPrice: json["orderd_price"],
  //   );
  // }

  Map<String, dynamic> toJson() => {
    "orderd_design_id": orderdDesignId,
    "orderd_pt_id": orderdPtId,
    "orderd_qty_roll": orderdQtyRoll,
    "orderd_qty_mtr": orderdQtyMtr,
    "orderd_price": orderdPrice,
  };

  @override
  String toString() {
    return "orderdDesignId: $orderdDesignId,orderdPtId: $orderdPtId, orderdQtyRoll: $orderdQtyRoll, orderdQtyMtr: $orderdQtyMtr,orderdPrice: $orderdPrice ";
  }
}
