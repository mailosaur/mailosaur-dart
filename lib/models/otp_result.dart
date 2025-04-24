class OtpResult {
  final String code;
  final String expires;

  const OtpResult({
    this.code = '',
    this.expires = '',
  });

  factory OtpResult.fromJson(Map<String, dynamic> json) {
    return OtpResult(
      code: json['code'] ?? '',
      expires: json['expires'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'expires': expires,
    };
  }
}
