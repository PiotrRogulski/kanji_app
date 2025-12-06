enum FlashcardType { kanji, word }

class FlashcardItem {
  FlashcardItem({
    required this.frontText,
    required this.backText,
    this.subTextBack,
    required this.type,
  });

  final String frontText;
  final String backText;
  final String? subTextBack;
  final FlashcardType type;
}
