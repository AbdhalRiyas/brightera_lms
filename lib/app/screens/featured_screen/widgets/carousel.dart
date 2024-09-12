import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/repositories/banner_respository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app/app/models/app_banner.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselSliderController _controller = CarouselSliderController();

  final BannerRespository _repository = BannerRespository();
  List<Appbanner> _banners = [];
  bool _isLoading = true;
  int _current = 0;

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

  void _onSliderChange(index, reason) {
    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : Column(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  onPageChanged: _onSliderChange,
                  enlargeCenterPage: true,
                ),
                itemCount: _banners.length,
                itemBuilder: (context, index, realIndex) => CachedNetworkImage(
                    width: double.maxFinite,
                    fit: BoxFit.fill,
                    imageUrl: _banners[index].imagePath),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _banners.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _current == entry.key ? 30.0 : 6.0,
                      height: 6.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge),
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : ThemeConstants.primaryButtonColor)
                              .withOpacity(_current == entry.key ? 0.9 : 0.6)),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
  }
}
