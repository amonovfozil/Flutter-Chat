import 'package:flutter/material.dart';
import 'package:flutter_chat/models/chat_message.dart';

import '../../utils/constants.dart';

class ImageMessage extends StatelessWidget {
  final MessageModels message;
  const ImageMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Container(
          decoration: BoxDecoration(
            color: kBorderColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FadeInImage(
            image: NetworkImage(
              message.file!.url,
              scale: 1.0,
            ),
            placeholder: const AssetImage("assets/images/Video Place Here.png"),
            imageErrorBuilder: (context, error, stackTrace) =>
                const ImageIcon(AssetImage("assets/images/user_icon.png")),
            // fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
