import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/Order/modelEntryOrderDetail.dart';
import 'package:meta/meta.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(OrderDetailInitial());

  void loadData() {
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }

  void clearData() {
    modelEntryOrderDetail.clear();
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }

  void addAllData({
    int? orderdDesignId,
    String? orderdDesignName,
    int? orderdPtId,
    String? orderdPtName,
    String? orderdQtyRoll,
    String? orderdQtyMtr,
    String? orderdPrice,
  }) {
    modelEntryOrderDetail.add(
      ModelEntryOrderDetail(
        generateID: modelEntryOrderDetail.length + 1,
        orderdDesignName: orderdDesignName,
        orderdDesignId: orderdDesignId,
        orderdPtId: orderdPtId,
        orderdPtName: orderdPtName,
        orderdQtyRoll: orderdQtyRoll,
        orderdQtyMtr: orderdQtyMtr,
        orderdPrice: orderdPrice,
      ),
    );
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }

  void addData({
    int? orderdDesignId,
    String? orderdDesignName,
    int? orderdPtId,
    String? orderdPtName,
    String? orderdQtyRoll,
    String? orderdQtyMtr,
    String? orderdPrice,
  }) {
    modelEntryOrderDetail.add(
      ModelEntryOrderDetail(
        generateID: modelEntryOrderDetail.length + 1,
        orderdDesignName: orderdDesignName,
        orderdDesignId: orderdDesignId,
        orderdPtId: orderdPtId,
        orderdPtName: orderdPtName,
        orderdQtyRoll: orderdQtyRoll,
        orderdQtyMtr: orderdQtyMtr,
        orderdPrice: orderdPrice,
      ),
    );
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }

  void editData({
    int? id,
    int? orderdDesignId,
    String? orderdDesignName,
    int? orderdPtId,
    String? orderdPtName,
    String? orderdQtyRoll,
    String? orderdQtyMtr,
    String? orderdPrice,
  }) {
    final find = modelEntryOrderDetail.indexWhere((e) => e.generateID == id);
    if (find != 1) {
      modelEntryOrderDetail[find] = modelEntryOrderDetail[find].copyWith(
        orderdDesignName: orderdDesignName,
        orderdDesignId: orderdDesignId,
        orderdPtId: orderdPtId,
        orderdPtName: orderdPtName,
        orderdQtyRoll: orderdQtyRoll,
        orderdQtyMtr: orderdQtyMtr,
        orderdPrice: orderdPrice,
      );
    }
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }

  void deleteData(int id) {
    modelEntryOrderDetail.removeWhere((e) => e.generateID == id);
    emit(OrderDetailLoaded(model: List.from(modelEntryOrderDetail)));
  }
}
