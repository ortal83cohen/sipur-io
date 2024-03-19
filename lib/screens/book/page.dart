/// text : "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him."
/// picture : "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"

class PageModel {
  String _text;
  String _picture;
  PageModel copyWith({
    String? text,
    String? picture,
  }) =>
      PageModel(
        text ?? _text,
        picture ?? _picture,
      );
  String get text => _text;
  String get picture => _picture;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['picture'] = _picture;
    return map;
  }

  PageModel(this._text, this._picture);

  Map<String, dynamic> toMap() {
    return {
      '_text': this._text,
      '_picture': this._picture,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      map.containsKey('text') ? map['text'] as String : "",
      map.containsKey('picture') ? map['picture'] as String : "",
    );
  }
}
