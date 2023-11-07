import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import 'profile_controller.dart';

class ProfileWidget extends StatefulWidget {
  final UserModel user;

  const ProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late String _avatarURL;
  late TextEditingController _nameController;
  final ProfileController _profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    _avatarURL = widget.user.avatarURL;
    _nameController = TextEditingController(text: widget.user.username);
  }

  Future<void> _updateAvatar() async {
    final pickedFile =
        await _profileController.getAvatarImage(ImageSource.gallery);

    if (pickedFile != null) {
      String? newAvatarURL = await _profileController.uploadAvatarToFirebase();

      if (newAvatarURL != null) {
        setState(() {
          _avatarURL = newAvatarURL;
        });
      }
    }
  }

  Future<void> _updateUsername() async {
    await _profileController.updateUserProfile(
      username: _nameController.text,
      avatarUrl: _avatarURL,
    );
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
                onTap: _updateAvatar,
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
                  onSubmitted: (value) => _updateUsername(),
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
