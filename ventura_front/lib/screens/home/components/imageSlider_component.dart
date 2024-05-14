import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/components/cachedImage_component.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  ImageSlider({required this.imageUrls});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  bool internetErrorShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get to know the university!')),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshImages,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: widget.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CachedImage(
                        imageUrl: widget.imageUrls[index],
                        internetErrorShown: internetErrorShown,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshImages() async {
    setState(() {
      internetErrorShown = true;
    });
  }
}
