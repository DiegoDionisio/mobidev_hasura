String compressGraphqlQuery(String query) =>
    GraphqlQueryCompressor.instance(query);

enum _CharType {
  letter,
  endOfWord,
  space,
  symbolThatDoesNotNeedSpace,
}

class GraphqlQueryCompressor {
  static final instance = GraphqlQueryCompressor._();

  final _symbolsThatDoNotNeedSpace = ["{", "}", "(", ")", ":", ",", "."]
      .map((e) => e.runes.first)
      .toList(growable: false);
  final _whiteSpace =
      [" ", "\t", "\n", "\r"].map((e) => e.runes.first).toList(growable: false);
  final _stringCharCode = "\"".runes.first;
  final _spaceCharCode = " ".runes.first;
  final _commentCharCode = "#".runes.first;
  final _newLineCharCode = "\n".runes.first;

  GraphqlQueryCompressor._();

  factory GraphqlQueryCompressor() => instance;

  bool _isLetter(int code) =>
      !_symbolsThatDoNotNeedSpace.contains(code) && !_whiteSpace.contains(code);

  bool _isWhiteSpace(int code) => _whiteSpace.contains(code);

  bool _isSymbolThatDoesNotNeedSpace(int code) =>
      _symbolsThatDoNotNeedSpace.contains(code);

  /// [call] compress a query, eliminating unwanted characters
  String call(String query) {
    final output = <int>[];
    _CharType lastReadChar = _CharType.space;

    bool isInsideAString = false;
    bool isInsideAComment = false;

    for (final code in query.runes) {
      if (isInsideAString) {
        if (code == _stringCharCode) {
          isInsideAString = false;
        }
        output.add(code);
        continue;
      }
      if (code == _stringCharCode) {
        isInsideAString = true;
        output.add(code);
        continue;
      }
      if (isInsideAComment) {
        if (code == _newLineCharCode) {
          isInsideAComment = false;
        }
        continue;
      }
      if (code == _commentCharCode) {
        isInsideAComment = true;
        continue;
      }

      if (!_isLetter(code) && lastReadChar == _CharType.letter) {
        lastReadChar = _CharType.endOfWord;
      }

      if (_isWhiteSpace(code)) {
        continue;
      }
      if (_isSymbolThatDoesNotNeedSpace(code)) {
        output.add(code);
        lastReadChar = _CharType.symbolThatDoesNotNeedSpace;
        continue;
      }
      if (_isLetter(code)) {
        if (lastReadChar == _CharType.endOfWord) {
          output.add(_spaceCharCode);
        }
        output.add(code);
        lastReadChar = _CharType.letter;
        continue;
      }
    }
    return String.fromCharCodes(output);
  }
}
