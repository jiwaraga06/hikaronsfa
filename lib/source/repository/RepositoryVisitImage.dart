import 'package:hikaronsfa/source/network/VisitImage/apiVisitImage.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryVisitImage {
  Future getVisitImage(oid, context) async {
    var json = await network(url: ApiVisitImage.getImage(oid), method: "GET", body: null, context: context);
    return json;
  }

  Future addVisitImage(body, context) async {
    var json = await network(url: ApiVisitImage.addImage(), method: "POST", body: body, context: context);
    return json;
  }

  Future editVisitImage(body, context) async {
    var json = await network(url: ApiVisitImage.editImage(), method: "POST", body: body, context: context);
    return json;
  }
}
