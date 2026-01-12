import 'package:hikaronsfa/source/network/Customer/apiCustomer.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryCustomer {
  Future getCustomerAll(context) async {
    var json = await network(url: ApiCustomer.getCustomerAll(), method: "GET", body: null, context: context);
    return json;
  }
}
