import 'package:hikaronsfa/source/network/Order/apiOrder.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryOrder {
  Future getOrder(salesId, startdate, enddate, context) async {
    var json = await network(method: "GET", url: ApiOrder.getOrder(salesId, startdate, enddate), body: null, context: context);
    return json;
  }

  Future getOrderDetail(oid, salesId, context) async {
    var json = await network(method: "GET", url: ApiOrder.getOrderDetail(oid, salesId), body: null, context: context);
    return json;
  }

  Future getDsign(context) async {
    var json = await network(method: "GET", url: ApiOrder.getDesign(), body: null, context: context);
    return json;
  }

  Future getColorbyDesign(designId, context) async {
    var json = await network(method: "GET", url: ApiOrder.getColorbyDesign(designId), body: null, context: context);
    return json;
  }
}
