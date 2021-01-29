import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class StreamLiveScreen extends StatefulWidget {
  final title;
  final linkServer;

  StreamLiveScreen({this.title, @required this.linkServer});

  @override
  _StreamLiveScreenState createState() => _StreamLiveScreenState();
}

class _StreamLiveScreenState extends State<StreamLiveScreen> {
  VlcPlayerController _videoViewController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _videoViewController = VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        _videoViewController.pause();
      }),
      body: SizedBox(
        width: mSize.width,
        height: mSize.height,
        child: VlcPlayer(
          controller: _videoViewController,
          aspectRatio: 3 / 2,
          url: widget.linkServer,
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
