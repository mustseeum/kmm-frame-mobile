import 'package:flutter/material.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_data_model.dart';

class ProductCard extends StatelessWidget {
  final ProductDataModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  String _formatPrice(int p) {
    // Indonesian-style formatting (simple). Replace with NumberFormat if intl added.
    final s = p.toString();
    // naive thousand formatting
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write('.');
    }
    return 'Rp${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image placeholder
            AspectRatio(
              aspectRatio: 1.6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: product.imageUrls.isNotEmpty
                    ? Image.network(product.imageUrls.first.url, fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.image, size: 48, color: Colors.black26)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.model, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(_formatPrice(product.price), style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}