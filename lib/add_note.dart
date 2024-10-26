import 'package:easy_note_app/home_page.dart';
import 'package:flutter/material.dart';
// import "package:flutter_sqflite_example/home_page.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'database/db_helper.dart';
import 'model/note.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  late DatabaseHelper dbHelper;

  var titleController=TextEditingController();
  var descriptionController=TextEditingController();

  final GlobalKey<FormState> noteFormKey = GlobalKey();

  //add notes to database
  Future addNotes() async
  {
    final newNote = Note(
      title: titleController.text,
      description: descriptionController.text,
    );

    //if data insert successfully, its return row number which is greater that 1 always
    int check= await dbHelper.insertData(newNote.toMap());
    print("Check=$check");
    if(check>0)
    {


      Get.snackbar("Success", "Note Added",snackPosition: SnackPosition.BOTTOM);
      Get.offAll(HomePage());
    }
    else
    {
      Get.snackbar("Error", "Error in adding notes",snackPosition: SnackPosition.BOTTOM);
    }


  }


  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text("Add Notes",style: TextStyle(
            color: Colors.white
        ),),


      ),
      body: Form(
        key: noteFormKey,
        child:SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [

              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Title",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter note title";
                  }

                  return null;
                },
              ),

              SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Description",
                  prefixIcon: const Icon(Icons.notes),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter description";
                  }

                  return null;
                },
              ),

              SizedBox(height: 50,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(

                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                onPressed: () async {
                  if(noteFormKey.currentState!.validate())
                  {
                    noteFormKey.currentState!.save();



                    addNotes();



                  }

                },
                child:  Text(
                  "Save Notes",
                  style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold),

                ),
              ),

            ],
          ),

        ) ,
      ),
    );
  }
}