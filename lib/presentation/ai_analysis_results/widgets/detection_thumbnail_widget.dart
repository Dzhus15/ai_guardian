import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DetectionThumbnailWidget extends StatelessWidget {
  final String imageUrl;
  final List<dynamic> detectedElements;
  final double size;

  const DetectionThumbnailWidget({
    super.key,
    required this.imageUrl,
    required this.detectedElements,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          children: [
            CustomImageWidget(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),

            // Detection overlay indicator
            if (detectedElements.isNotEmpty)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${detectedElements.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Bounding box indicators (simplified for thumbnail)
            ...detectedElements.take(2).map((element) {
              final bbox = element['bbox'] as List;
              if (bbox.every((coord) => coord == 0)) return SizedBox.shrink();

              // Scale bounding box to thumbnail size
              final scaleX = size / 400; // Assuming original image width of 400
              final scaleY =
                  size / 300; // Assuming original image height of 300

              return Positioned(
                left: (bbox[0] * scaleX).clamp(0.0, size - 2),
                top: (bbox[1] * scaleY).clamp(0.0, size - 2),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
