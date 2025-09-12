import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/widgets/no_item.dart';
import 'package:provider/provider.dart';

class ProfileListScreen extends StatefulWidget {
  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  final CustomTheme customTheme = CustomTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadAllProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profiles = provider.allProfiles;

    return Scaffold(
      body: Container(
        color: CustomTheme.backgroundScreenColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            if (profiles.isEmpty)
              NoItem(
                title: 'No profiles found',
                subTitle: 'Profiles will appear here once they are added',
              )
            else
              ...profiles
                  .map(
                    (profile) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildProfileCard(
                        profile.profilePicturePath ?? '',
                        profile.name,
                        profile.email,
                        profile.uid,
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.colorGold,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/edit-profile', arguments: {'createNewProfile': true});
        },
      ),
    );
  }

  Widget _buildProfileCard(
    String imagePath,
    String name,
    String email,
    String uid,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: CustomTheme.borderRadius,
        child: InkWell(
          borderRadius: CustomTheme.borderRadius,
          onTap: () {
            Navigator.pushNamed(context, '/profile', arguments: {'uid': uid});
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomTheme.colorGold, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: CustomTheme.colorBrown.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: imagePath.isNotEmpty
                        ? NetworkImage(imagePath)
                        : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    backgroundColor: CustomTheme.colorGold.withOpacity(0.3),
                    child: imagePath.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: CustomTheme.colorLightBrown,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: customTheme.mediumFont(
                          CustomTheme.colorBrown,
                          FontWeight.w700,
                          context,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: customTheme.smallFont(
                          CustomTheme.colorLightBrown,
                          FontWeight.w500,
                          context,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomTheme.colorGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: CustomTheme.colorLightBrown,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
