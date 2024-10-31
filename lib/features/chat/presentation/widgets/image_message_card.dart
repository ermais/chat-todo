import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_todo/features/todo/presentation/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageMessageCard extends HookConsumerWidget {
  final String imageUrl;
  const ImageMessageCard({required this.imageUrl, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => ImageViewer(
                  imgaes: [imageUrl],
                ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: SizedBox(
            height: size.width / 2,
            width: size.width / 2,
            child: FittedBox(
              fit: BoxFit.cover,
              child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                          child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
