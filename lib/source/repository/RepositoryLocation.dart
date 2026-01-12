import 'package:hikaronsfa/source/network/Location/apiLocation.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryLocation {
  Future addLocation(body, context)async {
    var json = await network(url: ApiLocation.addLocation(), method: "POST", body: body, context: context);
    return json;
  }
}