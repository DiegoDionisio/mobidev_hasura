extension JsonMapUtils<K, V> on Map<String, dynamic> {
  String xToHasura() {
    return '{${_mapToHasura(this).join(',')}}';
  }

  List<String> _mapToHasura(Map<String, dynamic> map) {
    var tmp = map.entries;
    List<String> fields = [];
    for (var entry in tmp) {
      if(entry.value is String) {
        fields.add('${entry.key}: "${entry.value}"');
      } else if(entry.value is Map) {
        var tmpFields = _mapToHasura(entry.value).join(',');
        fields.add('${entry.key}: {$tmpFields}');
      } else {
        fields.add('${entry.key}: ${entry.value}');
      }
    }
    return fields;
  }
}