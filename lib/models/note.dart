import 'package:flutter/cupertino.dart';
import 'package:flutter_note/database/database_helper.dart';

class Note {
  final String id;
  final String title;
  final String note;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  bool isPinned;

  Note(
      {required this.id,
      required this.title,
      required this.note,
      this.updatedAt,
      this.createdAt,
      this.isPinned = false});

  Note.fromDb(Map<String, dynamic> data)
      : id = data[DatabaseHelper.TABLE_NOTES_ID],
        title = data[DatabaseHelper.TABLE_NOTES_TITLE],
        note = data[DatabaseHelper.TABLE_NOTES_NOTE],
        isPinned = data[DatabaseHelper.TABLE_NOTES_ISPINNED] == 1,
        updatedAt = DateTime.parse(data[DatabaseHelper.TABLE_NOTES_UPDATEDAT]),
        createdAt = DateTime.parse(data[DatabaseHelper.TABLE_NOTES_CREATEDAT]);

  Map<String, dynamic> toDb() {
    return {
      DatabaseHelper.TABLE_NOTES_ID: id,
      DatabaseHelper.TABLE_NOTES_TITLE: title,
      DatabaseHelper.TABLE_NOTES_NOTE: note,
      DatabaseHelper.TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
      DatabaseHelper.TABLE_NOTES_UPDATEDAT: updatedAt!.toIso8601String(),
      DatabaseHelper.TABLE_NOTES_CREATEDAT: createdAt!.toIso8601String(),
    };
  }

  Note copyWith(
      {String? id,
      String? title,
      String? note,
      DateTime? updatedAt,
      DateTime? createdAt,
      bool? isPinned}) {
    return Note(
        id: id == null ? this.id : id,
        title: title == null ? this.title : title,
        note: note == null ? this.note : note,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt,
        createdAt: createdAt == null ? this.createdAt : createdAt,
        isPinned: isPinned == null ? this.isPinned : isPinned);
  }
}
