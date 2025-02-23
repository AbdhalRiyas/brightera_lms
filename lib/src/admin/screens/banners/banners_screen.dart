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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banners')),
      body: StreamBuilder<List<Appbanner>>(
        stream: _repository.getBannersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No banners available.'),
            );
          }

          final banners = snapshot.data!;

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (_, index) {
              final banner = banners[index];
              return Dismissible(
                key: Key(banner.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  final result = await _repository.deleteBanner(banner);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.data ?? result.error),
                      backgroundColor:
                          result.isSuccess ? Colors.green : Colors.red,
                    ),
                  );

                  return result.isSuccess;
                },
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                child: Container(
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
                          Text(banner.isHidden ? 'Hidden' : 'Visible'),
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
                ),
              );
            },
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
