import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewImageDialog extends StatelessWidget {
  String image;

  ViewImageDialog({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: Container(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        value: progress.progress,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  imageUrl: image,
                ),
              ),
            ],
          ),
        ),
      );
}
