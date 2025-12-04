import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:simple_note_app/constants.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';
import 'package:simple_note_app/widgets/notes_list.dart';
import 'package:simple_note_app/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteViewmodel>().loadNotes();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewmodel>();
    final notes = vm.notes;
    final now = DateTime.now();
    final formattedDate = DateFormat.MMMMEEEEd('vi_VN').format(now);

    return Scaffold(
      backgroundColor: AppColors.themePrimary,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/newNote");
        },
        backgroundColor: AppColors.themeSecondary,
        child: const Text(
          "+",
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text('Lỗi: ${vm.errorMessage}'))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: notes.isEmpty
                          ? Column(
                              children: [
                                SearchBarWidget(),
                                SizedBox(height: 20),
                                Text(
                                  'Chưa có ghi chú nào',
                                  style: TextStyle(color: AppColors.secondaryText),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SearchBarWidget(),
                                SizedBox(height: 20),
                                Expanded(child: NotesList(notes: notes)),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
