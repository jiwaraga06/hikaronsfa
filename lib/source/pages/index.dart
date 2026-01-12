import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikaronsfa/Widget/customButton2.dart';
import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/Widget/customField.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/router/string.dart';
import 'package:hikaronsfa/source/service/Auth/cubit/auth_cubit.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:hikaronsfa/source/service/Customer/cubit/get_customer_cubit.dart';
import 'package:hikaronsfa/source/service/Location/cubit/add_location_cubit.dart';
import 'package:hikaronsfa/source/service/MarkerLocation/cubit/marker_location_cubit.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dropdown_search/dropdown_search.dart';

part './Auth/splashScreen.dart';
part './Auth/loginScreen.dart';
part './Dashboard/dashboard.dart';
// Menu
part 'Menu/Home/home.dart';
part 'Menu/Inbox/inbox.dart';
part 'Menu/Aktifitas/aktifitas.dart';
part 'Menu/Profile/profile.dart';
// Absensi
part 'Menu/Absensi/checkin.dart';
part 'Menu/Absensi/checkout.dart';
// Loaksi
part 'Menu/Lokasi/lokasi.dart';


