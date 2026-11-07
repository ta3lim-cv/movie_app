import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Color _background = Color(0xFFF6F4FA);
const Color _primary = Color(0xFF7456A6);
const Color _textColor = Color(0xFF29243D);
const Color _mutedColor = Color(0xFF827B92);

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPlayerPage({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _initializeFuture = _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await _controller.initialize();

    if (mounted) {
      await _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_controller.value.isInitialized) {
      return;
    }

    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _background,
        foregroundColor: _textColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: _primary,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Unable to play this video',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please check your internet connection or try another video.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _mutedColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Now Playing',
                    style: TextStyle(
                      color: _primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: const Color(0xFF29243D),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFECE7F3)),
                    ),
                    child: Column(
                      children: [
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: EdgeInsets.zero,
                          colors: const VideoProgressColors(
                            playedColor: _primary,
                            bufferedColor: Color(0xFFC9B9E2),
                            backgroundColor: Color(0xFFEAE5F1),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(value.position),
                                  style: const TextStyle(
                                    color: _mutedColor,
                                    fontSize: 12,
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: _togglePlayback,
                                  style: IconButton.styleFrom(
                                    backgroundColor: _primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(54, 54),
                                  ),
                                  icon: Icon(
                                    value.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  _formatDuration(value.duration),
                                  style: const TextStyle(
                                    color: _mutedColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'Enjoy watching your movie trailer',
                      style: TextStyle(color: _mutedColor, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
