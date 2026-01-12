import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Customer/modelCustomer.dart';
import 'package:hikaronsfa/source/repository/repositoryCustomer.dart';
import 'package:meta/meta.dart';

part 'get_customer_state.dart';

class GetCustomerCubit extends Cubit<GetCustomerState> {
  final RepositoryCustomer? repository;
  GetCustomerCubit({this.repository}) : super(GetCustomerInitial());

  void getCustomerAll(context) async {
    emit(GetCustomerLoading());
    repository!.getCustomerAll(context).then((value) {
      var json = value.data;
      var statusCode = value.statusCode;
      print("\n $json \n");
      if (statusCode == 200) {
        emit(GetCustomerLoaded(statusCode: statusCode, model: modelCustomerfromJson(jsonEncode(json['data']))));
      } else {
        emit(GetCustomerFailed(statusCode: statusCode, json: json));
      }
    });
  }
}
