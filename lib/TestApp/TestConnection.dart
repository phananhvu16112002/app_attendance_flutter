import 'package:attendance_system_nodejs/models/Class.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestConnection extends StatefulWidget {
  const TestConnection({super.key});

  @override
  State<TestConnection> createState() => _TestConnectionState();
}

class _TestConnectionState extends State<TestConnection> {
  late Box<Classes> box;
  List<Classes> listTemp = Classes.listTest();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    box = await Hive.openBox<Classes>('class');
  }

  void saveListClass(List<Classes> classes) async {
    if (box.isOpen) {
      for (var temp in classes) {
        await box.put(temp.classID, temp);
      }
    } else {
      print('Box is not opened yet!');
    }
  }

  Future<List<Classes>> getClasses() async {
    listTemp = box.values.toList();
    return listTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test Connection'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            color: Colors.black,
            child: StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  print(snapshot.toString());
                  if (snapshot.hasData) {
                    ConnectivityResult? result = snapshot.data;
                    if (result == ConnectivityResult.wifi ||
                        result == ConnectivityResult.mobile) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Have internet',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  saveListClass(listTemp);
                                  print('Tapped');
                                  // box.close();
                                },
                                child: Text('Write Data')),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  for (var i in box.values) {
                                    print(i.course.courseID);
                                  }
                                  print('Tapped');
                                  // box.close();
                                },
                                child: Text('Read Data'))
                          ],
                        ),
                      );
                    } else if (result == ConnectivityResult.none) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'No internet',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  List<Classes> listTemp = await getClasses();
                                  for (var c in listTemp) {
                                    print(c.teacher.teacherEmail);
                                  }
                                  print('Tapped');
                                },
                                child: const Text('Read Data'))
                          ],
                        ),
                      );
                    } else if (result == ConnectivityResult.other) {
                      return Text(
                        'alo alo',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return Center(
                          child: Text(
                        'Others',
                        style: TextStyle(color: Colors.white),
                      ));
                    }
                  }
                  return Text('Null');
                }),
          ),
        ));
  }
}
