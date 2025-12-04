import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_note_app/constants.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';

class NoteNewScreen extends StatefulWidget {
  const NoteNewScreen({super.key});

  @override
  State<NoteNewScreen> createState() => _NoteNewScreenState();
}

class _NoteNewScreenState extends State<NoteNewScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;

  final DateTime _createdDate = DateTime.now();
  final DateTime _updatedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewmodel>();

    return Scaffold(
      backgroundColor: AppColors.themePrimary,

      appBar: AppBar(
        backgroundColor: AppColors.themeSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ghi Chú Mới",
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: TextButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        bool success = await vm.createNotes(
                          _titleCtrl.text.trim(),
                          _contentCtrl.text.trim(),
                          _createdDate,
                          _updatedAt,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? "Đã Lưu"
                                  : vm.errorMessage ?? "Lưu thất bại",
                            ),
                            backgroundColor: success
                                ? Colors.green
                                : Colors.red,
                          ),
                        );

                        if (success) Navigator.pop(context, true);
                      },
                child: Text(
                  "Lưu",
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.themePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _titleCtrl,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Tiêu đề',
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Date time created
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Tạo lúc: ${DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'vi_VN').format(_createdDate)}",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.themePrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _contentCtrl,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: AppColors.subText,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Hãy nhập gì đó ...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
