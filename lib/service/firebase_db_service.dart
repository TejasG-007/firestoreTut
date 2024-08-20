import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firabasetut/model/user_task_model.dart';

class FirebaseDbService {
  final database = FirebaseFirestore.instance;

  static const userCollection = "users";

  Future<bool> createDatabaseForUser(String userName) async {
    await database.collection(userCollection).doc(userName).set({});
    return true;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDatabaseStream(
      String username) {
    return database.collection(userCollection).doc(username).snapshots();
  }

  getDataFromDatabase(String userName) async {
    try {
      final data =
          await database.collection(userCollection).doc(userName).get();
      if (data.data() != null) {
        return getUserTaskModelFromMap(data.data()!["UserTask"]);
      }
    } catch (e) {
      log("Not found any data $e");
      return false;
    }
  }

  Future<bool> addTaskToDatabase(String userName, UserTaskModel model,
      {fromDelete = false, List<UserTaskModel>? deletedData}) async {
    try {
      if (!fromDelete) {
        List<UserTaskModel> data = await getDataFromDatabase(userName);
        data.add(model);
        await database
            .collection(userCollection)
            .doc(userName)
            .set({"UserTask": getMapDataFromUserTaskModel(data)});
      } else {
        deletedData != null
            ? await database
                .collection(userCollection)
                .doc(userName)
                .set({"UserTask": getMapDataFromUserTaskModel(deletedData)})
            : null;
      }
      return true;
    } catch (e) {
      log("Hey! There is an Error while adding the data | $e");
      return false;
    }
  }

  deleteDataFromDB(UserTaskModel value, int index, String userName) async {
    try {
      List<UserTaskModel> data = await getDataFromDatabase(userName);
      data.removeAt(index);
      await addTaskToDatabase(userName,
          UserTaskModel(taskName: "From Delete Method", isCompleted: false),
          fromDelete: true, deletedData: data);
    } catch (e) {
      log("Unable to delete $e");
    }
  }
}
