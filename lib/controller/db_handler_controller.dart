import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firabasetut/model/user_task_model.dart';
import 'package:firabasetut/service/firebase_db_service.dart';
import 'package:get/get.dart';

class DbHandlerController extends GetxController {


  Rx<List<UserTaskModel>> data = Rx<List<UserTaskModel>>([]);

  final FirebaseDbService _firebaseDbService = FirebaseDbService();

  Future<bool> addTask(String userName, UserTaskModel model) async {
    return _firebaseDbService.addTaskToDatabase(userName, model);
  }

  Future<void> fetchAllTask(String userName) async {
    data.value = await _firebaseDbService.getDataFromDatabase(userName);
  }

  Future<void> deleteTask(UserTaskModel value,int index,String userName) async{
    await _firebaseDbService.deleteDataFromDB(value,index,userName);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>  getStreamDatabaseOfUser(String userName){
    return _firebaseDbService.getUserDatabaseStream(userName);
  }
}
