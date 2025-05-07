import 'package:flutter/material.dart';
import 'package:new_event_booking/admin/admin_auth_screen.dart';
import 'package:new_event_booking/admin/manage_events.dart';
import 'package:new_event_booking/admin/manage_profile.dart';
import 'package:new_event_booking/admin/upload_event.dart';
import 'package:new_event_booking/admin/manage_user.dart';
import 'package:new_event_booking/services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_event_booking/admin/all_booked_tickets.dart';

void main() {
  runApp(const AdminHome());
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<Map<String, String>> _adminDetailsFuture;

  @override
  void initState() {
    super.initState();
    _adminDetailsFuture = _getAdminDetails();
  }

  Future<Map<String, String>> _getAdminDetails() async {
    final adminName = await SharedpreferenceHelper().getAdminName();
    final adminEmail = await SharedpreferenceHelper().getAdminEmail();

    return {
      'name': adminName ?? 'Unknown Admin',
      'email': adminEmail ?? 'unknown@example.com',
    };
  }

  void logoutAdmin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('ADMINNAMEKEY');
    await prefs.remove('ADMINEMAILKEY');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged out"),
        backgroundColor: Colors.blue,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminAuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _adminDetailsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final adminName = snapshot.data!['name']!;
        final adminEmail = snapshot.data!['email']!;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                const Text(
                  'Welcome,',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Admin Dashboard of Evento',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => logoutAdmin(context),
              ),
            ],
            backgroundColor: Colors.blueAccent,
          ),
          drawer: _buildDrawer(context, adminName, adminEmail),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.upload_file,
                  title: 'Upload Events',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Upload_Event()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  icon: Icons.monetization_on,
                  title: 'Events Prices And Details',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageEvent()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  icon: Icons.person,
                  title: 'Manage Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserListScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  icon: Icons.confirmation_num,
                  title: 'Booked Tickets',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllBookedTicketsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(
      BuildContext context, String adminName, String adminEmail) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(adminName),
            accountEmail: Text(adminEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                adminName.isNotEmpty ? adminName[0].toUpperCase() : 'A',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.account_circle),
          //   title: const Text('Profile'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const ManageProfile()),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => logoutAdmin(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
