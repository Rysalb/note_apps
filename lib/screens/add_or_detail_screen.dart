import 'package:flutter/material.dart';
import 'package:flutter_note/models/note.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';

class AddOrDetailScreen extends StatefulWidget {
  static const routeName = '/addOrDetailScreen';
  @override
  State<AddOrDetailScreen> createState() => _AddOrDetailScreenState();
}

class _AddOrDetailScreenState extends State<AddOrDetailScreen> {
  Note _note = Note(
    id: "",
    title: "",
    note: "",
  );

  bool _init = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void submitNote() async {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      _note = _note.copyWith(updatedAt: now, createdAt: now);
      final notesProvider = Provider.of<Notes>(context, listen: false);
      if (_note.id == null) {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tutup'),
                )
              ],
            );
          });
    }

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      String? id = ModalRoute.of(context)!.settings.arguments as String?;
      if (id != null) {
        _note = Provider.of<Notes>(context).getNote(id);
      }
      _init = false;
    }

    super.didChangeDependencies();
  }

  String _convertDate(DateTime dateTime) {
    int diff = DateTime.now().difference(dateTime).inDays;
    if (diff > 0) {
      return DateFormat('dd-mm-yyyy').format(dateTime);
    }
    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: submitNote,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text("Simpan", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _note.title,
                        decoration: InputDecoration(
                            hintText: "Judul", border: InputBorder.none),
                        onSaved: (value) {
                          _note = _note.copyWith(title: value);
                        },
                      ),
                      TextFormField(
                        initialValue: _note.note,
                        decoration: InputDecoration(
                            hintText: "Tulis Catatan disini...",
                            border: InputBorder.none),
                        onSaved: (value) {
                          _note = _note.copyWith(note: value);
                        },
                        maxLines: null,
                      ),
                    ],
                  )),
            ),
          ),
          if (_note.updatedAt != null)
            Positioned(
                bottom: 10,
                right: 10,
                child:
                    Text('Terakhir diubah ${_convertDate(_note.updatedAt!)}'))
        ],
      ),
    );
  }
}
