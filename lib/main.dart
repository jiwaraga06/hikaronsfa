import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:hikaronsfa/source/repository/RepositoryLocation.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:hikaronsfa/source/repository/repositoryCustomer.dart';
import 'package:hikaronsfa/source/router/router.dart';
import 'package:hikaronsfa/source/service/Absensi/cubit/absensi_check_in_cubit.dart';
import 'package:hikaronsfa/source/service/Absensi/cubit/absensi_check_out_cubit.dart';
import 'package:hikaronsfa/source/service/Absensi/cubit/get_last_check_in_cubit.dart';
import 'package:hikaronsfa/source/service/Auth/cubit/auth_cubit.dart';
import 'package:hikaronsfa/source/service/Auth/cubit/profile_cubit.dart';
import 'package:hikaronsfa/source/service/Color/cubit/get_color_cubit.dart';
import 'package:hikaronsfa/source/service/Customer/cubit/get_customer_cubit.dart';
import 'package:hikaronsfa/source/service/Customer/cubit/get_customer_visitation_cubit.dart';
import 'package:hikaronsfa/source/service/Design/cubit/get_design_cubit.dart';
import 'package:hikaronsfa/source/service/Location/cubit/add_location_cubit.dart';
import 'package:hikaronsfa/source/service/Location/cubit/distance_location_cubit.dart';
import 'package:hikaronsfa/source/service/Location/cubit/get_location_customer_cubit.dart';
import 'package:hikaronsfa/source/service/MarkerLocation/cubit/marker_location_cubit.dart';
import 'package:hikaronsfa/source/service/Order/cubit/get_order_cubit.dart';
import 'package:hikaronsfa/source/service/Order/cubit/get_order_detail_cubit.dart';
import 'package:hikaronsfa/source/service/Visitation/Delete/cubit/delete_visitation_cubit.dart';
import 'package:hikaronsfa/source/service/Visitation/Insert/cubit/insert_visitation_cubit.dart';
import 'package:hikaronsfa/source/service/Visitation/Update/cubit/update_visitation_cubit.dart';
import 'package:hikaronsfa/source/service/Visitation/cubit/get_visitation_cubit.dart';
import 'package:hikaronsfa/source/service/Visitation/cubit/get_visitation_detail_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp(router: RouterNavigation()));
}

class MyApp extends StatefulWidget {
  RouterNavigation? router;
  MyApp({super.key, this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  void requestStoragePermission() async {
    // Check if the platform is not web, as web has no permissions
    if (!kIsWeb) {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Request camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => RepositoryAuth()),
        RepositoryProvider(create: (context) => RepositoryCustomer()),
        RepositoryProvider(create: (context) => RepositoryLocation()),
        RepositoryProvider(create: (context) => RepositoryAbsensi()),
        RepositoryProvider(create: (context) => RepositoryOrder()),
        RepositoryProvider(create: (context) => RepositoryVisitation()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MarkerLocationCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          BlocProvider(create: (context) => DistanceLocationCubit()),
          BlocProvider(create: (context) => AuthCubit(repository: RepositoryAuth())),
          // CUSTOMER
          BlocProvider(create: (context) => GetCustomerCubit(repository: RepositoryCustomer())),
          BlocProvider(create: (context) => GetCustomerVisitationCubit(repository: RepositoryCustomer())),
          // LOCATION
          BlocProvider(create: (context) => AddLocationCubit(repository: RepositoryLocation())),
          BlocProvider(create: (context) => GetLocationCustomerCubit(repository: RepositoryLocation())),
          // ABSENSI
          BlocProvider(create: (context) => GetLastCheckInCubit(repository: RepositoryAbsensi())),
          BlocProvider(create: (context) => AbsensiCheckInCubit(repository: RepositoryAbsensi())),
          BlocProvider(create: (context) => AbsensiCheckOutCubit(repository: RepositoryAbsensi())),
          // DESIGN
          BlocProvider(create: (context) => GetDesignCubit(repository: RepositoryOrder())),
          // COLOR
          BlocProvider(create: (context) => GetColorCubit(repository: RepositoryOrder())),
          // ORDER
          BlocProvider(create: (context) => GetOrderCubit(repository: RepositoryOrder())),
          BlocProvider(create: (context) => GetOrderDetailCubit(repository: RepositoryOrder())),
          // VISITATION
          BlocProvider(create: (context) => GetVisitationCubit(repository: RepositoryVisitation())),
          BlocProvider(create: (context) => GetVisitationDetailCubit(repository: RepositoryVisitation())),
          BlocProvider(create: (context) => InsertVisitationCubit(repository: RepositoryVisitation())),
          BlocProvider(create: (context) => UpdateVisitationCubit(repository: RepositoryVisitation())),
          BlocProvider(create: (context) => DeleteVisitationCubit(repository: RepositoryVisitation())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: ungu)),
          builder: EasyLoading.init(),
          onGenerateRoute: widget.router!.generateRoute,
        ),
      ),
    );
  }
}
