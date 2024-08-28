import 'package:app/app/config/them_constants.dart';
import 'package:app/app/screens/featured_screen/widgets/carousel.dart';
import 'package:app/app/screens/featured_screen/widgets/list_of_subjects.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Image.asset(
            'assets/images/logo.webp',
            height: ThemConstants.imageSizeSmall,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Carousel(),
                Padding(
                  padding: const EdgeInsets.all(ThemConstants.paddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Browse Arzam Physics",
                        style: GoogleFonts.ptSans(
                          fontSize: ThemConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const ListOfSubjects(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
