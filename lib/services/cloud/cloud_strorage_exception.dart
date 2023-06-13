
class CloudStorageException implements Exception{
  const CloudStorageException();
}
class CouldNotDeleteNoteException  extends CloudStorageException{
}

class CouldNotUpdateNoteException extends CloudStorageException {}
class CouldNotGetAllNotesException extends CloudStorageException {}