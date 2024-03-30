import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/api_view_image/student_model.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/api_view_image/student_model_image.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewImageFacePage extends StatefulWidget {
  const ViewImageFacePage({super.key});

  @override
  State<ViewImageFacePage> createState() => _ViewImageFacePageState();
}

class _ViewImageFacePageState extends State<ViewImageFacePage> {
  // late Future<StudentModel?> _fetchData;
  // List<StudentModelImage>? listImage = [];
  int currentIndex = 0;

  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getDataFormServer();
  }

  @override
  Widget build(BuildContext context) {
    print(' alo alo');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryButton,
        shadowColor: Colors.transparent,
        title: const CustomText(
            message: 'View Image',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              width: 14,
              height: 14,
              child: const Icon(Icons.arrow_back_ios_new_outlined,
                  color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: API(context).getImageFace(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        StudentModel? studentModel = snapshot.data;
                        return Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              CarouselSlider(
                                carouselController: carouselController,
                                items: studentModel!.studentImages!.map((e) {
                                  return Builder(
                                      builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: Image.network(e.imageURL!,
                                          width: 230,
                                          height: 200,
                                          fit: BoxFit.cover),
                                    );
                                  });
                                }).toList(),
                                options: CarouselOptions(
                                  aspectRatio: 14.2 / 10.3,
                                  viewportFraction: 0.55,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  // autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  // onPageChanged: (index, reason) {
                                  //   setState(() {
                                  //     currentIndex = index;
                                  //   });
                                  // },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              customBox(context, studentModel, 'Date expired: ',
                                  formatDate(studentModel.timeToLiveImages)),
                              const SizedBox(
                                height: 10,
                              ),
                              customBox(context, studentModel, 'Time expired; ',
                                  formatTime(studentModel.timeToLiveImages))
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Center(
                      child: Text('data is not available'),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Padding customBox(BuildContext context, StudentModel studentModel,
      String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 45,
                  offset: Offset(0, 5))
            ]),
        child: Center(
          child: CustomText(
              message: '$title: $content',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText),
        ),
      ),
    );
  }

  String formatDate(String? date) {
    if (date != null && date != '') {
      DateTime serverDateTime = DateTime.parse(date).toLocal();
      String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
      return formattedDate;
    }
    return '';
  }

  String formatTime(String? time) {
    if (time != null && time != '') {
      DateTime serverDateTime = DateTime.parse(time!).toLocal();
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
