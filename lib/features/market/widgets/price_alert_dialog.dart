import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../models/market_price.dart';

class PriceAlertDialog extends StatefulWidget {
  final MarketPrice price;

  const PriceAlertDialog({
    super.key,
    required this.price,
  });

  @override
  State<PriceAlertDialog> createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<PriceAlertDialog> {
  final TextEditingController _priceController = TextEditingController();
  String _selectedCondition = '>=';
  
  @override
  void initState() {
    super.initState();
    _priceController.text = widget.price.price.toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Text(widget.price.cropEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Set Price Alert for ${widget.price.crop}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get notified when ${widget.price.crop} price changes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          // Condition selector
          const Text(
            'Condition',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCondition,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: '>=', child: Text('Greater than or equal to (≥)')),
                  DropdownMenuItem(value: '<=', child: Text('Less than or equal to (≤)')),
                  DropdownMenuItem(value: '==', child: Text('Equal to (=)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Price input
          const Text(
            'Target Price',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter target price',
              prefixText: '₹ ',
              suffixText: '/${widget.price.unit}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF388E3C)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Current price info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current price: ₹${widget.price.price}/${widget.price.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final targetPrice = double.tryParse(_priceController.text);
            if (targetPrice != null) {
              context.read<MarketBloc>().add(
                SubscribeToPriceAlert(
                  farmerId: 'farmer_123', // This should come from user session
                  crop: widget.price.crop,
                  threshold: targetPrice,
                  condition: _selectedCondition,
                ),
              );
              Navigator.of(context).pop();
              
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Price alert set for ${widget.price.crop} at ₹$targetPrice/${widget.price.unit}',
                  ),
                  backgroundColor: const Color(0xFF388E3C),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF388E3C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Set Alert',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}