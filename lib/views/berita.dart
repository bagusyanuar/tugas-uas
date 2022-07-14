import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tugas_uas/components/card_berita.dart';
import 'package:tugas_uas/helper/static_variable.dart';

class Berita extends StatefulWidget {
  const Berita({Key? key}) : super(key: key);
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  List<dynamic> _listBerita = [];
  bool isLoading = false;
  bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    _getListBerita();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fikom UDB"),
        backgroundColor: Colors.green[800],
      ),
      floatingActionButton: isLoading
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/tambah-berita");
              },
              tooltip: 'Tambah',
              child: const Icon(Icons.add),
            ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black12,
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
            : RefreshIndicator(
                onRefresh: () {
                  return refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      Column(
                        children: _listBerita
                            .map((item) => CardBerita(
                                  editable: true,
                                  id: item['id'].toString(),
                                  judul: item['judul'].toString(),
                                  gambarCover:
                                      HostAddress + item['gambar_cover'],
                                  onEdit: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-berita',
                                      arguments: item['id'].toString(),
                                    );
                                  },
                                  onHapus: () {
                                    hapusBerita(item['id'].toString());
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  refresh() async {
    _getListBerita();
  }

  void hapusBerita(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = "$HostAddress/berita/$id/hapus";
      final response = await Dio().post(
        url,
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );
      print(response.data);
      refresh();
      Navigator.pop(context);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Terjadi Kesalahan Pada Server...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _getListBerita() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = '$HostAddress/berita';
      final response = await Dio().get(
        url,
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );
      setState(() {
        _listBerita = response.data['data'] as List;
      });
    } on DioError catch (e) {
      print(e.message);
    }
    setState(() {
      isLoading = false;
    });
  }
}
