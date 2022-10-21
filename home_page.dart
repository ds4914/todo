import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController titleController1 = TextEditingController();
  final TextEditingController descriptionController1 = TextEditingController();

  final CollectionReference _todolist =
      FirebaseFirestore.instance.collection('todolist');
  final db = FirebaseFirestore.instance;

  void clear() {
    titleController.text = "";
    descriptionController.text = "";
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'title',
                    hintText: 'title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'description',
                    labelText: 'description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple;
                      return Colors.blue;
                    })),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(auth.currentUser?.uid)
                          .collection('todolist')
                          .add({
                        'title': titleController.text,
                        'description': descriptionController.text,
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Create')),
              ],
            ),
          );
        });
  }

  // Future<void> _delete(String notesId) async {
  //   await _todolist.doc(notesId).delete();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //      SnackBar(content: Text("You have successfully deleted a note")));
  // }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      titleController1.text = documentSnapshot['title'];
      descriptionController1.text = documentSnapshot['description'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController1,
                  decoration: const InputDecoration(labelText: 'title'),
                ),
                TextField(
                  controller: descriptionController1,
                  decoration: const InputDecoration(
                    labelText: 'description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      // final String title = _titleController.text;
                      // final String description = _descriptionController.text;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('todolist')
                          .doc(documentSnapshot!.id)
                          .update({
                        "title": titleController1.text,
                        "description": descriptionController1.text,
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Update')),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('todolist')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['title']),
                      subtitle: Text(documentSnapshot['description']),
                      trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: (() => _update(documentSnapshot)),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('todolist')
                                        .doc(
                                            streamSnapshot.data!.docs[index].id)
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          )),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (() {
            setState(() {
              clear();
              _create();
            });
            
          })),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 25.0),
                  child: Text(
                    "ToDo List App",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [BoxShadow(blurRadius: 50.0)],
                )),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
