import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomSearchDropdown extends FormField<String> {
  CustomSearchDropdown({
    super.key,
    required List<dynamic> items,
    required ValueChanged<String> onChanged,
    String hint = 'Select',
    double height = 50,
    String? initialValue,
    FormFieldValidator<String>? validator,
  }) : super(
         initialValue: initialValue,
         validator: validator,
         builder: (FormFieldState<String> state) {
           return _CustomSearchDropdownBody(
             items: items,
             hint: hint,
             height: height,
             value: state.value,
             errorText: state.errorText,
             onChanged: (value) {
               state.didChange(value); // 🔥 PENTING
               onChanged(value);
             },
           );
         },
       );
}

class _CustomSearchDropdownBody extends StatefulWidget {
  final List<dynamic> items;
  final String hint;
  final double height;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _CustomSearchDropdownBody({required this.items, required this.hint, required this.height, required this.onChanged, this.value, this.errorText});

  @override
  State<_CustomSearchDropdownBody> createState() => _CustomSearchDropdownBodyState();
}

class _CustomSearchDropdownBodyState extends State<_CustomSearchDropdownBody> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  List<dynamic> _filteredItems = [];
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _CustomSearchDropdownBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _selectedValue) {
      _selectedValue = widget.value;
    }
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
    final renderBox = context.findRenderObject() as RenderBox;
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
                      /// SEARCH
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filteredItems = widget.items.where((e) => e.toString().toLowerCase().contains(value.toLowerCase())).toList();
                            });
                            _overlayEntry?.markNeedsBuild();
                          },
                        ),
                      ),

                      /// LIST
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
                                        setState(() {
                                          _selectedValue = item.toString();
                                        });
                                        widget.onChanged(item.toString());
                                        _closeDropdown();
                                      },
                                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Text(item.toString())),
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
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// DROPDOWN FIELD
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: hasError ? merah2 : Colors.grey.shade400),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(_selectedValue ?? widget.hint, style: TextStyle(color: _selectedValue == null ? Colors.grey : Colors.black))),
                  Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),

        /// ERROR TEXT
        if (hasError)
          Padding(padding: const EdgeInsets.only(top: 6, left: 12), child: Text(widget.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
      ],
    );
  }
}
