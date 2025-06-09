import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, John',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.primaryLight,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ],
    );
  }
}
