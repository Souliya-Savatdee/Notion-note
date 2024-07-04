import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mid_app/theme/colors.dart';

class AddCardNote extends StatefulWidget {
  final int? lastId;
  final Function fetchDataCallback;

  const AddCardNote({super.key, this.lastId, required this.fetchDataCallback});

  @override
  _AddCardNoteState createState() => _AddCardNoteState();
}

class _AddCardNoteState extends State<AddCardNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isPosting = false; 
  String? selectedPriority;
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  Future<void> postData(String title, String description, String formattedDate,
      String? selectedPriority) async {
    setState(() {
      _isPosting = true;
      print(widget.lastId);
    });

    try {
      int id = widget.lastId != null ? widget.lastId! + 1 : 1;
      const apiUrl = 'https://sheetdb.io/api/v1/6hf12ouxt0fmx';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'title': title,
          'description': description,
          'remind': "FALSE",
          'datetime': formattedDate,
          'priority': selectedPriority,
          'trash': "FALSE",
        }),
      );

      if (response.statusCode == 201) {
        print('Data submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create Success'),
            duration: Duration(milliseconds: 1000),
          ),
        );

        widget.fetchDataCallback();
        Navigator.pop(context);
      } else {
        print('Failed to submit data. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: getAppBar(),
      body: getBody(),
      bottomSheet: getFooter(),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 22,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'Add Note',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (!_isPosting) {
              if (_titleController.text.isEmpty ||
                  _descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Title and description are required'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              } else if (selectedPriority == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Priority is required'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              } else {
                postData(_titleController.text, _descriptionController.text,
                    formattedDate, selectedPriority);
              }
            }
          },
          tooltip: "Add note",
          icon: const Icon(
            Icons.check,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget getBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end, 
          children: [
            SizedBox(
              width: 120, 
              child: DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['High', 'Medium', 'Low'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(
                      priority,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPriority = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  hintText: 'Priority',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
                dropdownColor: cardColor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: _titleController,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 22,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter title',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
        TextField(
          maxLines: 24,
          controller: _descriptionController,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter description',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
        color: cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _titleController.clear();
                _descriptionController.clear();
              },
              icon: const Icon(
                Icons.backspace,
                size: 22,
                color: Colors.white,
              ),
              tooltip: "Cleat text",
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
