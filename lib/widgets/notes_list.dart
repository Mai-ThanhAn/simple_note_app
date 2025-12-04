import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_note_app/models/note_model.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';
import 'package:simple_note_app/screens/note_editor_screen.dart';
import 'package:simple_note_app/widgets/note_item.dart';

class NotesList extends StatefulWidget {
  final List<NoteModel> notes;

  const NotesList({super.key, required this.notes});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewmodel>();

    return ListView.separated(
      itemCount: widget.notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 25),
      itemBuilder: (context, index) {
        final note = widget.notes[index];

        return Dismissible(
          key: ValueKey(note.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text("Xóa ghi chú này"),
                content: const Text("Bạn chắc chắn muốn xóa?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      "Xóa",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
            if (confirm != true) return false;

            final success = await vm.deleteNote(note.id);

            if (!context.mounted) return false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? "Đã Xóa" : "Xóa Thất Bại"),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
            return success;
          },
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
              );
            },

            child: NoteItem(
              title: note.title,
              content: note.content,
              date: DateFormat.MMMMEEEEd('vi_VN').format(note.createdAt),
            ),
          ),
        );
      },
    );
  }
}
