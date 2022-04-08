//
// import 'package:breathing_exercise_new/other/app_colors.dart';
// import 'package:breathing_exercise_new/other/custom_slider_theme.dart';
// import 'package:breathing_exercise_new/other/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class PlayVideoPage extends StatefulWidget {
//   String _videoUrl, _title;
//
//   PlayVideoPage(this._title, this._videoUrl);
//
//   @override
//   _PlayVideoPageState createState() => _PlayVideoPageState();
// }
//
// class _PlayVideoPageState extends State<PlayVideoPage> {
//   VideoPlayerController _controller;
//   bool _isLoading = true;
//   double _currentValue;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(widget._videoUrl)
//       ..initialize().then((value) {
//         setState(() {
//           _isLoading = false;
//         });
//         _controller.play();
//         _controller.setLooping(true);
//         _currentValue = _controller.value.position.inMilliseconds + .0;
//         _controller.addListener(() {
//           setState(() {
//             _currentValue = _controller.value.position.inMilliseconds + .0;
//           });
//         });
//       });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(widget._title),
//         centerTitle: true,
//         backgroundColor: AppColors.GREEN_ACCENT,
//       ),
//       body: _isLoading || !_controller.value.isInitialized
//           ? Utils.loadingContainer()
//           : Stack(
//               children: [
//                 Container(
//                   child: VideoPlayer(_controller),
//                   margin: EdgeInsets.only(bottom: 45),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: 45,
//                     color: Colors.white,
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           child: Icon(
//                             _controller.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             size: 35,
//                             color: AppColors.GREEN_ACCENT,
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _controller.value.isPlaying
//                                   ? _controller.pause()
//                                   : _controller.play();
//                             });
//                           },
//                         ),
//                         Expanded(
//                           child: SizedBox(
//                             height: 32,
//                             child: SliderTheme(
//                               data: SliderThemeData(
//                                 trackShape: CustomSliderTheme(),
//                               ),
//                               child: Slider(
//                                 activeColor: AppColors.GREEN_ACCENT,
//                                 max: _controller.value.duration.inMilliseconds +
//                                     .0,
//                                 value: _currentValue,
//                                 onChanged: (value) {
//                                   _controller.seekTo(
//                                     Duration(
//                                       milliseconds: value.round(),
//                                     ),
//                                   );
//                                   setState(() {
//                                     _currentValue = value;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
