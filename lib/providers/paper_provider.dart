import 'package:flutter/foundation.dart';
import '../models/paper.dart';
import '../services/paper_service.dart';

class PaperProvider extends ChangeNotifier {
  final PaperService _service = PaperService();
  List<Paper> _papers = [];
  Paper? _selectedPaper;
  String _searchQuery = '';

  List<Paper> get papers => _papers;
  Paper? get selectedPaper => _selectedPaper;
  String get searchQuery => _searchQuery;

  Future<void> loadPapers() async {
    _papers = await _service.getAllPapers();
    notifyListeners();
  }

  Future<void> searchPapers(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      await loadPapers();
    } else {
      _papers = await _service.searchPapers(query);
      notifyListeners();
    }
  }

  void selectPaper(Paper paper) {
    _selectedPaper = paper;
    notifyListeners();
  }

  Future<void> importPaper() async {
    final filePath = await _service.importPDFFile();
    if (filePath != null) {
      final paper = Paper(
        title: '新导入的论文',
        filePath: filePath,
        addedDate: DateTime.now(),
      );
      await _service.addPaper(paper);
      await loadPapers();
    }
  }
} 