// Detail modal (reusable)
import 'package:flutter/material.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_data_model.dart';

class ProductDetailModal extends StatelessWidget {
  final ProductDataModel product;
  final VoidCallback? onConfirm;
  final VoidCallback? onClose;

  const ProductDetailModal({super.key, required this.product, this.onConfirm, this.onClose});

  String _formatPrice(int p) {
    final s = p.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write('.');
    }
    return 'Rp${buffer.toString()}';
  }

  String get displayName => '${product.brand} ${product.model}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 900,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0E3B36),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  const Text('Detail Product', style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // big image
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 300,
                      color: Colors.grey.shade100,
                      child: product.imageUrls.isNotEmpty
                          ? Image.network(product.imageUrls.first.toString(), fit: BoxFit.contain)
                          : const Center(child: Icon(Icons.image, size: 80, color: Colors.black12)),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // details
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(_formatPrice(product.price), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('Color: ${product.color}', style: const TextStyle(color: Colors.blueGrey)),
                        Text('Size: ${product.size}', style: const TextStyle(color: Colors.blueGrey)),
                        Text('Material: ${product.material}', style: const TextStyle(color: Colors.blueGrey)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: product.colorOptions.map((c) {
                            Color col;
                            try {
                              col = Color(int.parse(c.hexCode.replaceFirst('#', '0xff')));
                            } catch (e) {
                              col = Colors.grey;
                            }
                            return Container(width: 28, height: 28, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: Colors.white)));
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onConfirm ?? () {},
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0E3B36)),
                            child: const Text('I want this!', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ExpansionTile(
                          title: const Text('Product Specification'),
                          children: [Padding(padding: const EdgeInsets.all(12), child: Text(product.description))],
                        ),
                        const SizedBox(height: 8),
                        ExpansionTile(title: const Text('Other Notes'), children: const [Padding(padding: EdgeInsets.all(12), child: Text('—'))]),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}