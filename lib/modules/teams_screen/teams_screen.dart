import 'package:enactus/modules/teams_screen/members_screen/members_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';

class TeamsScreen extends StatelessWidget {
  double screenHeight = 0.0;

  double screenWidth = 0.0;


  List<String> images = [
    logistics_IMAGE,
    planing_IMAGE,
    fundraising_IMAGE,
    hr_IMAGE,
    PRESENTATION_IMAGE,
    marketing_IMAGE,
    VISUALS_IMAGE,
    Entrepreneurs_IMAGE,
    Entrepreneurs_IMAGE,
    Entrepreneurs_IMAGE,
    Entrepreneurs_IMAGE
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = getScreenHeight(context);
    screenWidth = getScreenWidth(context);
    const String TEAMS = 'Teams';
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: TEAMS, child: Text(TEAMS)),
        titleTextStyle:
            getTextTheme(context).headline2!.copyWith(color: PRIMARY_SWATCH),
        titleSpacing: screenWidth / 15,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
            itemBuilder: (context, index) => buildTeamItem(index, context),
            itemCount: images.length),
      ),
    );
  }

  buildTeamItem(int index, context) {
    return InkWell(
      onTap: () =>
          navigate(context, TeamMembersScreen(teamName: TEAMS_NAMES[index])),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Card(
          color: PRIMARY_SWATCH,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Image.asset(
                    images[index],
                    width: double.infinity,
                    height: screenHeight / 3.5,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  TEAMS_NAMES[index].toUpperCase(),
                  style: getTextTheme(context).headline2!.copyWith(fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
