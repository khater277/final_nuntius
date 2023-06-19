import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:final_nuntius/core/utils/app_images.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  const CustomNetworkImage(
      {super.key, required this.imageUrl, required this.fit});

  Future<bool> checkInternet() async {
    bool? result;
    InternetConnectionChecker().hasConnection.then((value) => result = value);
    return result!;
    // return await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      image: imageUrl,
      placeholder: AppImages.loading,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(AppImages.error);
      },
      placeholderFit: BoxFit.contain,
      fit: fit,
    );
  }
}
