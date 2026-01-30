import 'package:flutter/material.dart';

class CustomSearchDropdown extends StatefulWidget {
  final List<dynamic> items;
  final String hint;
  final ValueChanged<String> onChanged;
  final double height;

  const CustomSearchDropdown({super.key, required this.items, required this.onChanged, this.hint = 'Select', this.height = 50});

  @override
  State<CustomSearchDropdown> createState() => _CustomSearchDropdownState();
}

class _CustomSearchDropdownState extends State<CustomSearchDropdown> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String? _selectedItem;
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _filteredItems = widget.items;
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 6),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      /// SEARCH FIELD
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filteredItems = widget.items.where((e) => e.toLowerCase().contains(value.toLowerCase())).toList();
                            });
                            _overlayEntry?.markNeedsBuild();
                          },
                        ),
                      ),

                      /// LIST ITEM
                      Expanded(
                        child:
                            _filteredItems.isEmpty
                                ? const Center(child: Text('No data found'))
                                : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _filteredItems[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() => _selectedItem = item);
                                        widget.onChanged(item);
                                        _closeDropdown();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        child: Text(item, style: const TextStyle(fontSize: 14)),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400), color: Colors.white),
          child: Row(
            children: [
              Expanded(child: Text(_selectedItem ?? widget.hint, style: TextStyle(color: _selectedItem == null ? Colors.grey : Colors.black))),
              Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }
}
