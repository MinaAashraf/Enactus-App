import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  late BuildContext context;
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    screenHeight = getScreenHeight(context);
    screenWidth = getScreenWidth(context);
    const String ABOUT_US = 'About us';
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: ABOUT_US,
          child: Text(
            ABOUT_US,
            style:
                getTextTheme(context).headline2!.copyWith(color: PRIMARY_SWATCH),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          buildVerticalSpace(height: screenHeight/50),
          Text(
            'High Board',
            style: getTextTheme(context).headline1!.copyWith(fontSize: 24),
          ),
          buildVerticalSpace(height: screenHeight/20),
          buildBoardList(),
          buildAboutVisionMissionList(),
          buildVerticalSpace(height: screenHeight/20),
        ]),
      ),
    );
  }

  List boardImages = [board1, board2, board3, board4, board5];
  List names = [
    'AMR HAMMAD',
    'ASSER AHMED',
    'MOHAMED AZWAK',
    'AHMED HASSAN',
    'HODA EZZAT',
  ];
  List titles = [
    'PRESIDENT',
    'VICE PRESIDENT',
    'DIRECTOR OF ENTREPRENEURS',
    'DIRECTOR OF FINANCE',
    'DIRECTOR OF COMMITTEES',
  ];

  buildBoardList() {
    return Container(
      height: screenHeight * 0.4,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => buildBoardItem(index),
          separatorBuilder: (BuildContext context, int index) =>
              buildHorizontalSpace(width: 0),
          itemCount: 5),
    );
  }

  buildBoardItem(int index) {
    return Container(
      width: screenWidth*0.7,
      child: Column(
        children: [
          buildCircleImage(boardImages[index], LARGE_PHOTO_SIZE,
              assetImage: true),
          buildVerticalSpace(height: 10),
          Text(
            names[index],
            style: getTextTheme(context)
                .headline1!
                .copyWith(fontSize: 24, color: PRIMARY_SWATCH),
          ),
          Text(
            titles[index],
            style: getTextTheme(context).bodyText1,
          ),
        ],
      ),
    );
  }

  buildAboutVisionMissionList() {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth*0.07,right: screenWidth*0.03),
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => buildAboutVisionMissionColumnItem(
              headers[index], descriptions[index]),
          separatorBuilder: (context, index) =>
              buildVerticalSpace(height: screenHeight / 35),
          itemCount: headers.length),
    );
  }

  buildAboutVisionMissionColumnItem(String header, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          header,
          style: getTextTheme(context).headline1,
        ),
        buildVerticalSpace(height: 10),
        Text(
          description,
          style: getTextTheme(context).bodyText2!.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
