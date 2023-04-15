import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/utils/label.dart';
import 'package:myapp/utils/type_utils.dart';
import 'package:myapp/widget_utils/bottom_view.dart';
import 'package:myapp/utils/button.dart';
import 'package:myapp/utils/playbtn.dart';
import 'package:myapp/widget_utils/savedPath_view.dart';
import 'package:myapp/widget_utils/tab_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:nb_utils/nb_utils.dart';

import 'merge_audio_service.dart';
import 'widget_utils/header_view.dart';

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
  Duration mergedDuration = Duration();

  late Trimmer _trimmer;
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool playbackState = false;

  Future<File> writeFile(File data) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
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
            const HeaderView(),
            TabViewCustom(tabController: _tabController), // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  SizedBox(
                    height: sHeight - 10,
                    child: Column(
                      children: [
                        PathLabel(fileName: fileName_1, duration: duration_1),
                        Button(
                            label: "Add File 1",
                            color: Colors.white,
                            buttonStyle: TypeClass.srButtonStyle,
                            onPressFunc: filePicker1),
                        PathLabel(fileName: fileName_2, duration: duration_2),
                        Button(
                            label: "Add File 2",
                            color: Colors.white,
                            buttonStyle: TypeClass.srButtonStyle,
                            onPressFunc: filePicker2),
                        Padding(
                          padding: EdgeInsets.only(top: sHeight * 0.08),
                          child: Button(
                              label: "Merge Files",
                              buttonStyle: TypeClass.mrButtonStyle,
                              color: Colors.white,
                              onPressFunc: mergeFiles),
                        ),
                        Container(
                          height: sHeight * 0.18,
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saved File",
                                style: TypeClass.bodyTextStyle,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  PlayBtn(
                                      playState: _isPlaying,
                                      onPressFunc: playState),
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
                                      durationTextStyle: const TextStyle(
                                          color: Color(0xFFFFFFFF)),
                                      allowAudioSelection: true,
                                      editorProperties:
                                          const TrimEditorProperties(
                                        circleSize: 5,
                                        borderPaintColor: Color(0xFFc80000),
                                        borderWidth: 1,
                                        borderRadius: 0,
                                        circlePaintColor: Color(0xFFc80000),
                                        scrubberWidth: 3,
                                        scrubberPaintColor: Color(0xFFc80000),
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
                                  )
                                ],
                              ),
                              SavedPath(path: path).visible(success),
                            ],
                          ).visible(success),
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

  void playState() async {
    playbackState = await _trimmer.audioPlaybackControl(
      startValue: _startValue,
      endValue: _endValue,
    );
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() => _isPlaying = playbackState));
  }
}
