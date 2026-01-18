import 'package:hikaronsfa/source/network/Customer/apiCustomer.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryCustomer {
  Future getCustomerAlls(salesId, context) async {
    var json = await network(url: ApiCustomer.getCustomerAll(salesId), method: "GET", body: null, context: context);
    return json;
  }

  Future getCustomerVisitation(salesId, context) async {
    var json = await network(url: ApiCustomer.getCustomerVisitation(salesId), method: "GET", body: null, context: context);
    return json;
  }
}
