import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'package:mid_app/models/note_model.dart';
import 'package:mid_app/pages/card_detail_page.dart';
import 'package:mid_app/pages/side_menu.dart';
import 'package:mid_app/theme/colors.dart';
import 'package:mid_app/pages/add_card_note.dart';

import 'package:page_transition/page_transition.dart';

class RemindPage extends StatefulWidget {
  @override
  _RemindPageState createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<Note> notes = [];
  List<Note> filteredNotes = [];

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchNotes();
    _searchController.addListener(_filterNotes);
  }

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response =
          await http.get(Uri.parse('https://sheetdb.io/api/v1/6hf12ouxt0fmx'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('Fetched Data: $data');

        List<dynamic> filteredData = data.where((noteJson) {
          return noteJson['remind'] == "TRUE";
        }).toList();

        setState(() {
          print(filteredData);
          notes =
              filteredData.map((noteJson) => Note.fromJson(noteJson)).toList();
          filteredNotes = notes;
          isLoading = false;
        });
      } else {
        print('Error: Server returned status code ${response.statusCode}');
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes
          .where((note) => note.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int lastId = notes.isNotEmpty ? notes.last.id : 0;

    return Scaffold(
      key: _drawerKey,
      drawer: SideMenu(),
      backgroundColor: bgColor,
      body: getBody(),
      bottomSheet: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddCardNote(lastId: lastId, fetchDataCallback: fetchNotes)),
          );
        },
        tooltip: "Add notes",
        backgroundColor: bgColor,
        child: Center(
          child: SvgPicture.asset(
            "assets/images/google_icon.svg",
            width: 30,
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
              width: size.width,
              height: 45,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3)
              ], color: cardColor, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _drawerKey.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: white.withOpacity(0.7)),
                            decoration: InputDecoration(
                              hintText: 'Search your notes',
                              hintStyle: TextStyle(
                                  color: white.withOpacity(0.7), fontSize: 15),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.grid_view,
                          color: white.withOpacity(0.7),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://static.vecteezy.com/system/resources/previews/005/545/335/non_2x/user-sign-icon-person-symbol-human-avatar-isolated-on-white-backogrund-vector.jpg"),
                                  fit: BoxFit.cover)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "REMINDS",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: white.withOpacity(0.6)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              getGridView()
            ],
          )
        ],
      ),
    );
  }

  Widget getGridView() {
    var size = MediaQuery.of(context).size;
    if (isLoading) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 300.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (filteredNotes.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.only(bottom: 300),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No data is available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: List.generate(filteredNotes.length, (index) {
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: CardDetailPage(
                      id: filteredNotes[index].id,
                      title: filteredNotes[index].title,
                      description: filteredNotes[index].description,
                      remind: filteredNotes[index].remind,
                      priority: filteredNotes[index].priority,
                      date: filteredNotes[index].date,
                      onAction: fetchNotes,
                    ),
                  ),
                );
              },
              child: ElasticIn(
                duration: Duration(milliseconds: index * 850),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: cardColor,
                      border: Border.all(color: white.withOpacity(0.1)),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 8,
                            right: 8,
                            bottom: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredNotes[index].title,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 150),
                                child: Text(
                                  filteredNotes[index].description,
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filteredNotes[index].date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    filteredNotes[index].priority,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3)
      ], color: bgColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.check_box,
                        size: 20,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.brush,
                        size: 18,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.mic_rounded,
                        size: 22,
                        color: white.withOpacity(0.5),
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.insert_photo,
                        size: 22,
                        color: white.withOpacity(0.5),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
