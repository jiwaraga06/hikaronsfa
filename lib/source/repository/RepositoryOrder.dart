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

  Future getCustomerOrder(salesid, context) async {
    var json = await network(method: "GET", url: ApiOrder.getCustomerOrder(salesid), body: null, context: context);
    return json;
  }

  Future meterPerRoll(ptcId, context) async {
    var json = await network(method: "GET", url: ApiOrder.meterPerRoll(ptcId), body: null, context: context);
    return json;
  }

  Future insertOrder(body, context) async {
    var json = await network(method: "POST", url: ApiOrder.insertOrder(), body: body, context: context);
    return json;
  }

  Future updateOrder(body, context) async {
    var json = await network(method: "POST", url: ApiOrder.updateOrder(), body: body, context: context);
    return json;
  }

  Future deleteOrder(body, context) async {
    var json = await network(method: "POST", url: ApiOrder.deleteOrder(), body: body, context: context);
    return json;
  }

  Future approveOrder(body, context) async {
    var json = await network(method: "POST", url: ApiOrder.approveOrder(), body: body, context: context);
    return json;
  }
}
