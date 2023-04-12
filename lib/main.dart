import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:myapp/utils/type_utils.dart';
import 'package:myapp/widget_utils/bottome_view.dart';
import 'package:myapp/widget_utils/savedfilePath_view.dart';
import 'package:myapp/widget_utils/tab_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:nb_utils/nb_utils.dart';

import 'merge_audio_service.dart';
import 'widget_utils/header_view.dart';
import 'utils/type_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //@override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //       length: 2,
  //       child: Container(
  //         color: Colors.black,
  //         padding: EdgeInsets.all(20),
  //         child: Scaffold(
  //           appBar: AppBar(
  //             // Here we take the value from the MyHomePage object that was created by
  //             // the App.build method, and use it to set our appbar title.
  //             backgroundColor: Colors.black,
  //             title: Container(
  //               margin: EdgeInsets.only(bottom: 20),
  //               padding: EdgeInsets.zero,
  //               child: Text("APPNAME",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 17,
  //                   )),
  //             ),
  //             actions: [
  //               SizedBox(
  //                 width: 80,
  //                 height: 80,
  //                 child: CircleAvatar(
  //                   radius: 40.0,
  //                   backgroundColor: Colors.green[600],
  //                   child: ClipOval(
  //                     child: Image.network(
  //                       "assets/images/uchiha.jpg",
  //                       width: 50.0,
  //                       height: 50.0,
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //             bottom: TabBar(
  //               indicatorColor: Colors.grey,
  //               dividerColor: Colors.red,
  //               tabs: [
  //                 Tab(
  //                   text: "MAIN",
  //                 ),
  //                 Tab(text: "LEADERBOARD")
  //               ],
  //             ),
  //           ),
  //           body: Container(
  //             color: Colors.black,
  //             child: TabBarView(
  //               children: [
  //                 Column(),
  //                 Container(),
  //               ],
  //             ),
  //           ),
  //           // This trailing comma makes auto-formatting nicer for build methods.
  //         ),
  //       ));
  // }

  late TabController _tabController;
  Duration duration_1 = Duration();
  String fileName_1 = "";
  Duration duration_2 = Duration();
  String fileName_2 = "";
  bool success = false;
  File? savedFile;
  String? path;
  Duration merged_Duration = Duration();

  late Trimmer _trimmer;
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool playbackState = false;
  int _currentIndex = 0;

  Future<File> writeFile(File data) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // var directory = await getApplicationDocumentsDirectory();
    // // ignore: unnecessary_null_comparison
    // if (directory != null) {
    //   setState(() {
    //     path = "${directory.path}/SavedRecording.wav";
    //   });
    //   return data.copy(path!);
    // } else {
    //   debugPrint("directory empty");
    // }
    return data;
  }

  void _loadAudio() async {
    // setState(() {
    //   isLoadingSave = true;
    // });
    if (savedFile != null) {
      Trimmer trimmer = Trimmer();
      await trimmer.loadAudio(audioFile: savedFile!);
      setState(() {
        _trimmer = trimmer;
        _startValue = 0.0;
        _endValue = 0.0;
        _isPlaying = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _trimmer = Trimmer();
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        mergeFiles();
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      // _trimmer.dispose();
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        color: Colors.black,
        child: Column(
          children: [
            HeaderView(),
            TabViewCustom(tabController: _tabController), // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  Container(
                    height: sHeight - 10,
                    child: Column(
                      children: [
                        Container(
                          height: sHeight * 0.1,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Filename: ${(fileName_1 != "") ? fileName_1.split("/").last : ""}",
                                style: TypeClass.bodyTextStyle,
                              ),
                              Text(
                                "Time: ${(fileName_1 != "") ? _printDuration(duration_1) : ""}",
                                style: TypeClass.bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: sWidth - 60,
                          height: sHeight * 0.05,
                          margin: EdgeInsets.only(bottom: 10),
                          child: OutlinedButton(
                            onPressed: filePicker1,
                            style: TypeClass.srButtonStyle,
                            child: Text("Add File 1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                        Container(
                          height: sHeight * 0.1,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Filename: ${(fileName_2 != "") ? fileName_2.split("/").last : ""}",
                                  style: TypeClass.bodyTextStyle),
                              Text(
                                "Time: ${(fileName_2 != "") ? _printDuration(duration_2) : ""}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: sWidth - 60,
                          height: sHeight * 0.05,
                          child: OutlinedButton(
                            onPressed: filePicker2,
                            style: TypeClass.srButtonStyle,
                            child: Text("Add File 2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                        Container(
                            height: sHeight * 0.13,
                            width: sWidth - 60,
                            padding: EdgeInsets.only(top: sHeight * 0.08),
                            margin: const EdgeInsets.only(bottom: 25),
                            child: OutlinedButton(
                              onPressed: mergeFiles,
                              style: TypeClass.mrButtonStyle,
                              child: Text(
                                "Merge Files",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: sHeight * 0.18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saved File",
                                style: TypeClass.bodyTextStyle,
                              ).visible(success),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextButton(
                                    child: _isPlaying
                                        ? Icon(
                                            Icons.pause_circle_outline_outlined,
                                            size: 40,
                                            color: const Color(0xFFFFFFFF),
                                          )
                                        : Icon(
                                            Icons.play_circle_outline_outlined,
                                            size: 40,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                    onPressed: () async {
                                      playbackState =
                                          await _trimmer.audioPlaybackControl(
                                        startValue: _startValue,
                                        endValue: _endValue,
                                      );
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) => setState(
                                              () =>
                                                  _isPlaying = playbackState));
                                    },
                                  ).visible(success),
                                  Expanded(
                                    child: TrimViewer(
                                      viewerWidth: sWidth - 30,
                                      viewerHeight: 40,
                                      trimmer: _trimmer,
                                      maxAudioLength:
                                          const Duration(minutes: 50),
                                      durationStyle: DurationStyle.FORMAT_MM_SS,
                                      backgroundColor: const Color(0x1A0075F8),
                                      barColor: const Color(0xFFFFFFFF),
                                      durationTextStyle: TextStyle(
                                          color: const Color(0xFFFFFFFF)),
                                      allowAudioSelection: true,
                                      editorProperties: TrimEditorProperties(
                                        circleSize: 5,
                                        borderPaintColor:
                                            const Color(0xFFc80000),
                                        borderWidth: 1,
                                        borderRadius: 0,
                                        circlePaintColor:
                                            const Color(0xFFc80000),
                                        scrubberWidth: 3,
                                        scrubberPaintColor:
                                            const Color(0xFFc80000),
                                      ),
                                      areaProperties:
                                          TrimAreaProperties.edgeBlur(
                                              blurEdges: true),
                                      onChangeStart: (value) =>
                                          _startValue = value,
                                      onChangeEnd: (value) => _endValue = value,
                                      onChangePlaybackState: (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) =>
                                                setState(() => _isPlaying =
                                                    playbackState));
                                      },
                                    ),
                                  ).visible(success)
                                ],
                              ),
                              savedfilePath_view(path: path).visible(success),
                            ],
                          ),
                        ),
                        const BottomView(),
                      ],
                    ),
                  ),
                  // second tab bar view widget
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filePicker2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      final player = AudioPlayer();
      var duration = await player.setUrl(filePath!);
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => setState(() {
      //           duration_2 = duration!;
      //           fileName_2 = filePath;
      //         }));
      setState(() {
        duration_2 = duration!;
        fileName_2 = filePath;
      });
    } else {
      // User canceled the picker
    }
  }

  void filePicker1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      final player = AudioPlayer();
      var duration = await player.setUrl(filePath!);
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => setState(() {
      //           duration_1 = duration!;
      //           fileName_1 = filePath;
      //         }));
      setState(() {
        duration_1 = duration!;
        fileName_1 = filePath;
      });
    } else {
      // User canceled the picker
    }
  }

  void mergeFiles() async {
    setState(() {
      success = false;
    });
    savedFile = await FFmpeg.concatenate([fileName_1, fileName_2], (file) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            savedFile = file;
            success = (file != null) ? true : false;
            path = file?.path;
          }));
      _loadAudio();
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
