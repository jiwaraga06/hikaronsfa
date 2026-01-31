import 'package:hikaronsfa/source/network/Outstanding/apiOutstanding.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryOutstanding {
  Future getOutstandingShipment(salesid, customerid, context) async {
    var json = await network(url: ApiOutstanding.getOutstandingShipment(salesid, customerid), method: "GET", body: null, context: context);
    return json;
  }
}
