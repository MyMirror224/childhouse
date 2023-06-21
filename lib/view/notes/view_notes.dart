import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';
import 'package:childhouse/services/cloud/cloud_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../contains/route.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/firebase_cloud_storage.dart';

import '../../utilities/dialogs/logout_dialog.dart';
import 'list_note_view.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    
                    final showLogout = await showLogOutDialog(context);
                    if (showLogout) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(const AuthEventLogout());
                    }
                }
              },
              itemBuilder: ((context) {
                return const [
                  PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text("Log out"),
                  )
                ];
              }),
            )
          ],
        ),
        body: StreamBuilder(
          stream: _noteService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allnote = snapshot.data as Iterable<CloudNote>;
                  return ListNoteView(
                    notes: allnote,
                    onDeleteNote: (note) async {
                      await _noteService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
