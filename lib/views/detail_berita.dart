import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tugas_uas/helper/static_variable.dart';

class DetailBerita extends StatefulWidget {
  const DetailBerita({Key? key}) : super(key: key);
  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool isLoading = true;
  Map<String, dynamic> _berita = {};

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var id = ModalRoute.of(context)!.settings.arguments as String;
      log(id);
      _getBerita(id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fikom UDB"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black12,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: const CircularProgressIndicator(),
                  ),
                  const Text("Sedang mengunduh data berita..."),
                ],
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          "Detail Berita",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(HostAddress +
                                _berita['gambar_cover'].toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _berita['judul'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _berita['konten'].toString(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _getBerita(String id) async {
    log("fetch");
    try {
      String url = '$HostAddress/berita/$id';
      final response = await Dio().get(
        url,
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );

      setState(() {
        isLoading = false;
        _berita = response.data['data'] as Map<String, dynamic>;
      });
      log(response.data.toString());
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
