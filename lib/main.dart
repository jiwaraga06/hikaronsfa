import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:hikaronsfa/source/repository/RepositoryLocation.dart';
import 'package:hikaronsfa/source/repository/repositoryCustomer.dart';
import 'package:hikaronsfa/source/router/router.dart';
import 'package:hikaronsfa/source/service/Auth/cubit/auth_cubit.dart';
import 'package:hikaronsfa/source/service/Customer/cubit/get_customer_cubit.dart';
import 'package:hikaronsfa/source/service/Location/cubit/add_location_cubit.dart';
import 'package:hikaronsfa/source/service/MarkerLocation/cubit/marker_location_cubit.dart';

void main() {
  runApp(MyApp(router: RouterNavigation()));
}

class MyApp extends StatelessWidget {
  RouterNavigation? router;
  MyApp({super.key, this.router});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => RepositoryAuth()),
        RepositoryProvider(create: (context) => RepositoryCustomer()),
        RepositoryProvider(create: (context) => RepositoryLocation()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(repository: RepositoryAuth())),
          BlocProvider(create: (context) => GetCustomerCubit(repository: RepositoryCustomer())),
          BlocProvider(create: (context) => AddLocationCubit(repository: RepositoryLocation())),
          BlocProvider(create: (context) => MarkerLocationCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: ungu)),
          builder: EasyLoading.init(),
          onGenerateRoute: router!.generateRoute,
        ),
      ),
    );
  }
}
