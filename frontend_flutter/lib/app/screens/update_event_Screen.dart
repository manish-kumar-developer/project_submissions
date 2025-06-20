import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EventModel {
  final String name;
  final DateTime dateTime;
  final String? description;
  final String imagePath;

  EventModel({
    required this.name,
    required this.dateTime,
    required this.imagePath,
    this.description,
  });
}

class UpdateEventScreen extends StatefulWidget {
  final EventModel event;

  const UpdateEventScreen({super.key, required this.event});

  @override
  State<UpdateEventScreen> createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late DateTime selectedDateTime;
  File? updatedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event.name);
    descriptionController = TextEditingController(text: widget.event.description ?? '');
    selectedDateTime = widget.event.dateTime;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickNewImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => updatedImageFile = File(picked.path));
    }
  }

  Future<void> pickNewDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void handleUpdate() {
    if (nameController.text.trim().isEmpty || selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final updatedEvent = EventModel(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      dateTime: selectedDateTime,
      imagePath: updatedImageFile?.path ?? widget.event.imagePath,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event updated successfully!")),
    );

    Navigator.pop(context, updatedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final imageToShow = updatedImageFile != null
        ? FileImage(updatedImageFile!)
        : (widget.event.imagePath.startsWith('http')
        ? NetworkImage(widget.event.imagePath)
        : FileImage(File(widget.event.imagePath))) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Event"),
        backgroundColor: const Color(0xFF2193b0),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Event",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2193b0)),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: pickNewImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: imageToShow,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Event Name *",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: TextEditingController(
                      text: DateFormat("MMM dd, yyyy - hh:mm a").format(selectedDateTime),
                    ),
                    readOnly: true,
                    onTap: pickNewDateTime,
                    decoration: const InputDecoration(
                      labelText: "Date & Time *",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: handleUpdate,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF2193b0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Update Event",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
