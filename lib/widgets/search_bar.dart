import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';
import 'package:simple_note_app/constants.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.themeSecondary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          context.read<NoteViewmodel>().searchNotes(value);
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryText),
          hintText: "Tìm kiếm ghi chú...",
          hintStyle: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(color: AppColors.primaryText, fontSize: 16),
        cursorColor: AppColors.primaryText,
      ),
    );
  }
}
