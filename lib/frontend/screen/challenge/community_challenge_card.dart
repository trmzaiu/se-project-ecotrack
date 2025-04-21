import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class CommunityChallengeCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const CommunityChallengeCard({super.key, required this.data});

  @override
  State<CommunityChallengeCard> createState() => _CommunityChallengeCardState();
}

class _CommunityChallengeCardState extends State<CommunityChallengeCard> {

  @override
  Widget build(BuildContext context) {
    final title = widget.data['title'] ?? '';
    final image = widget.data['image'] ?? '';
    final progress = (widget.data['progress'] ?? 0);
    final target = (widget.data['targetValue'] ?? 1000);
    final participants = (widget.data['participants'] as List?)?.length ?? 0;
    final startDate =  DateFormat('dd MMM, yy').format(widget.data['startDate'].toDate());
    final endDate =  DateFormat('dd MMM, yy').format(widget.data['endDate'].toDate());

    final progressRatio = (progress / target).clamp(0.0, 1.0);
    final percentage = (progressRatio * 100).toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/$image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: AppFontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progressRatio,
                              minHeight: 8,
                              backgroundColor: AppColors.accent.withOpacity(0.6),
                              color: AppColors.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            "$percentage%",
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.tertiary,
                              fontWeight: AppFontWeight.medium,
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 5),

          Divider(),

          const SizedBox(height: 5),

          Padding(
            padding: EdgeInsets.symmetric(horizontal:  15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: startDate,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.secondary,
                          fontWeight: AppFontWeight.medium,
                        ),
                      ),

                      TextSpan(
                        text: ' to ',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.secondary,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),

                      TextSpan(
                        text: endDate,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.secondary,
                          fontWeight: AppFontWeight.medium,
                        ),
                      ),
                    ]
                  )
                ),

                Text(
                  '$participants attending',
                  style: GoogleFonts.urbanist(
                    color: AppColors.tertiary,
                    fontWeight: AppFontWeight.medium,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
