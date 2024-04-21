import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/constants.dart';

class CircularProgressWidget extends StatelessWidget {
  final bool isUpload;

  final double progressValue;
  final double? widthBorder;
  final double? iconSize;

  const CircularProgressWidget(
      {super.key,
      required this.isUpload,
      required this.progressValue,
      this.widthBorder,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progressValue,
            color: kPrimaryColor,
            strokeWidth: widthBorder ?? 7,
            strokeCap: StrokeCap.round,
            semanticsValue: "11",
            backgroundColor:
                Theme.of(context).iconTheme.color!.withOpacity(0.4),
          ),
          Icon(
            progressValue == 100
                ? Icons.check
                : (isUpload ? Icons.upload : Icons.download),
            size: iconSize ?? 20,
            color: progressValue == 100
                ? kPrimaryColor
                : isUpload
                    ? kPrimaryColor
                    : Theme.of(context).iconTheme.color!.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
