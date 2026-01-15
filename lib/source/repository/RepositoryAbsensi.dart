import 'package:hikaronsfa/source/network/Absensi/apiAbsensi.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryAbsensi {
  Future checkIN(body, context) async {
    var json = await network(url: ApiAbseni.checkIN(), method: "POST", body: body, context: context);
    return json;
  }

  Future checkOUT(body, context) async {
    var json = await network(url: ApiAbseni.checkOUT(), method: "POST", body: body, context: context);
    return json;
  }

  Future lastCheckIn(salesid, attType, context) async {
    var json = await network(url: ApiAbseni.lastCheckIn(salesid, attType), method: "GET", body: null, context: context);
    return json;
  }
}
