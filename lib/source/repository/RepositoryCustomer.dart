import 'package:hikaronsfa/source/network/Customer/apiCustomer.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryCustomer {
  Future getLocationCustomer(salesId, context) async {
    var json = await network(url: ApiCustomer.getLocationCustomer(salesId), method: "GET", body: null, context: context);
    return json;
  }

  Future getAllCustomer(salesId, context) async {
    var json = await network(url: ApiCustomer.getAllCustomer(salesId), method: "GET", body: null, context: context);
    return json;
  }

  Future getCustomerVisitation(salesId, context) async {
    var json = await network(url: ApiCustomer.getCustomerVisitation(salesId), method: "GET", body: null, context: context);
    return json;
  }
  Future getCustomerOutstanding(salesId, context) async {
    var json = await network(url: ApiCustomer.getCustomerOutstanding(salesId), method: "GET", body: null, context: context);
    return json;
  }
}
