class RandomImage {
  final String url;

  const RandomImage({required this.url});

  factory RandomImage.fromJson(Map<String, dynamic> json) {
    return RandomImage(url: json['url'] as String);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RandomImage &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'RandomImage(url: $url)';
}
