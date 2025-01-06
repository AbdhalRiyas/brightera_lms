import 'package:app/src/models/user.dart' show UserRole;
import 'package:app/src/screens/account/profile_card.dart';
import 'package:app/src/services/auth_manager.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../orders/orders_screen.dart';
import 'profile_menu_list_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.isInstructorView = false});

  final bool isInstructorView;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService().authStateChanges, // Assuming this stream exists
      builder: (context, snapshot) {
        final currentUser = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Account"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (currentUser != null)
                  FutureBuilder(
                    future: AuthManager().getUserDetails(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProfileCard(
                              name: snapshot.data?['name'] ?? '',
                              uId: currentUser.uid,
                              imageSrc: "assets/icons/Avatar.svg",
                              press: () {
                                // Navigator.pushNamed(context, userInfoScreenRoute);
                              },
                            ),
                            if (snapshot.data?['userRole'] !=
                                UserRole.student.name)
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context,
                                    widget.isInstructorView
                                        ? '/'
                                        : '/dashboard'),
                                child: Text(
                                  "Switch to ${widget.isInstructorView ? 'student' : 'instructor'} view",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ProfileMenuListTile(
                              text: "Orders",
                              svgSrc: "assets/icons/Order.svg",
                              press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                // sign out list tile
                ListTile(
                  onTap: currentUser != null
                      ? _signOut
                      : () => Navigator.pushNamed(context, '/login'),
                  leading: currentUser != null
                      ? const Icon(Icons.logout, color: Colors.red)
                      : const Icon(Icons.login),
                  title: Text(
                    currentUser != null ? "Sign out" : "Sign In",
                    style: TextStyle(
                      color: currentUser != null ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseService().singOut();
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/src/components/list_tile/divider_list_tile.dart';
// import 'package:shop/src/constants.dart';
// import 'package:shop/src/providers/auth_provider.dart';
// import 'package:shop/src/route/screen_export.dart';

// import 'components/profile_card.dart';
// import 'components/profile_menu_item_list_tile.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           Consumer<AuthProvider>(
//             builder: (BuildContext context, provider, Widget? child) =>
//                 provider.isLoggedIn
//                     ? ProfileCard(
//                         name: provider.displayName.toString(),
//                         email: provider.email.toString(),
//                         imageSrc: "assets/icons/Avatar.svg",
//                         // proLableText: "Sliver",
//                         // isPro: true, if the user is pro
//                         press: () {
//                           ;
//                           // Navigator.pushNamed(context, userInfoScreenRoute);
//                         },
//                       )
//                     : ProfileCard(
//                         name: 'Login',
//                         imageSrc: "assets/icons/Avatar.svg",
//                         isShowHi: false,
//                         press: () {
//                           context.go('/$logInScreenRoute');
//                         },
//                       ),
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(
//           //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
//           //   child: GestureDetector(
//           //     onTap: () {},
//           //     child: const AspectRatio(
//           //       aspectRatio: 1.8,
//           //       child:
//           //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
//           //     ),
//           //   ),
//           // ),

//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Account",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           const SizedBox(height: defaultPadding / 2),
//           ProfileMenuListTile(
//             text: "Orders",
//             svgSrc: "assets/icons/Order.svg",
//             press: () {
//               context.go('/$ordersScreenRoute');
//             },
//           ),
//           // ProfileMenuListTile(
//           //   text: "Returns",
//           //   svgSrc: "assets/icons/Return.svg",
//           //   press: () {},
//           // ),
//           // ProfileMenuListTile(
//           //   text: "Wishlist",
//           //   svgSrc: "assets/icons/Wishlist.svg",
//           //   press: () {},
//           // ),
//           ProfileMenuListTile(
//             text: "Addresses",
//             svgSrc: "assets/icons/Address.svg",
//             press: () {
//               Navigator.pushNamed(context, addressesScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Payment",
//             svgSrc: "assets/icons/card.svg",
//             press: () {
//               Navigator.pushNamed(context, emptyPaymentScreenRoute);
//             },
//           ),
//           // ProfileMenuListTile(
//           //   text: "Wallet",
//           //   svgSrc: "assets/icons/Wallet.svg",
//           //   press: () {
//           //     Navigator.pushNamed(context, walletScreenRoute);
//           //   },
//           // ),
//           const SizedBox(height: defaultPadding),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Personalization",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           DividerListTileWithTrilingText(
//             svgSrc: "assets/icons/Notification.svg",
//             title: "Notification",
//             trilingText: "Off",
//             press: () {
//               Navigator.pushNamed(context, enableNotificationScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "Preferences",
//             svgSrc: "assets/icons/Preferences.svg",
//             press: () {
//               Navigator.pushNamed(context, preferencesScreenRoute);
//             },
//           ),
//           const SizedBox(height: defaultPadding),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(
//           //       horizontal: defaultPadding, vertical: defaultPadding / 2),
//           //   child: Text(
//           //     "Settings",
//           //     style: Theme.of(context).textTheme.titleSmall,
//           //   ),
//           // ),
//           // ProfileMenuListTile(
//           //   text: "Language",
//           //   svgSrc: "assets/icons/Language.svg",
//           //   press: () {
//           //     Navigator.pushNamed(context, selectLanguageScreenRoute);
//           //   },
//           // ),
//           // ProfileMenuListTile(
//           //   text: "Location",
//           //   svgSrc: "assets/icons/Location.svg",
//           //   press: () {},
//           // ),
//           // const SizedBox(height: defaultPadding),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding / 2),
//             child: Text(
//               "Help & Support",
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           ProfileMenuListTile(
//             text: "Get Help",
//             svgSrc: "assets/icons/Help.svg",
//             press: () {
//               Navigator.pushNamed(context, getHelpScreenRoute);
//             },
//           ),
//           ProfileMenuListTile(
//             text: "FAQ",
//             svgSrc: "assets/icons/FAQ.svg",
//             press: () {},
//             isShowDivider: false,
//           ),
//           const SizedBox(height: defaultPadding),

//           // Log Out
//           Consumer<AuthProvider>(
//             builder: (BuildContext context, provider, Widget? child) => provider
//                     .isLoggedIn
//                 ? ListTile(
//                     onTap: () {
//                       provider.logout();
//                     },
//                     minLeadingWidth: 24,
//                     leading: SvgPicture.asset(
//                       "assets/icons/Logout.svg",
//                       height: 24,
//                       width: 24,
//                       colorFilter: const ColorFilter.mode(
//                         errorColor,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     title: const Text(
//                       "Log Out",
//                       style:
//                           TextStyle(color: errorColor, fontSize: 14, height: 1),
//                     ),
//                   )
//                 : SizedBox(),
//           )
//         ],
//       ),
//     );
//   }
// }
