// import 'dart:async';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:breathing_exercise_new/other/app_colors.dart';
// import 'package:breathing_exercise_new/other/custom_slider_theme.dart';
// import 'package:breathing_exercise_new/other/utils.dart';
// import 'package:flutter/material.dart';
//
// class AudioPlayerDialog {
//   BuildContext _context;
//   AudioPlayer _audioPlayer;
//   String _url, _title;
//   // AudioPlayerState _audioPlayerState;
//   double _currentValue = 0.0, _duration = 0.0;
//
//   AudioPlayerDialog({
//     @required BuildContext context,
//     @required AudioPlayer audioPlayer,
//     @required String url,
//     @required String title,
//   }) {
//     this._context = context;
//     this._audioPlayer = audioPlayer;
//     this._url = url;
//     this._title = title;
//   }
//
//   Future<void> playAudio() async {
//     await showDialog(
//       barrierDismissible: false,
//       context: _context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Expanded(
//               child: Text('Now Playing'),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(Icons.close),
//             ),
//           ],
//         ),
//         content: StatefulBuilder(
//           builder: (context, setState) {
//             _initiateStateListenerStream(setState);
//             _initiateDurationListenerStream(setState);
//             return Container(
//               height: 90,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                             '  ${_title.length > 50 ? '${_title.substring(0, 45)}.....' : _title}'),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     height: 45,
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           child: Icon(
//                             _audioPlayerState == AudioPlayerState.PLAYING
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             color: AppColors.GREEN_ACCENT,
//                             size: 35,
//                           ),
//                           onTap: () {
//                             if (_audioPlayerState == null) {
//                               _play(setState);
//                             } else if (_audioPlayerState ==
//                                 AudioPlayerState.COMPLETED) {
//                               _play(setState);
//                             } else {
//                               _audioPlayerState == AudioPlayerState.PAUSED
//                                   ? _resume(setState)
//                                   : _pause(setState);
//                             }
//                           },
//                         ),
//                         SizedBox(
//                           width: 12,
//                         ),
//                         Expanded(
//                           child: SizedBox(
//                             height: 16,
//                             child: SliderTheme(
//                               data: SliderThemeData(
//                                 trackShape: CustomSliderTheme(),
//                               ),
//                               child: Slider(
//                                 activeColor: AppColors.GREEN_ACCENT,
//                                 max: _duration,
//                                 value: _currentValue,
//                                 onChanged: (value) async {
//                                   await _audioPlayer.seek(
//                                     Duration(
//                                       seconds: value.round(),
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
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     ).then((_) async {
//       await _audioPlayer.dispose();
//     });
//   }
//
//   void _initiateStateListenerStream(setState) {
//     _audioPlayer.onPlayerStateChanged
//         .listen((AudioPlayerState audioPlayerState) {
//       setState(() {
//         _audioPlayerState = audioPlayerState;
//       });
//     });
//   }
//
//   void _initiateDurationListenerStream(setState) {
//     _audioPlayer.onAudioPositionChanged.listen((Duration duration) async {
//       if (_duration == 0.0) {
//         _duration = ((await _audioPlayer.getDuration()) + .0) / 1000;
//       }
//       setState(() {
//         _currentValue = (duration.inSeconds) + .0;
//       });
//     });
//   }
//
//   Future<void> _play(setState) async {
//     try {
//       await _audioPlayer.play(_url);
//       setState(() {});
//     } catch (exc) {
//       Utils.showToast(message: 'Error playing this audio');
//     }
//   }
//
//   Future<void> _resume(setState) async {
//     try {
//       await _audioPlayer.resume();
//       setState(() {});
//     } catch (exc) {
//       Utils.showToast(message: 'Error resuming this audio');
//     }
//   }
//
//   Future<void> _pause(setState) async {
//     try {
//       await _audioPlayer.pause();
//       setState(() {});
//     } catch (exc) {
//       Utils.showToast(message: 'Error pausing this audio');
//     }
//   }
// }
