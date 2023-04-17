// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:alquran_android/ui/bookmark_view.dart';
import 'package:alquran_android/ui/surah_view.dart';
import 'package:ayat/ayat.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyatView extends StatefulWidget {
  const AyatView({super.key});

  @override
  State<AyatView> createState() => _AyatViewState();
}

class _AyatViewState extends State<AyatView> {
  final conn = Get.put(AyatController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            if (conn.ayatBookmark.value == "") {
              Get.offAll(SurahView());
            } else {
              Get.offAll(BookmarkView());
            }
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    conn.namaSurah.value,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            body: body(context),
          ),
        ));
  }

  Widget body(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
          child: Column(
            children: [
              FutureBuilder<List<AyatModel>>(
                  future: getAyat(conn.idSurah.value),
                  builder: (context, snapshot) {
                    List<AyatModel>? dataAyat = snapshot.data;
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, i) {
                            return Wrap(
                                textDirection: TextDirection.rtl,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                children:
                                    List.generate(dataAyat!.length, (index) {
                                  return InkWell(
                                    onTap: () {
                                      conn.tapAyat(index);
                                      setState(() {});
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: ElevatedButton(
                                                  onPressed: () async {
                                                    conn.listBookmark.add({
                                                      'ayat':
                                                          dataAyat[index].ayat,
                                                      'text':
                                                          dataAyat[index].teks,
                                                      'id_surah':
                                                          conn.idSurah.value,
                                                      'nama_surah':
                                                          conn.namaSurah.value
                                                    });
                                                    print(conn.listBookmark);
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    String strListBookmark =
                                                        jsonEncode(
                                                            conn.listBookmark);
                                                    prefs.setString(
                                                        "listBookmark",
                                                        strListBookmark);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                      "Tambah ke Bookmark")),
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (conn.ayatBookmark.value == "")
                                              ? (conn.indexAyat.value == "")
                                                  ? Colors.white
                                                  : int.parse(conn.indexAyat
                                                              .value) ==
                                                          index
                                                      ? Color(0xFFFFD54F)
                                                      : Colors.white
                                              : int.parse(conn.ayatBookmark
                                                              .value) -
                                                          1 ==
                                                      index
                                                  ? Colors.green[300]
                                                  : (conn.indexAyat.value == "")
                                                      ? Colors.white
                                                      : int.parse(conn.indexAyat
                                                                  .value) ==
                                                              index
                                                          ? Colors.amber[300]
                                                          : Colors.white),
                                      child: Text(
                                        dataAyat[index]
                                                .teks
                                                .toString()
                                                .replaceAll("\n", "") +
                                            "(${dataAyat[index].ayat.toString()})  ",
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  );
                                }));
                          });
                    } else if (snapshot.hasError) {}
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
