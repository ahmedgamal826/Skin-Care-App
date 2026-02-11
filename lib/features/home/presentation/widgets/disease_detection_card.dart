import 'package:flutter/material.dart';
import '../../../../app_colors.dart';
import '../../../disease_detection/presentation/pages/disease_detection_screen.dart';

/// بطاقة كشف سرطان الجلد للصفحة الرئيسية
class DiseaseDetectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsets? padding;
  final double? borderRadius;

  const DiseaseDetectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DiseaseDetectionScreen(),
          ),
        );
      },
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.lightMint,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          border: Border.all(color: AppColors.mintTeal),
          boxShadow: [
            BoxShadow(
              color: AppColors.mintTeal.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor ?? AppColors.mintTeal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medical_services,
                color: AppColors.darkTeal,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "كشف سرطان الجلد",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkWarm,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle ?? "فحص الصور للكشف عن مشاكل جلدية محتملة",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkLavender,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.mintTeal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.darkTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة مصغرة لكشف سرطان الجلد
class DiseaseDetectionMiniCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final IconData? icon;

  const DiseaseDetectionMiniCard({
    super.key,
    this.onTap,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiseaseDetectionScreen(),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightPeach,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.mintTeal),
          boxShadow: [
            BoxShadow(
              color: AppColors.mintTeal.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.medical_services,
              color: AppColors.darkTeal,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title ?? "كشف سرطان الجلد",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkWarm,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
