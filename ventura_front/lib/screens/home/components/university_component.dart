import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/components/imageSlider_component.dart';


class University extends StatelessWidget {
  const University({super.key});

     @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(60),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageSlider(
                imageUrls: [
                  'https://uniandes.edu.co/sites/default/files/campus_ng.jpg',
                  'https://cloudfront-us-east-1.images.arcpublishing.com/semana/PXIOHD56UFFY5JRQEAM3HQRNMI.jpg',
                  'https://uniandes.edu.co/sites/default/files/u5940/centro_deportivo.jpg',
                  'https://cienciassociales.uniandes.edu.co/lenguas-cultura/wp-content/uploads/sites/19/elementor/thumbs/nota-andes-top2020-q380cn1mg7hofcukyj6s1s5a6bzu1epgi1l37ior60.jpg',
                  'https://static1.educaedu-colombia.com/adjuntos/12/00/38/universidad-de-los-andes---pregrado-003891_large.jpg',
                  'https://uniandes.edu.co/sites/default/files/voces-academia-sociedad-n.jpg',
                  'https://centrodeljapon.uniandes.edu.co/sites/default/files/Centro_japon/edificio-cj/Edificio1.jpg',
                  'https://arqdis.b-cdn.net/wp-content/uploads/2021/02/biblioteca-galeria-11.jpg',
                  'https://serenadelmar.com.co/wp-content/uploads/2019/08/PRENSA02.jpg',
                  'https://uniandes.edu.co/sites/default/files/campus-centro-deportivo-7.jpg',
                ],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF891C),
                Color(0xFFFAFF00),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50),
            child: Text(
              "Universidad de los Andes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


