import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});
  final CollectionReference _students =
      FirebaseFirestore.instance.collection('student list');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _fatherController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final addNameController = TextEditingController();
  final addAgeController = TextEditingController();
  final addFatherController = TextEditingController();

  final addPhoneController = TextEditingController();

  Future<void> _create() async {
    await _students.add({
      'name': addNameController.text,
      'age': addAgeController.text,
      "father's_name": addFatherController.text,
      'phone': addPhoneController.text,
    });
  }

  Future<void> _editSomething([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _ageController.text = documentSnapshot['age'].toString();
      _fatherController.text = documentSnapshot["father's_name"];

      _phoneController.text = documentSnapshot['phone'].toString();
    }
  }

  Future<void> _delete(String id) async {
    await _students.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                  child: Text(
                'STUDENT  RECORD',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: addNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: addAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Age'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: addFatherController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Father's Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: addPhoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Phone Number"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    _create();
                    addNameController.text = '';
                    addAgeController.text = '';
                    addFatherController.text = '';

                    addPhoneController.text = '';
                  },
                  child: const Text('Add')),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: _students.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Slidable(
                                key: Key(documentSnapshot.id),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (ctx) {
                                        _delete(documentSnapshot.id);
                                      },
                                      icon: Icons.delete,
                                      foregroundColor: Colors.red,
                                      label: 'Delete',
                                      backgroundColor: Colors.white,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 4,
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Name: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              documentSnapshot['name'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Age:  ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              documentSnapshot['age']
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text(
                                              "Father's Name:  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              documentSnapshot["father's_name"],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Phone Number:  ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              documentSnapshot['phone']
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _editSomething(documentSnapshot);
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Column(children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Name'),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _ageController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText: 'age'),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _fatherController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  "Father's Name"),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _phoneController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Phone Number'),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          final String name =
                                                              _nameController
                                                                  .text;
                                                          final num? age =
                                                              num.tryParse(
                                                                  _ageController
                                                                      .text);
                                                          final String
                                                              fatherName =
                                                              _fatherController
                                                                  .text;

                                                          final num? phone =
                                                              num.tryParse(
                                                                  _phoneController
                                                                      .text);
                                                          if (phone != null ||
                                                              name != null ||
                                                              age != null ||
                                                              fatherName !=
                                                                  null) {
                                                            await _students
                                                                .doc(
                                                                    documentSnapshot
                                                                        .id)
                                                                .update({
                                                              'name': name,
                                                              'age': age,
                                                              "father's_name":
                                                                  fatherName,
                                                              'phone': phone
                                                            });

                                                            _nameController
                                                                .text = '';
                                                            _ageController
                                                                .text = '';
                                                            _fatherController
                                                                .text = '';

                                                            _phoneController
                                                                .text = '';
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Update')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Back'))
                                                  ]),
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.edit)),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
