import 'package:flutter/material.dart';
import 'package:moor_demo/data/moor_database.dart';
import 'package:moor_demo/repositories/userRepository.dart';
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

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchUserData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  fetchUserData() {
    UserRepository.getInstance().getUserData().then((value) async {
      if (value.results != null) {
        setState(() {
          userData = (value.results);
          print("userData=");
          print(userData);
        });

        await AppDatabase().getAllOrder().then((value) {
          dynamic oldOrders = value;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Employees Data"),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: AppDatabase().watchAllOrder(),
          builder: (context, AsyncSnapshot<List<Order>> snapshot) {
            return ListView.builder(
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
                        subtitle: Text(snapshot.data[index].email),
                      ),
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          },
        ),
      ),
    );
  }
}
