import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool internetErrorShown;

  CachedImage({required this.imageUrl, required this.internetErrorShown});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(); // Indicador de progreso lineal
        } else if (snapshot.hasError) {
          if (snapshot.data == null && !internetErrorShown) {
            return _buildErrorWidget();
          } else {
            return _buildErrorWidget(); // Devolver un contenedor vacío
          }
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.file(snapshot.data!);
        } else {
          return _buildErrorWidget(); // Devolver un contenedor vacío
        }
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
          "This image is not available because you don't have an internet connection and it's not cached for now",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<File?> _getImage() async {
    try {
      if (await _needsToUpdateCache()) {
        await DefaultCacheManager().removeFile(imageUrl);
      }

      File? cachedFile = await _getCachedImage();
      if (cachedFile != null) {
        return cachedFile;
      } else {
        File? downloadedFile = await DefaultCacheManager().getSingleFile(
          imageUrl,
        );
        return downloadedFile;
      }
    } catch (e) {
      print('Error al obtener la imagen: $e');
      return null;
    }
  }

  Future<bool> _needsToUpdateCache() async {
    try {
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
      if (fileInfo != null && fileInfo.validTill != null) {
        DateTime validTill = fileInfo.validTill!;
        return DateTime.now().isAfter(validTill);
      }
      return false;
    } catch (e) {
      print('Error al obtener la información de la caché: $e');
      return false;
    }
  }

  Future<File?> _getCachedImage() async {
    try {
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
      if (fileInfo != null && fileInfo.validTill != null) {
        DateTime validTill = fileInfo.validTill!;
        if (DateTime.now().isBefore(validTill)) {
          return fileInfo.file;
        } else {
          await DefaultCacheManager().removeFile(imageUrl);
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener la imagen de la caché: $e');
      return null;
    }
  }
}
