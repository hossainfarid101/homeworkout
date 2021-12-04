import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class ExercisePlanScreen extends StatefulWidget {

  DiscoverPlanTable? homePlanTable;

  ExercisePlanScreen({required this.homePlanTable});
  @override
  _ExercisePlanScreenState createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {

  ScrollController? _scrollController;
  List<DiscoverPlanTable> discoverSubPlanList = [];
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
    _getHomeSubPlanList();
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
        drawer: DrawerMenu(),
        body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 2,
                  titleSpacing: -5,
                  expandedHeight: 160.0,
                  floating: false,
                  pinned: true,
                  leading: InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.menu,
                          color: isShrink ? Colur.black : Colur.white,
                        ),
                      )),
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      isShrink ? widget.homePlanTable!.planName!.toUpperCase() : "",
                      style: TextStyle(
                        color: isShrink ? Colur.black : Colur.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  centerTitle: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/abs_advanced.webp',
                              ),
                              fit: BoxFit.cover)),
                      child: Container(
                        margin: const EdgeInsets.only(right: 15.0, left: 30, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                  widget.homePlanTable!.planName!.toUpperCase(),
                                style: TextStyle(
                                  color: Colur.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ),
                            AutoSizeText(
                                widget.homePlanTable!.shortDes!.toString(),
                                style: TextStyle(
                                    color: Colur.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              color: Colur.iconGreyBg,
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap:() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExerciseListScreen(
                                  fromPage: Constant.PAGE_DISCOVER,
                                  planName: discoverSubPlanList[index].planName,
                                  discoverPlanTable: discoverSubPlanList[index]
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              "assets/images/abs_advanced.webp",
                              width: 55,
                              height: 55,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                        discoverSubPlanList[index].planName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colur.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      discoverSubPlanList[index].planText.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colur.txt_gray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: discoverSubPlanList.length,
                separatorBuilder: (BuildContext context, int index) { 
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15,),
                    child: Divider(
                      thickness: 1.3,
                    ),
                  );
                },

              )
            )
        ),
      ),
    );
  }

  _getHomeSubPlanList() async{
    discoverSubPlanList = await DataBaseHelper().getHomeSubPlanList(widget.homePlanTable!.planId!);
    discoverSubPlanList.forEach((element) {

    });
    setState(() {});
  }
}
