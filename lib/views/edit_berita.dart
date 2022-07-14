import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tugas_uas/helper/static_variable.dart';

class EditBerita extends StatefulWidget {
  const EditBerita({Key? key}) : super(key: key);
  @override
  _EditBeritaState createState() => _EditBeritaState();
}

class _EditBeritaState extends State<EditBerita> {
  String _beritaId = '';
  String judul = '';
  String konten = '';
  PlatformFile? file;
  String _fileTugas = "Cari Gambar Cover....";
  bool isLoading = true;
  Map<String, dynamic> _berita = {};
  TextEditingController _textJudulController = new TextEditingController();
  TextEditingController _textKontentController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var id = ModalRoute.of(context)!.settings.arguments as String;
      _getBerita(id);
    });
    super.initState();
  }

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
            : Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Form Edit Berita",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      controller: _textJudulController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
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
                      controller: _textKontentController,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
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
                                    "Edit",
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
    setState(() {
      isLoading = true;
    });
    try {
      FormData form = FormData.fromMap({
        "judul": _textJudulController.text,
        "konten": _textKontentController.text,
        "gambar": file != null
            ? await MultipartFile.fromFile(file!.path!, filename: file!.name)
            : ''
      });
      String url = "$HostAddress/berita/$_beritaId";
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

  void _getBerita(String id) async {
    try {
      String url = '$HostAddress/berita/$id';
      final response = await Dio().get(
        url,
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );
      setState(() {
        _beritaId = id;
        isLoading = false;
        _berita = response.data['data'] as Map<String, dynamic>;
      });

      _textJudulController.text = _berita['judul'].toString();
      _textKontentController.text = _berita['konten'].toString();
      log(response.data.toString());
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
