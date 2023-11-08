import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/profile_service.dart';

class ProfileWidget extends StatefulWidget {
  final UserModel user;

  const ProfileWidget({super.key, required this.user});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late String _avatarURL;
  late TextEditingController _nameController;
  final ProfileService _profileService = ProfileService();


  @override
  void initState() {
    super.initState();
    _avatarURL = widget.user.avatarURL;
    _nameController = TextEditingController(text: widget.user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(218, 191, 201, 1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  final avatarURL = await _profileService.updateUserProfile(
                      imageSource: ImageSource.gallery);
                  setState(() {
                    _avatarURL = avatarURL!;
                  });
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatarURL.isNotEmpty
                      ? NetworkImage(_avatarURL)
                      : const AssetImage('assets/UnivalleLogo.png')
                          as ImageProvider<Object>,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  onSubmitted: (value) async {
                    await _profileService.updateUserProfile(newUsername: value);
                  },
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Text(
              widget.user.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
