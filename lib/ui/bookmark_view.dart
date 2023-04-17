// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:bookmark/bookmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ayat_view.dart';
import 'home_view.dart';

class BookmarkView extends StatelessWidget {
  BookmarkView({super.key});
  final conn = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          Get.offAll(HomeView());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(conn.title.value),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...conn.listBookmark.map((e) => InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("idSurah", "${e['id_surah']}");
                          prefs.setString("namaSurah", "${e['nama_surah']}");
                          prefs.setString("ayat", "${e['ayat']}");
                          Get.offAll(AyatView());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 2)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Surah :  ${e['nama_surah']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "Ayat : ${e['ayat']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${e['text']}",
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
