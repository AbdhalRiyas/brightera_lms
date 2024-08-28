import 'package:app/app/config/them_constants.dart';
import 'package:app/app/repositories/banner_respository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app/app/models/app_banner.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final BannerRespository _repository = BannerRespository();
  List<Appbanner> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    _fetchBanners();
    super.initState();
  }

  Future<void> _fetchBanners() async {
    _banners = await _repository.getAllActiveBanners();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator.adaptive()
        : CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
            ),
            itemCount: _banners.length,
            itemBuilder: (context, index, realIndex) => ClipRRect(
              borderRadius:
                  BorderRadius.circular(ThemConstants.borderRadiusMedium),
              child: Image.network(_banners[index].imagePath),
            ),
          );
  }
}
