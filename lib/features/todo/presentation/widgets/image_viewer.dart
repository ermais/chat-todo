import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulHookConsumerWidget {
  const ImageViewer({required this.imgaes, this.currentIndex = 0, super.key});
  final List<String> imgaes;
  final int currentIndex;

  @override
  ConsumerState<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends ConsumerState<ImageViewer> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imgaes[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
          );
        },
        itemCount: widget.imgaes.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0.0
                  : event.cumulativeBytesLoaded /
                      event.expectedTotalBytes!.toDouble(),
            ),
          ),
        ),
        pageController: pageController,
      ),
    );
  }
}
