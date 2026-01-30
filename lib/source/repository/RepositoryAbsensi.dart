import 'package:hikaronsfa/source/network/Absensi/apiAbsensi.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryAbsensi {
  Future radius(context) async {
    var json = await network(url: ApiAbseni.radius(), method: "GET", body: null, context: context);
    return json;
  }

  Future checkIN(body, context) async {
    var json = await network(url: ApiAbseni.checkIN(), method: "POST", body: body, context: context);
    return json;
  }

  Future checkOUT(body, context) async {
    var json = await network(url: ApiAbseni.checkOUT(), method: "POST", body: body, context: context);
    return json;
  }

  Future lastCheckIn(salesid, context) async {
    var json = await network(url: ApiAbseni.lastCheckIn(salesid), method: "GET", body: null, context: context);
    return json;
  }
}
