import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/services/GetLocation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:shimmer/shimmer.dart';

class TestLoading extends StatefulWidget {
  const TestLoading({super.key});

  @override
  State<TestLoading> createState() => _MapState();
}

class _MapState extends State<TestLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: customLoading()));
  }

  Widget customLoading() {
    return Container(
      width: 405,
      height: 220,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(195, 190, 188, 188),
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child: Container(width: 300, height: 10, color: Colors.white)),
            const SizedBox(
              height: 2,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 50,
                                    height: 10,
                                    color: Colors.white)),
                            const SizedBox(
                              width: 2,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 150,
                                    height: 10,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 40,
                                    height: 10,
                                    color: Colors.white)),
                            const SizedBox(
                              width: 2,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 175,
                                    height: 10,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 50,
                                    height: 10,
                                    color: Colors.white)),
                            const SizedBox(
                              width: 2,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 170,
                                    height: 10,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Shimmer.fromColors(
                    baseColor: const Color.fromARGB(78, 158, 158, 158),
                    highlightColor: const Color.fromARGB(146, 255, 255, 255),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              width: 405,
              color: const Color.fromARGB(105, 190, 188, 188),
            ),
            const SizedBox(
              height: 20,
            ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child: Container(width: 100, height: 10, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
