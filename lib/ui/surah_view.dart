// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah/surah.dart';

import 'ayat_view.dart';
import 'home_view.dart';

class SurahView extends StatelessWidget {
  SurahView({super.key});
  final conn = Get.put(SurahController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            Get.offAll(HomeView());
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(conn.title.value),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<List<SurahModel>>(
                        future: getSurah(),
                        builder: (context, snapshot) {
                          List<SurahModel>? dataSurah = snapshot.data;
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: dataSurah!.length,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  var dataa = dataSurah[i];
                                  return InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString('ayat', "");
                                      prefs.setString(
                                          'idSurah', "${dataa.number}");
                                      prefs.setString(
                                          'namaSurah', "${dataa.nameAR}");
                                      Get.offAll(AyatView());
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${dataa.nameAR}",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              Container(
                                                height: 40,
                                                width: 40,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: Center(
                                                  child: Text(
                                                    "${dataa.number}",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {}
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
