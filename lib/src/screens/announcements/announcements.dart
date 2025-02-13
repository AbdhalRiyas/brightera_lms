import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/announcement.dart';
import 'package:app/src/repositories/announcement_repository.dart';
import 'package:app/src/widgets/app_bar_back_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    final AnnouncementRepository announcementRepository =
        AnnouncementRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        leading: const AppBarBackButton(),
      ),
      body: FutureBuilder(
        future: announcementRepository.getAllAnnouncements(),
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
              return NotificationCard(
                announcement: announcements[index],
              );
            },
            itemCount: announcements!.length,
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeConstants.primaryShadowColor,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                margin: const EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  colorFilter: const ColorFilter.mode(
                    ThemeConstants.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      announcement.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd     kk:mm')
                        .format(announcement.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusLarge),
              color: Colors.white,
            ),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              imageUrl: announcement.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
