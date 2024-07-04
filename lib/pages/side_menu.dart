import 'package:flutter/material.dart';

// import 'package:flutter_icons/flutter_icons.dart';

import 'package:mid_app/json/sidemenu_icon_json.dart';
import 'package:mid_app/pages/home_page.dart';
import 'package:mid_app/pages/remind_page.dart';
import 'package:mid_app/pages/side_menu_detail_page.dart';
import 'package:mid_app/pages/trash_page.dart';
import 'package:mid_app/theme/colors.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: cardColor),
        child: ListView(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: white.withOpacity(0.1)))),
              child: const DrawerHeader(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 30),
                  child: Text(
                    "Notion Note",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: white),
                  ),
                ),
              ),
            ),
            getSectionOne(),
            getSectionTwo(),
            getSectionThree(),
            getSectionFour(),
          ],
        ),
      ),
    );
  }

  Widget getSectionOne() {
    return Column(
      children: [
        Column(
          children: List.generate(2, (index) {
            return TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                if (index == 0) {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                } else if (index == 1) {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => RemindPage()));
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SideMenuDetailPage(
                                title: sideMenuItem[index]['text'],
                              )));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index]['icon'],
                      size: 22,
                      color: white.withOpacity(0.7),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      sideMenuItem[index]['text'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: white.withOpacity(0.7)),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Divider(
            thickness: 1,
            color: white.withOpacity(0.1),
          ),
        )
      ],
    );
  }

  Widget getSectionTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 15),
          child: Text(
            "LABELS",
            style: TextStyle(fontSize: 12, color: white.withOpacity(0.7)),
          ),
        ),
        Column(
          children: List.generate(5, (index) {
            return TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SideMenuDetailPage(
                              title: sideMenuItem[index + 2]['text'],
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index + 2]['icon'],
                      size: 22,
                      color: white.withOpacity(0.7),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      sideMenuItem[index + 2]['text'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: white.withOpacity(0.7)),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Divider(
            thickness: 1,
            color: white.withOpacity(0.1),
          ),
        )
      ],
    );
  }

  Widget getSectionThree() {
    return Column(
      children: [
        Column(
          children: List.generate(2, (index) {
            return TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                if (index == 1) {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => TrashPage()));
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SideMenuDetailPage(
                                title: sideMenuItem[index + 7]['text'],
                              )));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index + 7]['icon'],
                      size: 22,
                      color: white.withOpacity(0.7),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      sideMenuItem[index + 7]['text'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: white.withOpacity(0.7)),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Divider(
            thickness: 1,
            color: white.withOpacity(0.1),
          ),
        )
      ],
    );
  }

  Widget getSectionFour() {
    return Column(
      children: [
        Column(
          children: List.generate(3, (index) {
            return TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SideMenuDetailPage(
                              title: sideMenuItem[index + 9]['text'],
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index + 9]['icon'],
                      size: 22,
                      color: white.withOpacity(0.7),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      sideMenuItem[index + 9]['text'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: white.withOpacity(0.7)),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
