import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/dialogs/ExerciseDialog.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/workout/workout_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen();

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  ScrollController? _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (100 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle:
              isShrink ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ), //
      ),
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                expandedHeight: 148.0,
                floating: false,
                pinned: true,
                backgroundColor: Colur.white,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: isShrink
                    ? Text(
                        Languages.of(context)!.txtAbsBeginner.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colur.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      )
                    : Container(),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: isShrink ? Colur.black : Colur.white,
                      size: 25.0,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 45.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/abs_advanced.webp',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Text(
                      Languages.of(context)!.txtAbsBeginner.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colur.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colur.white,
            margin: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _timesAndWorkoutsTitle(),
                      _divider(),
                      _exerciseList(),
                    ],
                  ),
                ),
                _divider(),
                _startButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _timesAndWorkoutsTitle() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
      child: Row(
        children: [
          Container(
            color: Colur.blueDivider,
            height: 12,
            width: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "20 " +
                    Languages.of(context)!.txtMins.toLowerCase() +
                    " • 16 " +
                    Languages.of(context)!.txtWorkouts.toLowerCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colur.txtBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _exerciseList() {
    return Expanded(
      child: Theme(
        data: ThemeData(
          canvasColor: Colur.transparent,
          shadowColor: Colur.transparent,
        ),
        child: ReorderableListView(
          children: <Widget>[
            for (int index = 0; index < 20; index++)
              ListTile(
                key: Key('$index'),
                title: _listOfExercise(index),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {},
        ),
      ),
    );
  }

  _listOfExercise(int index) {
    return InkWell(
      onTap: (){

        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: true,
          barrierColor: Colur.transparent,
          builder: (BuildContext context) {
            return ExerciseDialog();
          },
        );

      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Icon(Icons.menu_rounded, color: Colur.iconGrey),
              ),
              Container(
                height: 90.0,
                width: 100.0,
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/arm_advanced.webp',
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "JUMPING JACKS ${index.toString()}",
                        style: TextStyle(
                            color: Colur.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                (index == 0) ? "00:20" : "x15",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colur.txt_gray),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 35.0),
            child: _divider(),
          )
        ],
      ),
    );
  }

  _startButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        gradient: LinearGradient(
          colors: [
            Colur.blueGradientButton1,
            Colur.blueGradientButton2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: TextButton(
        child: Text(
          Languages.of(context)!.txtStart.toUpperCase(),
          style: TextStyle(
            color: Colur.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutScreen()));
        },
      ),
    );
  }
}
