import 'package:depi_final_project/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'overflow_test_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;
    final bool isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF904E93), Color(0xFFFFB138)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: isTablet ? 26 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OverflowTestScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bug_report, color: Colors.white),
                        tooltip: 'Test Overflow',
                      ),
                      IconButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Ready for your next challenge?',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 15,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isTablet ? 24 : 16),
                    Text(
                      'Quiz Categories',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF904E93),
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              isLargeScreen ? 4 : (isTablet ? 3 : 2);
                          double spacing = isTablet ? 20 : 16;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: isTablet ? 1.0 : 0.9,
                            children: [
                              _buildFeatureCard(
                                icon: Icons.science,
                                title: 'Science',
                                subtitle: 'Test Your Knowledge',
                                color: const Color(0xFF904E93),
                                onTap:
                                    () => _showFeatureDialog(
                                      context,
                                      'Science Quiz',
                                    ),
                              ),
                              _buildFeatureCard(
                                icon: Icons.history_edu,
                                title: 'History',
                                subtitle: 'Explore The Past',
                                color: const Color(0xFFFFB138),
                                onTap:
                                    () => _showFeatureDialog(
                                      context,
                                      'History Quiz',
                                    ),
                              ),
                              _buildFeatureCard(
                                icon: Icons.sports_soccer,
                                title: 'Sports',
                                subtitle: 'Game On!',
                                color: const Color(0xFF4CAF50),
                                onTap:
                                    () => _showFeatureDialog(
                                      context,
                                      'Sports Quiz',
                                    ),
                              ),
                              _buildFeatureCard(
                                icon: Icons.public,
                                title: 'Geography',
                                subtitle: 'Explore The World',
                                color: const Color(0xFF2196F3),
                                onTap:
                                    () => _showFeatureDialog(
                                      context,
                                      'Geography Quiz',
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final Size screenSize = MediaQuery.of(context).size;
        final bool isTablet = screenSize.width > 600;
        final double iconSize = isTablet ? 48 : 40;
        final double titleFontSize = isTablet ? 18 : 16;
        final double subtitleFontSize = isTablet ? 14 : 12;
        final double cardPadding = isTablet ? 24 : 16;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(icon, size: iconSize, color: color),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: isTablet ? 8 : 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFeatureDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text(
            '$feature is coming soon! Get ready to test your knowledge.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Quiz App'),
          content: const Text('Are you sure you want to leave the quiz app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
