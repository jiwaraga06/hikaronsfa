import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/router/string.dart';

import '../pages/index.dart';

class RouterNavigation {
  SlideTransition bottomToTop(context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(position: animation.drive(tween), child: child);
  }

  SlideTransition topToBottom(context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, -1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(position: animation.drive(tween), child: child);
  }

  SlideTransition rightToLeft(context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }

  SlideTransition leftToRight(context, animation, secondaryAnimation, child) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen(), transitionsBuilder: bottomToTop);
      case loginScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(), transitionsBuilder: bottomToTop);
      case dashboardScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(), transitionsBuilder: bottomToTop);
      case homeScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(), transitionsBuilder: bottomToTop);
      case inboxScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const InboxScreen(), transitionsBuilder: bottomToTop);
      case aktifitasScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const AktifitasScreen(), transitionsBuilder: bottomToTop);
      case profileScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(), transitionsBuilder: bottomToTop);
      case checkInScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const CheckINScreen(), transitionsBuilder: rightToLeft);
      case checkOutScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const CheckOutScreen(), transitionsBuilder: rightToLeft);
      case lokasiScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const LokasiScreen(), transitionsBuilder: rightToLeft);
      case orderScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const OrderScreen(), transitionsBuilder: topToBottom);
      case insertOrderScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const InsertOrderScreen(), transitionsBuilder: topToBottom);
      case updateOrderScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const UpdateOrderScreen(), transitionsBuilder: topToBottom);
      case orderDetailScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OrderDetailViewScreen(),
          transitionsBuilder: rightToLeft,
          settings: settings,
        );
      case visitationScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const VisitationScreen(), transitionsBuilder: topToBottom);
      case insertVisitationScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const InsertVisitationScreen(), transitionsBuilder: rightToLeft);
      case outstandingShipmentScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const OutstandingScreen(), transitionsBuilder: rightToLeft);
      case updateVisitationScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const UpdateVisitationScreen(),
          transitionsBuilder: rightToLeft,
          settings: settings,
        );
      case visitationDetailScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const VisitationDetailScreen(),
          transitionsBuilder: rightToLeft,
          settings: settings,
        );
      default:
        return null;
    }
  }
}
