import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  final Function(Set<String>) onFiltersChanged;
  final Map<String, Color> typeColors;
  final Set<String> activeFilters; // Add this

  const FilterPanel({
    Key? key,
    required this.onFiltersChanged,
    required this.typeColors,
    required this.activeFilters, // Add this
  }) : super(key: key);

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  bool isExpanded = false;

  void toggleFilter(String type) {
    final newFilters = Set<String>.from(widget.activeFilters);
    if (newFilters.contains(type)) {
      newFilters.remove(type); // Allow removing even the last filter
    } else {
      newFilters.add(type);
    }
    widget.onFiltersChanged(newFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF003366).withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Material(
              color: Color(0xFFF2EBD9),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(12),
                bottom: Radius.circular(isExpanded ? 0 : 12),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: Color(0xFFD88D7F)),
                      const SizedBox(width: 12),
                      const Text(
                        'FILTER',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Color(0xFFD88D7F),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isExpanded)
              Material(
                color: Color(0xFFF2EBD9),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.typeColors.entries.map((entry) {
                      final type = entry.key;
                      final color = entry.value;
                      final isActive = widget.activeFilters.contains(type);

                      return InkWell(
                        onTap: () => toggleFilter(type),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  type.replaceAll('_', ' ').toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        isActive ? Colors.black87 : Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Color(0xFF003366)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isActive
                                        ? Color(0xFF003366)
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: isActive
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Color(0xFFF2EBD9),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
