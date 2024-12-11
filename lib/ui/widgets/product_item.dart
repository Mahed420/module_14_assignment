import 'package:flutter/material.dart';
import 'package:module13assignment/ui/widgets/delete_product.dart';

import '../../models/product.dart';
import '../screens/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  ProductItem({super.key, required this.product, required this.onDelete,required this.onEdit});

  final Product product;
  VoidCallback onDelete;
  VoidCallback onEdit;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isDeleting = false;

  Future<void> _deleteState() async {
    setState(() {
      _isDeleting = true;
    });

    final success = await deleteProduct(widget.product.id.toString());

    setState(() {
      _isDeleting = false;
    });

    if (success) {
      widget.onDelete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Product deleted successfully",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Failed to delete product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.product.image ?? '',
        width: 40,
      ),
      title: Text(widget.product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${widget.product.quantity ?? 'Unknown'}'),
          Text('Price: ${widget.product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${widget.product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: _isDeleting ? null : () => _confirmDelete(context),
              icon: _isDeleting
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.delete)),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: widget.product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
