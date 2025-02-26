import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class AccountEditDialog extends StatefulWidget {
  const AccountEditDialog(
      {super.key, required this.userName, this.onNameChanged});

  final String userName;
  final VoidCallback? onNameChanged;

  @override
  State<AccountEditDialog> createState() => _AccountEditDialogState();
}

class _AccountEditDialogState extends State<AccountEditDialog> {
  final TextEditingController _nameController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    _nameController.text = widget.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Name'),
      content: SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name cannot be empty'),
                    ),
                  );
                  return;
                }
                if (_nameController.text == widget.userName) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name is same as previous'),
                    ),
                  );
                  return;
                }
                Result result =
                    await _userRepository.updateUserName(_nameController.text);
                if (result.isSuccess) {
                  widget.onNameChanged?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name updated successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update name'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
