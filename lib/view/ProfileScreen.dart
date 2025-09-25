import 'package:cleancity/data/model/User.dart';
import 'package:cleancity/viewmodel/ProfileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildInfoTile(String label, String value, {IconData? icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: icon != null ? Icon(icon, color: Colors.blue) : null,
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadUser(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (viewModel.user == null) {
            return const Scaffold(
              body: Center(child: Text("No user data found")),
            );
          }

          User user = viewModel.user!;

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person,
                              size: 60, color: Colors.blue),
                        ),
                        const SizedBox(height: 12),
                        Text(user.fullName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(user.role,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info tiles
                  _buildInfoTile("User ID", user.uid, icon: Icons.perm_identity),
                  _buildInfoTile("Email", user.email, icon: Icons.email),
                  _buildInfoTile("Mobile", user.mobileNumber, icon: Icons.phone),
                  _buildInfoTile("Reward Points", user.rewardPoints.toString(),
                      icon: Icons.star),
                  _buildInfoTile(
                      "Registered At",
                      user.registeredAt
                          .toLocal()
                          .toString()
                          .split(".")
                          .first,
                      icon: Icons.calendar_today),
                  _buildInfoTile("Active Status",
                      user.isActive ? "Active" : "Inactive",
                      icon: Icons.check_circle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
