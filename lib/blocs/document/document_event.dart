import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/dtos/document/document.dart';

abstract class DocumentEvent extends BlocEvent {
  DocumentEvent();
}

class LoadDocumentInfoEvent extends DocumentEvent {
  final DocumentInfo documentInfo;
  LoadDocumentInfoEvent(this.documentInfo);
}

class DeleteDocumentEvent extends DocumentEvent {
  final DocumentInfo documentInfo;
  DeleteDocumentEvent(this.documentInfo);
}

class SaveDocumentEvent extends DocumentEvent {
  final String fileName;
  final int item;
  SaveDocumentEvent(this.fileName, this.item);
}
