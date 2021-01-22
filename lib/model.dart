class CurrencyDTO {

  final bool success;
  final String terms;
  final String privacy;
  final int timestamp;
  final String source;
  final QuotesDTO quotes;

  CurrencyDTO({this.success, this.terms, this.privacy, this.timestamp, this.source, this.quotes});

  factory CurrencyDTO.fromJson(Map<String, dynamic> json) {
    return CurrencyDTO(
        success: json['success'],
        terms: json['terms'],
        privacy: json['privacy'],
        timestamp: json['timestamp'],
        source: json['source'],
        quotes: QuotesDTO.fromJson(json['quotes'])
    );
  }

  @override
  String toString() {
    return 'CurrencyDTO{success: $success, terms: $terms, privacy: $privacy, timestamp: $timestamp, source: $source, quotes: $quotes}';
  }
}

class QuotesDTO {

  final Map<String, num> data;

  QuotesDTO({this.data});

  factory QuotesDTO.fromJson(Map<String, dynamic> json) {
    return QuotesDTO(data: json.cast());
  }

  @override
  String toString() {
    return 'QuotesDTO{data: $data}';
  }
}