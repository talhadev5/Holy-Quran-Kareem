// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:quran_kareem/utils/appcolors.dart';

// class FeatureCard extends StatelessWidget {
//   final String title;
//   // final IconData icon;
//   final String image;
//   final VoidCallback? onTap;

//   const FeatureCard({
//     required this.title,
//     // required this.icon,
//     required this.image,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         // padding: const EdgeInsets.all(4.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.whitColor,
//             border: Border.all(color: AppColors.primary, width: 1),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 5,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 image,
//                 height: 45,
//                 width: 45,
//               ),
//               // Icon(icon, size: 50, color: AppColors.primary),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData? icon; // Now optional
  final String? image; // Now optional
  final VoidCallback? onTap;

  const FeatureCard({
    required this.title,
    this.icon, // Optional
    this.image, // Optional
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whitColor,
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null) // Show image if provided
                SvgPicture.asset(
                  image!,
                  height: 45,
                  width: 45,
                )
              else if (icon != null) // Show icon if no image is provided
                Icon(icon, size: 45, color: AppColors.primary),
              
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
