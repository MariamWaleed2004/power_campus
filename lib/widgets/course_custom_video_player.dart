import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseCustomVideoPlayer extends StatefulWidget {
  const CourseCustomVideoPlayer({
    super.key,
    required this.courseVideo,
  });

  final String courseVideo;

  @override
  State<CourseCustomVideoPlayer> createState() {
    return _CourseCustomVideoPlayer();
  }
}

class _CourseCustomVideoPlayer extends State<CourseCustomVideoPlayer> {
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();
    initializedVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomVideoPlayer(
        customVideoPlayerController: _customVideoPlayerController,
      ),
    );
  }

  void initializedVideoPlayer() {
    VideoPlayerController _videoPlayerController;
    _videoPlayerController = VideoPlayerController.network(widget.courseVideo)
      ..initialize().then((value) {
        setState(() {});
      });
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }
}
