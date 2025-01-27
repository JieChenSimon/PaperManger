import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/paper.dart';

class PaperService {
  late Future<Isar> db;

  PaperService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [PaperSchema],
      directory: dir.path,
    );
  }

  Future<List<Paper>> getAllPapers() async {
    final isar = await db;
    return await isar.papers.where().sortByAddedDateDesc().findAll();
  }

  Future<List<Paper>> searchPapers(String query) async {
    final isar = await db;
    return await isar.papers
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .authorsContains(query, caseSensitive: false)
        .or()
        .abstractContains(query, caseSensitive: false)
        .sortByAddedDateDesc()
        .findAll();
  }

  Future<void> addPaper(Paper paper) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.papers.put(paper);
    });
  }

  Future<String?> importPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savedFile = await file.copy('${appDir.path}/papers/$fileName');
      return savedFile.path;
    }
    return null;
  }
} 