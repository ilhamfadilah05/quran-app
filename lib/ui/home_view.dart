// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:alquran_android/ui/bookmark_view.dart';
import 'package:alquran_android/ui/surah_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Aplikasi Al-Qur'an Android",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.offAll(SurahView());
                },
                child: Text("Al-Qur'an")),
            ElevatedButton(
                onPressed: () {
                  Get.offAll(BookmarkView());
                },
                child: Text("Bookmark"))
          ],
        ),
      ),
    );
  }
}
