import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '/widgets/image_view.dart';
import '/widgets/video_view.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({
    super.key,
    required this.asset,
  });

  final AssetEntity asset;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbnailData.then((value) => value!),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return const Image(image: AssetImage('assets/image_not_found.png'));
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (asset.type == AssetType.image) {
                    // If this is an image, navigate to ImageScreen
                    return ImageView(
                      imageFile: asset.file,
                    );
                  } else {
                    // if it's not, navigate to VideoScreen
                    return VideoView(
                      videoFile: asset.file,
                    );
                  }
                },
              ),
            );
          },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (asset.type == AssetType.video)
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ]),
                    child: Text(Duration(seconds: asset.duration)
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0")
                        .substring(1)),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
