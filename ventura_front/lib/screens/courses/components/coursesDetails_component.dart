import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ventura_front/services/models/course_model.dart';

class CourseDetails extends StatefulWidget {
  final Course course;
  final String bannerUrl;
  final String bloqueNeonUrl;
  final String pdfUrl;

  const CourseDetails({
    Key? key,
    required this.course,
    required this.bannerUrl,
    required this.bloqueNeonUrl,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool _isConnected = false;
  bool _isBannerCached = false;
  bool _isBloqueNeonCached = false;
  bool _isPdfDownloaded = false;
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkConnectivity();
    _checkCachedContent();
    _checkPdfDownloaded();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  Future<void> _checkCachedContent() async {
    try {
      // Verificar si el banner está en caché
      final bannerInfo = await DefaultCacheManager().getFileFromCache(widget.bannerUrl);
      setState(() {
        _isBannerCached = bannerInfo != null && bannerInfo.file != null && bannerInfo.file!.existsSync();
      });

      // Verificar si el bloque neon está en caché
      final bloqueNeonInfo = await DefaultCacheManager().getFileFromCache(widget.bloqueNeonUrl);
      setState(() {
        _isBloqueNeonCached = bloqueNeonInfo != null && bloqueNeonInfo.file != null && bloqueNeonInfo.file!.existsSync();
      });
    } catch (e) {
      print('Error checking cached content: $e');
    }
  }

  Future<void> _checkPdfDownloaded() async {
    try {
      // Verificar si el PDF ya está en caché
      final fileInfo = await DefaultCacheManager().getFileFromCache(widget.pdfUrl);

      if (fileInfo != null && fileInfo.file != null && fileInfo.file!.existsSync()) {
        // Si el PDF está en caché, verificar si ha pasado un día desde su descarga
        final lastModified = fileInfo.validTill;
        final now = DateTime.now();
        final difference = now.difference(lastModified);
        if (difference.inDays >= 1) {
          // Si ha pasado un día, eliminar el PDF del caché
          fileInfo.file!.delete();
          setState(() {
            _isPdfDownloaded = false;
          });
        } else {
          // Si no ha pasado un día, marcar el PDF como descargado
          setState(() {
            _isPdfDownloaded = true;
          });
        }
      } else {
        // Si el PDF no está en caché, marcarlo como no descargado
        setState(() {
          _isPdfDownloaded = false;
        });
      }
    } catch (e) {
      print('Error checking PDF cache: $e');
    }
  }

  Future<void> _downloadPdf() async {
    try {
      await DefaultCacheManager().downloadFile(widget.pdfUrl);
      setState(() {
        _isPdfDownloaded = true;
      });
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professor: ${widget.course.professor}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Room: ${widget.course.room}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Schedule: ${widget.course.schedule}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isBannerCached ? Colors.blue : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 20), // Ajusta el padding vertical del botón
                    ),
                    onPressed: _isConnected ? () => _launchURL(widget.bannerUrl) : null,
                    child: Text('MiBanner'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isBloqueNeonCached ? Colors.blue : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 20), // Ajusta el padding vertical del botón
                    ),
                    onPressed: _isConnected ? () => _launchURL(widget.bloqueNeonUrl) : null,
                    child: Text('Bloque Neón'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox( // Envuelve el botón para establecer su tamaño horizontal
              width: double.infinity, // Ocupa todo el ancho disponible
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isPdfDownloaded ? Colors.blue : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 20), // Ajusta el padding vertical del botón
                ),
                onPressed: _isPdfDownloaded ? () => _launchURL(widget.pdfUrl) : _isConnected ? _downloadPdf : null,
                child: Text(_isPdfDownloaded ? 'Watch the Uniandes PDF' : 'Download the Uniandes PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
