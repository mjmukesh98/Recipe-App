import 'package:flutter/material.dart';

class ModernSearchBar extends StatefulWidget {
  final Function(String) onChanged;

  const ModernSearchBar({super.key, required this.onChanged});

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: isFocused
                ? Colors.green.withOpacity(0.25)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isFocused ? Colors.green : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Focus(
        onFocusChange: (focus) {
          setState(() => isFocused = focus);
        },
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            border: InputBorder.none,

            // 🔍 SEARCH ICON
            prefixIcon: Icon(
              Icons.search,
              color: isFocused ? Colors.green : Colors.grey,
            ),

            hintText: "Search delicious food...",
            hintStyle: TextStyle(color: Colors.grey.shade500),

            // ❌ CLEAR BUTTON
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                widget.onChanged("");

                // refresh UI
                setState(() {});
              },
            )
                : null,
          ),
        ),
      ),
    );
  }
}