import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Playvideo extends StatefulWidget {
  final String url;

  Playvideo({required this.url});

  @override
  State<Playvideo> createState() => _PlayvideoState();
}

class _PlayvideoState extends State<Playvideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.url,
        ),
      );
      _initializeVideoPlayerFuture = _controller.initialize();
    });

    _controller.play();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller = VideoPlayerController.networkUrl(
            Uri.parse(
              widget.url,
            ),
          );
          _initializeVideoPlayerFuture = _controller.initialize();
        });

        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          // If the video is paused, play it.
          _controller.play();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
