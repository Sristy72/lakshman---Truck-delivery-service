import 'package:flutter/material.dart';

/// Reusable skeleton loader widget for shimmer effect
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(_animation.value),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for text lines
class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({
    super.key,
    this.width = double.infinity,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Skeleton loader for circular avatars
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// Skeleton loader for list items
class SkeletonListItem extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  const SkeletonListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLeading) ...[
            const SkeletonCircle(size: 48),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonText(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                ...List.generate(
                  lines - 1,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SkeletonText(
                      width: index == lines - 2 ? 100 : double.infinity,
                      height: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            const SkeletonLoader(width: 60, height: 40),
          ],
        ],
      ),
    );
  }
}

/// Skeleton loader for shipment/load cards
class SkeletonShipmentCard extends StatelessWidget {
  const SkeletonShipmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(
              width: 32,
              height: 32,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 12),
            const Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(width: double.infinity, height: 12),
                  SizedBox(height: 6),
                  SkeletonText(width: 80, height: 10),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(width: double.infinity, height: 10),
                  SizedBox(height: 6),
                  SkeletonText(width: 100, height: 10),
                  SizedBox(height: 8),
                  SkeletonText(width: double.infinity, height: 10),
                  SizedBox(height: 6),
                  SkeletonText(width: 120, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for profile header
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 40),
        SkeletonText(width: 100, height: 24),
        SizedBox(height: 30),
        SkeletonCircle(size: 120),
        SizedBox(height: 16),
        SkeletonText(width: 150, height: 20),
        SizedBox(height: 8),
        SkeletonText(width: 120, height: 16),
      ],
    );
  }
}

/// Skeleton loader for menu list
class SkeletonMenuList extends StatelessWidget {
  final int itemCount;

  const SkeletonMenuList({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SkeletonLoader(
                    width: 20,
                    height: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SkeletonText(height: 16)),
                  const SizedBox(width: 12),
                  SkeletonLoader(
                    width: 16,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            if (index < itemCount - 1)
              Divider(color: Colors.grey.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for dashboard stats cards
class SkeletonDashboardStats extends StatelessWidget {
  const SkeletonDashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SkeletonLoader(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SkeletonLoader(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SkeletonLoader(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
