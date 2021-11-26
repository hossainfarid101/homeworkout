 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAnimationScreen extends StatefulWidget {

  VideoAnimationScreen();

  @override
  _VideoAnimationScreenState createState() => _VideoAnimationScreenState();
}

class _VideoAnimationScreenState extends State<VideoAnimationScreen>
    with TickerProviderStateMixin {
  bool isAnimation = false;
  YoutubePlayerController? _controllerYoutubeView;
  Animation<int>? listLifeGuideAnimation;
  AnimationController? listLifeGuideController;

  int countOfImages = 0;

  @override
  void initState() {
    _getYoutubeVideo();
    super.initState();
  }

  @override
  void dispose() {
    listLifeGuideController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar( // Here we create one to set status bar color
              backgroundColor: Colur.theme,
              elevation: 0,
            )
        ),
        backgroundColor: Colur.theme,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                _topListView(),
                _topBar(),
                _youtubeAndAnimationView(),
                _descriptionOfExercise()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topListView() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 10,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 5,
            width: MediaQuery.of(context).size.width /
                10 -
                6,
            child: Divider(
              color: /*(lastPosition! > index) ? CColor.theme : */Colur.txt_gray,
              height: 2,
              thickness: 5,
            ),
          );
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
      ),
    );
  }

  _topBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colur.white,
              )
          ),
          Expanded(
              child: Container(
            child: null,
          )),
          InkWell(
            onTap: () {
              setState(() {
                if (isAnimation) {
                  isAnimation = false;
                } else {
                  isAnimation = true;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  (isAnimation)
                      ? Image.asset(
                          "assets/icons/cp_ic_animation.png",
                          scale: 1.5,
                          color: Colur.white,
                        )
                      : Icon(
                          Icons.videocam,
                          size: 25, color: Colur.white,
                        ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      (isAnimation)  ? Languages.of(context)!.txtAnimation.toUpperCase() : Languages.of(context)!.txtVideo.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colur.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _youtubeAndAnimationView() {
    return Column(
      children: [
        Visibility(
          visible: isAnimation,
          child: Container(
            height: 250,
            child: YoutubePlayer(
              controller: _controllerYoutubeView!,
              showVideoProgressIndicator: true,
            ),
          ),
        ),
        Visibility(
          visible: !isAnimation,
          child:  Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 250,
            width: double.infinity,

            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: AnimatedBuilder(
                animation: listLifeGuideAnimation!,
                builder: (BuildContext context, Widget? child) {
                  String frame = listLifeGuideAnimation!
                      .value
                      .toString();
                  return new Image.asset(
                    'assets/images/img_exercise.webp',
                    gaplessPlayback: true,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _descriptionOfExercise() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               "SINGLE BICYCLE CRUNCHES",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0, color: Colur.white),
              ),
              SizedBox(height: 15,),
              Text(
                "x30",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0, color: Colur.white),
              ),
              SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin. \n\nHe lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover it and seemed ready to slide off any moment. ',
                  style: TextStyle(fontSize: 16.0, color: Colur.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getYoutubeVideo() async {
    //await _getImageFromAssets();

    int duration = 0;
    if(countOfImages > 2 && countOfImages<=4){
      duration = 3000;
    } else if(countOfImages > 4 && countOfImages<=6){
      duration = 4500;
    } else if(countOfImages > 6 && countOfImages<=8){
      duration = 6000;
    } else if(countOfImages > 8 && countOfImages<=10){
      duration = 8500;
    } else if(countOfImages > 10 && countOfImages<=12){
      duration = 9000;
    } else if(countOfImages > 12 && countOfImages<=14){
      duration = 14000;
    }else{
      duration = 1500;
    }

    listLifeGuideController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    listLifeGuideAnimation = new IntTween(begin: 1, end: countOfImages)
        .animate(listLifeGuideController!);

    setState(() {
      _controllerYoutubeView = YoutubePlayerController(
        initialVideoId: "iLnmTe5Q2Qw",
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    });
  }

  /*_getImageFromAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
            key.contains(widget.exerciseTable!.exPath.toString()))
        .where((String key) => key.contains('.webp'))
        .toList();

    countOfImages = imagePaths.length;

  }*/
}
