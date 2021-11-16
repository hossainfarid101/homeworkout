import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';

class ExerciseDaysScreen extends StatefulWidget {
  @override
  _ExerciseDaysScreenState createState() => _ExerciseDaysScreenState();
}

class _ExerciseDaysScreenState extends State<ExerciseDaysScreen> {
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
        _scrollController!.offset > (200 - kToolbarHeight);
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
        systemOverlayStyle: isShrink ? SystemUiOverlayStyle.dark:SystemUiOverlayStyle.light,
        ),//
      ),
      child: Scaffold(
        drawer: DrawerMenu(),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 2,
                titleSpacing:-5,
                expandedHeight: 140.0,
                floating: false,
                pinned: true,
                leading: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.menu,color: isShrink ? Colur.black : Colur.white,),
                    )),
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(Languages.of(context)!.txt7X4Challenge,
                      style: TextStyle(
                        color: isShrink ? Colur.black : Colur.white,
                        fontSize: 16.0,
                      )),
                ),
                backgroundColor: Colors.white,
                /*flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Image.asset(
                    'assets/images/abs_advanced.webp',
                    fit: BoxFit.cover,
                  ),

                ),*/
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/abs_advanced.webp',
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                    "28 ${Languages.of(context)!.txtDaysLeft}",
                                    style: TextStyle(
                                        color: Colur.white, fontSize: 14.0)),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text("10%",
                                      style: TextStyle(
                                          color: Colur.white, fontSize: 14.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              right: 10, left: 10, top: 10, bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: LinearProgressIndicator(
                              value: (10 / 100).toDouble(),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colur.theme),
                              backgroundColor: Colur.transparent_50,
                              minHeight: 5,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Container(
                // child: _widgetListOfDays(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _widgetListOfDays() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 8,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return itemListDays(index);
      },
    );
  }

  itemListDays(int index) {
    return Container();
  }
}
