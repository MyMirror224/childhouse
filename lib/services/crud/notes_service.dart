// import 'dart:async';

// import 'package:childhouse/extension/list/filter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'notes_exception.dart';

// class NoteService {
//   Database? _db;
//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;
//   static final NoteService _shared = NoteService._sharedInstance();
//   NoteService._sharedInstance() {
//     _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () => _noteStreamController.sink.add(_notes),
//     );
//   }
//   factory NoteService() => _shared;

//   late final StreamController<List<DatabaseNote>> _noteStreamController;

//   Stream<List<DatabaseNote>> get allNotes => _noteStreamController.stream.filter((note){
//     final currentUser = _user;
//     if(currentUser!= null){
//     return note.userId == currentUser.id;
//     } else {
//       throw UserShouldBeSetBeforeReadingAllNotes();
//     }
//   });
//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       await db.execute(createUserTable);
//       await db.execute(createNotesTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }

//   Future<DatabaseUser> getOrCreateUser({required String email,  bool setAsCurrentUser= true}) async {
//     try {
//       final user = await getUser(email: email);
//       if(setAsCurrentUser){
//         _user= user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if(setAsCurrentUser){
//         _user= createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getNoteAll();
//     _notes = allNotes.toList();
//     _noteStreamController.add(_notes);
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatebaseNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     // make sure note exists
//     await getNote(id: note.id);

//     // update DB
//     final updatesCount = await db.update(
//       notesTable,
//       {
//         textColumn: text,
//         isSynceWithCloudColumn: 0,
//       },
//       where: 'id=?',
//       whereArgs: [note.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);

//       return updatedNote;
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatebaseNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<int> deleteNoteAll() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     _notes = [];
//     _noteStreamController.add(_notes);
//     return db.delete(notesTable);
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       notesTable,
//       where: 'id= ?',
//       whereArgs: [id],
//     );
//     if (deleteCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _noteStreamController.add(_notes);
//     }
//   }

//   Future<Iterable<DatabaseNote>> getNoteAll() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(notesTable);
//     _notes = [];

//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   Future<DatabaseNote> getNote({
//     required int id,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       notesTable,
//       limit: 1,
//       where: 'id= ?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _noteStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<DatabaseNote> createNote({
//     required DatabaseUser owner,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     final noteId = await db.insert(notesTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSynceWithCloudColumn: 1,
//     });
//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSynceWithCloud: true,
//     );
//     _notes.add(note);
//     _noteStreamController.add(_notes);
//     return note;
//   }

//   Future<DatabaseUser> createUser({
//     required String email,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email=?',
//       whereArgs: [email.toLowerCase().toString()],
//     );
//     if (result.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//     final userID = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userID,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({
//     required String email,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       userTable,
//       where: 'email=?',
//       whereArgs: [email.toLowerCase().toString()],
//     );
//     if (deleteCount != 1) {
//       throw CouldNotDeletedUser();
//     }
//   }

//   Future<DatabaseUser> getUser({
//     required String email,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db
//         .query(userTable, where: "email=?", whereArgs: [email.toLowerCase()]);
//     if (result.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(result.first);
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//   @override
//   String toString() => 'Person, id= $id, email= $email';
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSynceWithCloud;

//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSynceWithCloud,
//   });
//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSynceWithCloud =
//             (map[isSynceWithCloudColumn] as int) == 1 ? true : false;
//   @override
//   String toString() =>
//       'Note, id= $id, userID= $userId , text=$text, isSynceWithCloud=$isSynceWithCloud';
//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;
//   @override
//   int get hashCode => id.hashCode;
// }

// const userTable = 'user';
// const notesTable = 'notes';
// const dbName = "notes.db";
// const idColumn = "id";
// const emailColumn = "email";
// const userIdColumn = "id_user";
// const textColumn = "text";
// const isSynceWithCloudColumn = "is_synce_with_cloud";
// const createNotesTable = '''CREATE TABLE if not exists"notes" (
// 	"id"	INTEGER NOT NULL,
// 	"id_user"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	"is_synce_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	FOREIGN KEY("id_user") REFERENCES "user"("id"),
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// ''';
// const createUserTable = '''CREATE TABLE if not exists "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// );
// ''';
