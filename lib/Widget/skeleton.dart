import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton {
  static skeleton1({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.3),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Container(color: Colors.grey[200]),
      ),
    );
  }

  static skeleton2({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(color: Colors.grey[200]),
        ),
      ),
    );
  }
}
