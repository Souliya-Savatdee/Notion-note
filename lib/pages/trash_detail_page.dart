import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mid_app/theme/colors.dart';

class TrashCardDetailPage extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String remind;
  final String priority;
  final String date;

  final Function() onAction;

  const TrashCardDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.remind,
    required this.priority,
    required this.date,
    required this.onAction,
  });

  @override
  _TrashCardDetailPageState createState() => _TrashCardDetailPageState();
}

class _TrashCardDetailPageState extends State<TrashCardDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  late String _remind;
  late String _selectedPriority;

  Future<void> deleteData(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                await deleteDataConfirmed(id);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to handle deletion after confirmation
  Future<void> deleteDataConfirmed(int id) async {
    try {
      final apiUrl = 'https://sheetdb.io/api/v1/6hf12ouxt0fmx/id/$id';
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print('Data deleted successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete Success'),
            duration: Duration(milliseconds: 1000),
          ),
        );

        widget.onAction(); // Call the callback function
        Navigator.pop(context);
      } else {
        print('Failed to delete data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> editData(
    int id,
  ) async {
    try {
      final apiUrl = 'https://sheetdb.io/api/v1/6hf12ouxt0fmx/id/$id';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'trash': "FALSE"}),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recover Success'),
            duration: Duration(milliseconds: 1000),
          ),
        );

        widget.onAction(); // Call the callback function
        Navigator.pop(context);
      } else {
        print('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _selectedPriority = widget.priority;
    _remind = widget.remind;
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
        icon: Icon(
          Icons.arrow_back_ios,
          size: 22,
          color: white.withOpacity(0.7),
        ),
      ),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.push_pin,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            _remind == "TRUE"
                ? Icons.notifications_active_rounded
                : Icons.notifications,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.archive,
            color: white.withOpacity(0.7),
            size: 22,
          ),
        )
      ],
    );
  }

  Widget getBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 120,
              child: DropdownButtonFormField<String>(
                items: ['High', 'Medium', 'Low'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(
                      priority,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: null,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: _selectedPriority,
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
          readOnly: true,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 22,
            color: white.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter title',
            hintStyle: TextStyle(color: white.withOpacity(0.5)),
          ),
        ),
        TextField(
          maxLines: 24,
          controller: _descriptionController,
          readOnly: true,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: white.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter description',
            hintStyle: TextStyle(color: white.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }

  String formatEditedDate(String dateStr) {
    DateTime date = DateFormat('MMMM d, y').parse(dateStr);
    return 'Edited ${DateFormat('d, MMMM').format(date)}';
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3)
        ],
        color: cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                await deleteData(widget.id);
              },
              icon: Icon(
                Icons.delete_forever,
                size: 22,
                color: white.withOpacity(0.7),
              ),
              tooltip: "Delete note",
            ),
            Text(
              formatEditedDate(widget.date),
              style: TextStyle(fontSize: 12, color: white.withOpacity(0.7)),
            ),
            IconButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and description are required'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                } else {
                  editData(widget.id);
                }
              },
              icon: Icon(
                Icons.replay,
                size: 22,
                color: white.withOpacity(0.7),
              ),
              tooltip: "Recover note",
            )
          ],
        ),
      ),
    );
  }
}
