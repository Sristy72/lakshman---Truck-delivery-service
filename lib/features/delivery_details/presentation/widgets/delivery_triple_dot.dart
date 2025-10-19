import 'package:flutter/material.dart';

class TripleZeroIndicator extends StatelessWidget {
  final int currentStep;
  final double size;
  final Color color;
  final double width;

  const TripleZeroIndicator({
    super.key,
    required this.currentStep,
    this.size = 24.0,
    this.color = const Color(0xffDCE4F5),
    this.width = 63,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isCompleted = index < currentStep;
        final isProcessing = index == currentStep;
        final isFuture = index > currentStep;

        return Row(
          children: [
            if (index > 0)
              Container(
                width: width,
                height: 1,
                color: color.withOpacity(0.5),
              ),
            Container(
              width: 34,
              height: 24,
              decoration: BoxDecoration(
                color: isProcessing ? Colors.transparent : Color(0xffE5EDFF),
                shape: BoxShape.circle,
                border: isProcessing
                    ? Border.all(color: Colors.orange, width: 2)
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: size * 0.6, color: Colors.green)
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}