import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moor_demo/models/userData.dart';

class UserRepository {
  String baseUrl = "https://randomuser.me";

  UserRepository();

  static UserRepository getInstance() {
    return UserRepository();
  }

  Future<GetUserData> getUserData() async {
    var dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";

    dio.options.validateStatus = (status) => true;

    try {
      return await dio
          .get(
            "$baseUrl/api/?results=10",
          )
          .timeout(const Duration(seconds: 60))
          .then((value) async {
        print("$baseUrl/api/?results=10");
        print(value.statusCode);

        try {
          if (value.statusCode == 200) {
            print(value);
            // var map = json.decode(value.body);
            print(value.data);
            if (value.data["status"] == 0) {
              return GetUserData(data: null, info: value.data, results: []);
            } else if (value.data["status"] == 401) {
              return GetUserData(data: null, results: [], info: value.data);
            } else {
              GetUserData data = GetUserData.fromJson(value.data);
              return data;
            }
          } else {
            return GetUserData(data: value.data);
          }
        } catch (e) {
          return GetUserData(data: value.data);
        }
      });
    } on SocketException {
      return GetUserData(data: null);
    } on TimeoutException {
      return GetUserData(data: null);
    }
  }
}
