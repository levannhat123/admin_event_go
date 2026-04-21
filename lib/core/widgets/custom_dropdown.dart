import 'package:flutter/material.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final String Function(T) getLabel;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.getLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(getLabel(item)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
