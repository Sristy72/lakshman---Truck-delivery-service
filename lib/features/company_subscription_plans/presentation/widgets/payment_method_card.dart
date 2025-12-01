import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String method;
  final IconData icon;
  final Color iconColor;
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.icon,
    required this.iconColor,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedMethod == method;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? const Color(0xFF007AFF) 
            : const Color(0xFFE5E5EA),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onMethodChanged(method),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    method,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method,
              groupValue: selectedMethod,
              onChanged: (value) => onMethodChanged(value!),
              activeColor: const Color(0xFF007AFF),
            ),
          ],
        ),
      ),
    );
  }
}