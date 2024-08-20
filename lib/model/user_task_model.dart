import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UserTaskModel {
  final String taskName;
  final bool isCompleted;

  UserTaskModel({required this.taskName, required this.isCompleted});

  factory UserTaskModel.fromMap(Map<String, dynamic> map) =>
      UserTaskModel(taskName: map["taskName"], isCompleted: map["isCompleted"]);


  Map<String,dynamic> toMap()=>{
    "taskName":taskName,
    "isCompleted":isCompleted
  };
}

List<Map<String,dynamic>> getMapDataFromUserTaskModel(List<UserTaskModel> data)=>data.map((ele)=>ele.toMap()).toList();

List<UserTaskModel> getUserTaskModelFromString(String data) =>
    jsonDecode(data).map((x) => UserTaskModel.fromMap(x)).toList();

List<UserTaskModel> getUserTaskModelFromMap(List<dynamic> data)=>data.map((ele)=>UserTaskModel.fromMap(ele)).toList();

// }List<UserTaskModel> getUserTaskModelFromMap(List<dynamic> map){
//   final List<UserTaskModel> listModel= [];
//   for(var data in map){
//     listModel.add(UserTaskModel.fromMap(data));
//   }
//   return listModel;
// }

