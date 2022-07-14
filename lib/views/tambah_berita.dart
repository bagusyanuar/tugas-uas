import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helper/static_variable.dart';

class TambahBerita extends StatefulWidget {
  const TambahBerita({Key? key}) : super(key: key);
  @override
  _TambahBeritaState createState() => _TambahBeritaState();
}

class _TambahBeritaState extends State<TambahBerita> {
  String judul = '';
  String konten = '';
  PlatformFile? file;
  String _fileTugas = "Cari Gambar Cover....";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fikom UDB"),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        color: Colors.black12,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Form Tambah Berita",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5, top: 20),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text("Judul Berita"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    judul = text;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Judul Berita"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text("Konten Berita"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    konten = text;
                  });
                },
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Konten Berita"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text("Gambar Cover Berita"),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _fileTugas.toString(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cariFile();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Center(
                        child: Text("Cari Gambar"),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    tambahBerita();
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Sedang Mengupload Berita...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          )
                        : const Center(
                            child: Text(
                              "Tambah",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void tambahBerita() async {
    if (file != null) {
      setState(() {
        isLoading = true;
      });
      try {
        FormData form = FormData.fromMap({
          "judul": judul,
          "konten": konten,
          "gambar":
              await MultipartFile.fromFile(file!.path!, filename: file!.name)
        });
        String url = "$HostAddress/berita";
        final response = await Dio().post(
          url,
          data: form,
          options: Options(
            headers: {"Accept": "application/json"},
          ),
        );
        print(response.data);
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
    } else {
      Fluttertoast.showToast(
          msg: "Kamu Belum Memilih File..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void cariFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = result.files.first;
        _fileTugas = result.files.first.name;
      });
    } else {}
  }
}
