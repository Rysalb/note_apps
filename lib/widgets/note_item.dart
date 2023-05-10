import 'package:flutter/material.dart';
import 'package:flutter_note/presentations/custom_icons_icons.dart';
import 'package:flutter_note/screens/add_or_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/notes.dart';

class NoteItem extends StatefulWidget {
  final String? id;
  final BuildContext ctx;
  NoteItem({
    required this.id,
    required this.ctx,
  });
  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  bool? _isPinned;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context, listen: false);
    Note note = notesProvider.getNote(widget.id);

    return Dismissible(
      key: Key(note.id),
      onDismissed: (direction) {
        notesProvider.deleteNote(note.id).catchError((onError) {
          print("Terjadi error");
          ScaffoldMessenger.of(widget.ctx).clearSnackBars();
          ScaffoldMessenger.of(widget.ctx)
              .showSnackBar(SnackBar(content: Text(onError.toString())));
        });
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(AddOrDetailScreen.routeName, arguments: note.id),
        child: GridTile(
          header: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    notesProvider.toggleIsPinned(note.id).catchError((onError) {
                      ScaffoldMessenger.of(widget.ctx).clearSnackBars();
                      ScaffoldMessenger.of(widget.ctx).showSnackBar(
                          SnackBar(content: Text(onError.toString())));
                    });
                  },
                  icon: Icon(
                    note.isPinned ? Custom_icons.pin : Custom_icons.pin_outline,
                  ))),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                color: Colors.cyan[800]),
            child: Text(note.note),
            padding: EdgeInsets.all(12),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(note.title),
            ),
          ),
        ),
      ),
    );
  }
}
