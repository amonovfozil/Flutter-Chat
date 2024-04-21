import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/components/circular_progress.dart';
import 'package:get/get.dart';

class UnDownloadFIleView extends StatelessWidget {
  final bool isVisible;
  final bool isUpload;
  final double progressIndecator;
  const UnDownloadFIleView(
      {super.key,
      required this.isVisible,
      required this.isUpload,
      required this.progressIndecator});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: ExactAssetImage('assets/images/Video Place Here.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4)),
            child: CircularProgressWidget(
              isUpload: isUpload,
              progressValue: progressIndecator,
            ),
          ),
        ),
      ),
    );
  }
}
