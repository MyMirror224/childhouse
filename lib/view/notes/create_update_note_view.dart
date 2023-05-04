import 'package:childhouse/services/auth/auth_service.dart';
import 'package:childhouse/services/crud/notes_service.dart';
import 'package:childhouse/utilities/generic/get_agument.dart';
import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NoteService _notesService;
  late final TextEditingController _textController;
  @override
  void initState() {
    _notesService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }
  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_setupTextControllerListener);
  }
  Future<DatabaseNote> createOrGetExistNote() async{
      final widgetNote = context.getArgument<DatabaseNote>();
      if(widgetNote != null){
        _note = widgetNote;
        _textController.text = widgetNote.text;
        return widgetNote;
      }
      final exitedNote= _note;
      if(exitedNote != null){
        return exitedNote;
      }
      final currentUser= AuthService.firebase().currentUser!;
      final email= currentUser.email!;
      final owner = await _notesService.getUser(email: email);
      final newNote= await _notesService.createNote(owner: owner);
      _note= newNote;
      return newNote;
  }
  void _deleteNoteIfTextEmpty(){
      final note= _note;
      if(_textController.text.isEmpty && note != null){
        _notesService.deleteNote(id: note.id);
      }
  }
  void _saveNoteIfTextNotEmpty() async {
      final note= _note;
      final text = _textController.text;
      if(text.isNotEmpty && note !=null){
        await _notesService.updateNote(note: note, text: text);
      }
  }
  @override
  void dispose() {
    _deleteNoteIfTextEmpty();
    _saveNoteIfTextNotEmpty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder(
        future: createOrGetExistNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return  TextField(
                controller: _textController,
                keyboardType:  TextInputType.multiline,
                maxLines: null,
                decoration:const  InputDecoration(hintText: 'Start typing your note...'),
              );
            default:
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
