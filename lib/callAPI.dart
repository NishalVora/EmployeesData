import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:moor_demo/data/moor_database.dart';
import 'package:moor_demo/repositories/userRepository.dart';
import 'package:moor_demo/utils/shared_pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/userData.dart';
import 'dart:async';

class callAPI extends StatefulWidget {
  @override
  State<callAPI> createState() => _callAPIState();
}

class _callAPIState extends State<callAPI> {
  List<Result> userData = [];

  bool isFirst = true;
  bool isLoading = true;
  List oldOrders = [];
  bool isOldDataEmpty =
      SharedPrefHelper.instance.getBool(SharedPrefHelper.IS_OLD_DATA_EMPTY);

  Timer timer;
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchUserData());
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    // timer?.cancel();
    super.dispose();
  }

  fetchUserData() async {
    await UserRepository.getInstance().getUserData().then((value) async {
      if (value.results != null) {
        setState(() {
          userData = (value.results);
          print("userData=");
          print(userData);
          SharedPrefHelper.instance
              .putBool(SharedPrefHelper.IS_OLD_DATA_EMPTY, false);
        });

        await AppDatabase().getAllOrder().then((value) {
          oldOrders = value;
          for (var oldOrder in oldOrders) {
            print("oldOrder=");
            print(oldOrder);
            AppDatabase().deleteOrder(oldOrder);
          }
        });

        userData.every((element) {
          AppDatabase().insertNewOrder(Order(
            name: element.name.first,
            email: element.email,
          ));

          return true;
        });

        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // }
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Mobile: Online';
        break;
      case ConnectivityResult.wifi:
        string = 'WiFi: Online';
        break;
      case ConnectivityResult.none:
      default:
        string = 'Offline';
        isFirst = true;
    }

    if (isFirst && (string == "Mobile: Online" || string == "WiFi: Online")) {
      isFirst = false;
      fetchUserData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Simform Employees"),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: SafeArea(
        child: oldOrders.isEmpty &&
                string == "Offline" &&
                isFirst &&
                SharedPrefHelper.instance
                    .getBool(SharedPrefHelper.IS_OLD_DATA_EMPTY)
            ? Center(
                child: Text("No records found!"),
              )
            : StreamBuilder(
                stream: AppDatabase().watchAllOrder(),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting &&
                          isFirst
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : snapshot.hasData
                          ? ListView.builder(
                              itemBuilder: (_, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.lightGreen.shade200,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: CircleAvatar(
                                          child: Text('${index + 1}'),
                                          radius: 20,
                                          backgroundColor: Colors.pink,
                                        ),
                                        title: Text(snapshot.data[index].name),
                                        subtitle:
                                            Text(snapshot.data[index].email),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: snapshot.data?.length,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                },
              ),
      ),
    );
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();

  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();

  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
