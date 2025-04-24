class DnsRecords {
  final List<String> a;
  final List<String> mx;
  final List<String> ptr;

  const DnsRecords({
    this.a = const [],
    this.mx = const [],
    this.ptr = const [],
  });

  factory DnsRecords.fromJson(Map<String, dynamic> json) {
    return DnsRecords(
      a: json['a'] != null ? List<String>.from(json['a']) : const [],
      mx: json['mx'] != null ? List<String>.from(json['mx']) : const [],
      ptr: json['ptr'] != null ? List<String>.from(json['ptr']) : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'a': a,
      'mx': mx,
      'ptr': ptr,
    };
  }
}
