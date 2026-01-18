import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "Content-Type";
const String ACCEPT = "Accept";
const String AUTHORIZATION = "authorization";

enum AttendanceType { checkIn, checkOut }

late List<CameraDescription> cameras;

var selectedCustomerType = "C";
// const url = "http://192.168.0.126:8000";
const url = "https://toya-pyrheliometric-roseanne.ngrok-free.dev";
// const url = "http://203.210.84.8:9999";
// const url2 = "https://api-v3.hris.rsuumc.com";
// const url2 = "https://api-v2.rsuumc.com";
var tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
PermissionStatus? storagePermission;
PermissionStatus? locationPermission;
PermissionStatus? cameraPermission;

bool isCheckin = false;

var oid_uuid = "";

int selectedIndex = 0;

const hijau = Color(0XFF00712D);
const hijauDark = Color(0XFF1A5319);
const hijauLight = Color(0XFF508D4E);
const hijauLight2 = Color(0XFF80AF81);
const hijauDark2 = Color(0XFF00712D);
const hijauDark3 = Color(0XFF215E61);
const hijauTeal1 = Color(0XFF41B3A2);
const whiteCustom = Color.fromRGBO(245, 245, 245, 1);
const whiteCustom2 = Color.fromARGB(255, 255, 255, 255);
const merah = Color(0XFFA91D3A);
const merah2 = Color(0XFFBF092F);
const navy = Color(0XFF1B3C53);
const navy2 = Color(0XFF234C6A);
const biru = Color(0XFF125B9A);
const biru2 = Color(0XFF000080);
const amber = Color(0XFFFAB12F);
const amber2 = Color(0XFFE9762B);
const ungu = Color(0XFF4D2B8C);
const ungu2 = Color(0XFF62109F);
const ungu3 = Color(0XFF393D7E);
const ungu4 = Color(0XFF4D2FB2);
