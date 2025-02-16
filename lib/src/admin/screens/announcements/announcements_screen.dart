import 'package:app/src/admin/screens/announcements/add_edit_anouncements_screen.dart';
import 'package:app/src/repositories/announcement_repository.dart';
import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementRepository _announcementRepository =
      AnnouncementRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: StreamBuilder(
        stream: _announcementRepository.announcementsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Announcements'),
            );
          }
          final announcements = snapshot.data;
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(announcements[index].imageUrl!),
                title: Text(announcements[index].title),
                subtitle: Text(announcements[index].shortDescription),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddEditAnouncementsScreen(
                        announcement: announcements[index],
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: announcements!.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditAnouncementsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
