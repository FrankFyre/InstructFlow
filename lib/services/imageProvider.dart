import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String? imageUrl;

  ImageViewer({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageViewer(imageUrl: imageUrl!),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset("placeholder_image.png"),
            ),
          )
        : const Center(
            child: Text(
              "No image available",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image View"),
        backgroundColor: const Color.fromRGBO(48, 52, 63, 1),
      ),
      body: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child:
                PhotoView(imageProvider: CachedNetworkImageProvider(imageUrl)),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
