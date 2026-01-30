import 'package:hikaronsfa/source/network/Banner/apiBanner.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryBanner {
  Future getBanner(context) async {
    var json = await network(url: ApiBanner.getbanner(), method: "GET", body: null, context: context);
    return json;
  }
}
