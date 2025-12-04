import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_note_app/constants.dart';
import 'package:simple_note_app/models/note_model.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel note;

  const NoteEditorScreen({super.key, required this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note.title);
    _contentCtrl = TextEditingController(text: widget.note.content);
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
          "Cập nhật ghi chú",
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

                        final updatedNote = NoteModel(
                          id: widget.note.id,
                          title: _titleCtrl.text.trim(),
                          content: _contentCtrl.text.trim(),
                          createdAt: widget.note.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        final success = await vm.updateNote(updatedNote);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? "Cập nhật thành công"
                                  : "Cập nhật thất bại",
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
                    color: Colors.blue[300],
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
                    hintStyle: TextStyle(color: AppColors.secondaryText),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Date time created
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Tạo lúc: ${DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'vi_VN').format(widget.note.createdAt)}",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Cập nhật lúc: ${DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'vi_VN').format(widget.note.updatedAt)}",
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
                    style: const TextStyle(
                      color: AppColors.subText,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Hãy nhập gì đó ...",
                      hintStyle: TextStyle(color: AppColors.subText),
                    ),
                  ),
                ),
              ),

              // Delete Button
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Xóa ghi chú này"),
                        content: const Text("Bạn chắc chắn muốn xóa?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Xóa"),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    final success = await vm.deleteNote(widget.note.id);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? "Đã Xóa" : "Xóa Thất Bại"),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );

                    if (success) Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
