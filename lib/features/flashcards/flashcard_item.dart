import 'package:equatable/equatable.dart';

enum FlashcardType { kanji, word }

class FlashcardItem with EquatableMixin {
  const FlashcardItem({
    required this.frontText,
    required this.backText,
    this.subTextBack,
    required this.type,
  });

  final String frontText;
  final String backText;
  final String? subTextBack;
  final FlashcardType type;

  @override
  List<Object?> get props => [frontText, backText, subTextBack, type];
}
