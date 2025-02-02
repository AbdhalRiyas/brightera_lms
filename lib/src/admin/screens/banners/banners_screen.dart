import 'package:app/src/admin/screens/banners/banner_add_edit_screen.dart';
import 'package:app/src/models/app_banner.dart';
import 'package:app/src/repositories/banner_respository.dart';
import 'package:flutter/material.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final BannerRespository _repository = BannerRespository();
  List<Appbanner> _banners = [];

  Future<void> _fetchBanners() async {
    final banners = await _repository.getAllBanners();
    setState(() {
      _banners = banners;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners'),
      ),
      body: ListView.builder(
        itemCount: _banners.length,
        itemBuilder: (_, index) {
          final banner = _banners[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  banner.imagePath,
                  width: 200,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order: ${banner.order}'),
                    Text('Link: ${banner.link}'),
                    Text('Hidden: ${banner.isHidden}'),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BannerAddEditScreen(
                          appbanner: banner,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BannerAddEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
