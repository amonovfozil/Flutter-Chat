import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleImage extends StatelessWidget {
  final RxString img;
  final double? radius;
  const CircleImage({super.key, required this.img, this.radius});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => img.value.isEmpty
          ? Container(
              height: radius ?? 55,
              width: radius ?? 55,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const ImageIcon(
                AssetImage(
                  "assets/images/user_icon.png",
                ),
              ),
            )
          : Container(
              height: radius ?? 50,
              width: radius ?? 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2,
                    color: Theme.of(context).iconTheme.color!,
                    strokeAlign: BorderSide.strokeAlignOutside),
              ),
              child: FadeInImage(
                image: NetworkImage(
                  img.value,
                  scale: 1.0,
                ),
                placeholder: const AssetImage("assets/images/user_3.png"),
                imageErrorBuilder: (context, error, stackTrace) =>
                    const ImageIcon(AssetImage("assets/images/user_icon.png")),
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
