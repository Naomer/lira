import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/gradient_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // User greeting section
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple[200],
                            ),
                            child: Icon(
                              PhosphorIcons.user(),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, Alex',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(PhosphorIcons.bell()),
                                onPressed: () {},
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Main prompt
                      const Text(
                        'Good Morning\nHow can I help you?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Main interaction cards
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: SizedBox(
                                height: 280,
                                child: _MainCard(
                                  icon: PhosphorIcons.microphone(),
                                  title: 'Talk to AI assistant',
                                  subtitle: "Let's try it now",
                                  buttonText: 'Start Talking',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/voice-analysis',
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 0),
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: SizedBox(
                                height: 280,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: _SmallCard(
                                        icon: PhosphorIcons.microphone(),
                                        title: 'Voice',
                                        subtitle: 'Voice to text\nAssistant',
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/voice-analysis',
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: _SmallCard(
                                        icon: PhosphorIcons.image(),
                                        title: 'Image',
                                        subtitle: 'Image\nGenerator',
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Topics section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Topics',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFF9B7EDE),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Topic pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _TopicPill('Daily life', isSelected: true),
                            const SizedBox(width: 10),
                            _TopicPill('Business'),
                            const SizedBox(width: 10),
                            _TopicPill('Health'),
                            const SizedBox(width: 10),
                            _TopicPill('Develop'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Information cards
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: 'What is blood pressure?',
                              description:
                                  'Blood pressure measures the force of blood.',
                              onTap: () {
                                Navigator.pushNamed(context, '/smart-chat');
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              title: 'Why is sleep important?',
                              description:
                                  'Quality sleep helps repair the body....',
                              onTap: () {
                                Navigator.pushNamed(context, '/smart-chat');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _MainCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const _MainCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF9B7EDE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF9B7EDE), size: 28),
            ),
            const SizedBox(height: 19),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Spacer(),
            Transform.scale(
              scaleX: 1.1,
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EDE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SmallCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7EDE).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF9B7EDE), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      PhosphorIcons.arrowRight(),
                      size: 20,
                      color: Colors.black,
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
}

class _TopicPill extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _TopicPill(this.text, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF9B7EDE) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF9B7EDE) : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _InfoCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF9B7EDE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Discover',
                style: TextStyle(
                  color: Color(0xFF9B7EDE),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2;

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nav bar with curved cutout in the middle - transparent to show body gradient
          ClipPath(
            clipper: _CurvedNavBarClipper(),
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color:
                    Colors.white, // White nav bar - cutout area shows gradient
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(icon: PhosphorIcons.house(), isActive: true),
                  _NavItem(icon: PhosphorIcons.calendar()),
                  const SizedBox(width: 56), // Space for sparkle button
                  _NavItem(icon: PhosphorIcons.chatCircle()),
                  _NavItem(icon: PhosphorIcons.gear()),
                ],
              ),
            ),
          ),
          // Sparkle button in the curved cutout
          Positioned(
            left: centerX - 28,
            top: -15,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF9B7EDE),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B7EDE).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                PhosphorIcons.sparkle(),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvedNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final buttonRadius = 33.0; // Half of button width (56/2)
    final curveWidth = buttonRadius * 1.5 + 35; // Width to accommodate button
    final curveDepth = 67.0; // Deeper curve to wrap around button

    // Start from bottom left
    path.moveTo(0, size.height);

    // Line to bottom right
    path.lineTo(size.width, size.height);

    // Line to top right
    path.lineTo(size.width, 0);

    // Line to start of right curve (before the cutout)
    path.lineTo(centerX + curveWidth / 2, 0);

    // Right curve going down into the cutout (following button's right side)
    path.quadraticBezierTo(
      centerX + buttonRadius + 10,
      curveDepth * 0.3,
      centerX + buttonRadius,
      curveDepth * 0.6,
    );

    // Bottom curve of the cutout - deeper U shape wrapping around button
    path.quadraticBezierTo(
      centerX,
      curveDepth,
      centerX - buttonRadius,
      curveDepth * 0.6,
    );

    // Left curve coming back up from the cutout (following button's left side)
    path.quadraticBezierTo(
      centerX - buttonRadius - 10,
      curveDepth * 0.3,
      centerX - curveWidth / 2,
      0,
    );

    // Line to top left
    path.lineTo(0, 0);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavItem({required this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: isActive ? const Color(0xFF9B7EDE) : Colors.grey[400],
      size: 24,
    );
  }
}
