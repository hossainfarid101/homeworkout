import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
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
          body:Container(
            color: Colur.iconGreyBg,
              child: Column(
                  children: [
                    _widgetListOfDays(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        gradient: LinearGradient(
                            colors: [
                              Colur.blueGradientButton1,
                              Colur.blueGradientButton2,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: TextButton(
                        child: Text(
                          Languages.of(context)!.txtGo.toUpperCase(),
                          style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 22.0,
                          ),
                        ),
                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseListScreen()));
                        },
                      ),
                    ),
                  ],
                ))
        ),
      ),
    );
  }

  _widgetListOfDays() {
    return Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (BuildContext context, int index) {
          return itemListDays(index);
        },
      ),
    );
  }

  itemListDays(int index) {

    var mainIndex = index;
    return Container(
      margin: const EdgeInsets.only(left: 10.0,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colur.theme,
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: Colur.white,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(Languages.of(context)!.txtweek+" "+(index+1).toString()),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Text("1/7"),
              ),

            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: 130,
                child: VerticalDivider(
                  color: Colur.theme,
                  width: 1,
                  thickness: 1,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20,right: 5),
                  alignment: Alignment.center,
                  color: Colur.white,
                  height: 110,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 3,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 10),
                      itemCount: 8,
                      itemBuilder: (BuildContext ctx, index) {
                        return _itemOfDays(index,mainIndex);
                      }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _itemOfDays(int index, mainIndex){
    return Container(
      // color: Colur.iconGreyBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(index == 0)...{
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colur.theme
              ),
              child: Icon(Icons.done_rounded,size: 20,color: Colur.white,),
            )
          }
          else if(index != 1 && index != 7)...{
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colur.grey_icon),
                border: Border.all(color: Colur.disableTxtColor),
              ),
              child: Text((index + 1).toString(),style: TextStyle(color: Colur.disableTxtColor),),
            )
          }else if(index == 7)...{
            Container(
              alignment: Alignment.center,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_challenge_uncomplete.webp"),
                  scale: 8
                )
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                (mainIndex + 1).toString(),
                style: TextStyle(fontSize: 12),
              )),
            )
          }
          else...{
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseListScreen()));
              },
              child: DottedBorder(
                color: Colur.theme,
                borderType: BorderType.Circle,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    child: Text((index + 1).toString(),style: TextStyle(color: (index != 0)?Colur.disableTxtColor:Colur.theme),),
                  ),
                ),
              ),
            )

          },
          Visibility(
            visible: ((index == 3) || (index == 7))?false:true,
            child: Icon(Icons.navigate_next_rounded,color: (index != 0)?Colur.disableTxtColor:Colur.theme,size: 20,),
          ),
        ],
      ),
    );
  }
}
