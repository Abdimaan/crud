import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();
  //text contoller
  final TextEditingController textcontroller = TextEditingController();
  //open a dailog box to add note
  void opennotes({String? docID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: textcontroller,
          ),
          actions: [
            //button to save
            ElevatedButton(
              onPressed: () {
                if (docID == null) {
                  firestoreService.addNote(textcontroller.text);
                }
                //upate exit one
                else {
                  firestoreService.updateNotes(docID, textcontroller.text);
                }
                //clear after adding
                textcontroller.clear();

                //close the box
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO LIST'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: opennotes,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          //if we have data get all data
          if (snapshot.hasData) {
            List noteslist = snapshot.data!.docs;
            //display as list view
            return ListView.builder(
              itemCount: noteslist.length,
              itemBuilder: (context, index) {
                //get indivual doc
                DocumentSnapshot document = noteslist[index];
                String docId = document.id;
                //get notes from each docs
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String NoteText = data['note'];

                //display as list title
                return ListTile(
                    title: Text(NoteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //update
                        IconButton(
                            onPressed: () => opennotes(docID: docId),
                            icon: const Icon(Icons.edit)),
                        // delete one
                        IconButton(
                            onPressed: () =>
                                firestoreService.deleteNotes(docID: docId),
                            icon: const Icon(Icons.delete)),
                      ],
                    ));
              },
            );
          }
          //if there is no note return no notes
          else {
            return Text('no notes...');
          }
        },
      ),
    );
  }
}
