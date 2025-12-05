import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/order.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order', style: GoogleFonts.poppins(color: AppColors.textWhite)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID & Amount
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 12),
                          ),
                          Text(
                            order.id,
                            style: GoogleFonts.poppins(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Amount',
                            style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 12),
                          ),
                          Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(color: AppColors.accentGreen, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                Text(
                  'Delivery Status',
                  style: GoogleFonts.poppins(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 20),
                
                // Timeline
                _buildTimelineTile(
                  title: 'Order Placed',
                  subtitle: 'We have received your order',
                  date: 'Nov 20, 10:30 AM',
                  isCompleted: true,
                  isFirst: true,
                ),
                _buildTimelineTile(
                  title: 'Confirmed',
                  subtitle: 'Your order has been confirmed',
                  date: 'Nov 20, 11:00 AM',
                  isCompleted: true,
                ),
                _buildTimelineTile(
                  title: 'Order Shipped',
                  subtitle: 'Your order has been shipped',
                  date: 'Nov 21, 09:00 AM',
                  isCompleted: order.status.index >= OrderStatus.shipped.index,
                ),
                _buildTimelineTile(
                  title: 'Out for Delivery',
                  subtitle: 'Our delivery partner is on the way',
                  date: 'Today, 08:30 AM',
                  isCompleted: order.status.index >= OrderStatus.outForDelivery.index,
                ),
                _buildTimelineTile(
                  title: 'Delivered',
                  subtitle: 'Package delivered',
                  date: '',
                  isCompleted: order.status.index >= OrderStatus.delivered.index,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    required String title,
    required String subtitle,
    required String date,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.3),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.accentGreen : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Center(child: Icon(Icons.check, size: 10, color: AppColors.primaryDark))
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.3), // Simple logic, assumes if current is complete, next line starts complete? No, timeline lines connect nodes.
                // Better logic: Line below node should be colored if NEXT node is also completed?
                // For simplicity here, just using gray for future.
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20), // Spacing between items
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: isCompleted ? AppColors.textWhite : AppColors.textLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        color: AppColors.textLightGreen,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.textLightGreen.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
