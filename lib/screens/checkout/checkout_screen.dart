import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/cart_provider.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedPaymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: GoogleFonts.poppins(color: AppColors.textWhite)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true, // For the floating bottom bar
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Stepper/Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    _buildStep(0, 'Shipping', _currentStep >= 0),
                    _buildStepDivider(_currentStep >= 1),
                    _buildStep(1, 'Payment', _currentStep >= 1),
                    _buildStepDivider(_currentStep >= 2),
                    _buildStep(2, 'Confirm', _currentStep >= 2),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildCurrentStep(),
                ),
              ),
              const SizedBox(height: 100), // Spacing for bottom bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildStep(int stepIndex, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isActive ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.3),
            child: isActive 
                ? const Icon(Icons.check, size: 14, color: AppColors.primaryDark) 
                : Text('${stepIndex + 1}', style: const TextStyle(color: AppColors.primaryDark, fontSize: 10)),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: isActive ? AppColors.textWhite : AppColors.textLightGreen.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      width: 20,
      height: 2,
      color: isActive ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.3),
    );
  }
  
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: // Shipping
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: GoogleFonts.poppins(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildAddressCard('John Den.', '123 Greenbolt St, New York, NY 10012', true),
            const SizedBox(height: 10),
            _buildAddressCard('John Den. Work', '456 Bookworm Ave, San Francisco, CA', false),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.accentGreen),
                label: Text('Add New Address', style: GoogleFonts.poppins(color: AppColors.accentGreen)),
              ),
            ),
          ],
        );
      case 1: // Payment
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method', style: GoogleFonts.poppins(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPaymentOption('Credit Card', '**** 1234', Icons.credit_card, true),
            const SizedBox(height: 10),
            _buildPaymentOption('PayPal', 'john@example.com', Icons.paypal, false),
            const SizedBox(height: 10),
            _buildPaymentOption('Apple Pay', 'Apple Pay', Icons.phone_iphone, false),
          ],
        );
      case 2: // Confirm
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary', style: GoogleFonts.poppins(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ...cart.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('${item.quantity}x ${item.book.title}', style: GoogleFonts.poppins(color: AppColors.textWhite))),
                            Text('\$${item.totalPrice.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppColors.textWhite)),
                          ],
                        ),
                      )),
                      const Divider(color: AppColors.textLightGreen),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: GoogleFonts.poppins(color: AppColors.textLightGreen)),
                          Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppColors.textWhite)),
                        ],
                      ),
                      const SizedBox(height: 4),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping', style: GoogleFonts.poppins(color: AppColors.textLightGreen)),
                          Text('\$5.00', style: GoogleFonts.poppins(color: AppColors.textWhite)),
                        ],
                      ),
                      const Divider(color: AppColors.textLightGreen),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('\$${(cart.totalAmount + 5.0).toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAddressCard(String name, String address, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: isSelected ? Border.all(color: AppColors.accentGreen, width: 2) : null,
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: isSelected ? AppColors.accentGreen : AppColors.textLightGreen),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                Text(address, style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 12)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.accentGreen),
        ],
      ),
    );
  }
  
  Widget _buildPaymentOption(String name, String detail, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: isSelected ? Border.all(color: AppColors.accentGreen, width: 2) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.accentGreen : AppColors.textLightGreen),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                Text(detail, style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 12)),
              ],
            ),
          ),
           if (isSelected) const Icon(Icons.check_circle, color: AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryMid,
            AppColors.primaryLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Consumer<CartProvider>(
             builder: (_, cart, __) => Text(
              'Total: \$${(cart.totalAmount + (_currentStep == 2 ? 5.0 : 0)).toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: AppColors.textWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
           ),
          ElevatedButton(
            onPressed: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
              } else {
                // Process Payment and Navigate
                // Clear cart?
                Provider.of<CartProvider>(context, listen: false).clearCart();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGreen,
              foregroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(_currentStep == 2 ? 'Pay Now' : 'Next'),
          ),
        ],
      ),
    );
  }
}
