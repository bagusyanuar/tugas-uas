import 'package:flutter/material.dart';

class CardBerita extends StatelessWidget {
  final String gambarCover;
  final String judul;
  final String konten;

  const CardBerita({
    Key? key,
    this.gambarCover = '',
    this.judul = '',
    this.konten = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(gambarCover),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            judul,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
