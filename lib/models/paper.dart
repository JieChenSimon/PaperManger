import 'package:isar/isar.dart';

part 'paper.g.dart';

@collection
class Paper {
  Id id = Isar.autoIncrement;
  
  String title;
  String? authors;
  String? abstract;
  DateTime? publishDate;
  String? filePath;
  String? notes;
  
  @Index()
  final List<String> tags;
  
  @Index()
  final DateTime addedDate;

  Paper({
    required this.title,
    this.authors,
    this.abstract,
    this.publishDate,
    this.filePath,
    this.notes,
    List<String> tags = const [],
    required DateTime addedDate,
  }) : 
    this.tags = tags,
    this.addedDate = addedDate;

  Paper.create({
    required this.title,
    this.authors,
    this.abstract,
    this.publishDate,
    this.filePath,
    this.notes,
    List<String> tags = const [],
  }) : 
    this.tags = tags,
    this.addedDate = DateTime.now();
} 