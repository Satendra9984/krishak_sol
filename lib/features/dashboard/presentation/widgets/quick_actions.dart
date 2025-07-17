import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;

  QuickAction({required this.title, required this.icon, required this.color});
}

class QuickActions extends StatelessWidget {
  QuickActions({super.key});

  final List<QuickAction> actions = [
    QuickAction(
      title: 'Soil Test',
      icon: Icons.analytics_outlined,
      color: const Color(0xFFFF6B6B),
    ),
    QuickAction(
      title: 'Crop Advisory',
      icon: Icons.spa_outlined,
      color: const Color(0xFF4ECDC4),
    ),
    QuickAction(
      title: 'Weather',
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFFFD166),
    ),
    QuickAction(
      title: 'Market',
      icon: Icons.shopping_cart_outlined,
      color: const Color(0xFF7F5AF0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionItem(action);
      },
    );
  }

  Widget _buildActionItem(QuickAction action) {
    return GestureDetector(
      onTap: () {
        // Handle action tap
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: action.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              action.title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
