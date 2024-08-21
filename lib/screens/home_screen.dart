import 'package:firabasetut/controller/db_handler_controller.dart';
import 'package:firabasetut/model/user_task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.user, {
    super.key,
  });
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbController = Get.put(DbHandlerController());
  final TextEditingController _taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbController.fetchAllTask(widget.user.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          leading: const SizedBox.shrink(),
          title: const Text("TaskMaster"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showDialog();
          },
          label: const Text("Add Task"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream:
                    dbController.getStreamDatabaseOfUser(widget.user.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    final userTaskData = getUserTaskModelFromMap(
                        snapshot.data!.data()?["UserTask"]);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: userTaskData.length,
                        itemBuilder: (context, index) => ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  dbController
                                      .deleteTask(userTaskData[index], index,
                                          widget.user.email.toString())
                                      .then((_) async {
                                    await dbController.fetchAllTask(
                                        widget.user.email.toString());
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              title: Text(userTaskData[index].taskName),
                            ));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      final ourData = UserTaskModel(
                          taskName: "Flutter Realtime Task",
                          isCompleted: false);
                      dbController.operationCRUDInRealtimeDatabase(
                          widget.user.email.toString(), CRUDMethod.write,
                          value: ourData);
                    },
                    child: const Text("Add"),
                  ),
                  FloatingActionButton(
                    onPressed: () async{
                      await dbController.operationCRUDInRealtimeDatabase(
                          widget.user.email.toString(), CRUDMethod.delete);
                    },
                    child: const Text("Delete"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      dbController.operationCRUDInRealtimeDatabase(
                          widget.user.email.toString(), CRUDMethod.read);
                    },
                    child: const Text("Read"),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: const Text("Update"),
                  )
                ],
              ),
            ),
            Obx(
              ()=> Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 140,
                color: dbController.fetchedData.value.isEmpty
                    ? Colors.red
                    : Colors.green,
                child: Text(
                  dbController.fetchedData.value.isEmpty
                      ? "No Data"
                      : dbController.fetchedData.value,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }

  _showDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(label: Text("Task Name")),
                  ),
                  TextButton(
                      onPressed: () {
                        dbController
                            .addTask(
                                widget.user.email.toString(),
                                UserTaskModel(
                                    taskName: _taskNameController.text,
                                    isCompleted: false))
                            .then((_) async {
                          await dbController
                              .fetchAllTask(widget.user.email.toString());
                          _taskNameController.clear();
                        });

                        Navigator.pop(context);
                      },
                      child: const Text("Add Task"))
                ],
              ),
            ));
  }
}

//stream ----flow of data
