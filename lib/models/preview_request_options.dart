class PreviewRequestOptions {
  List<String>? emailClients;

  PreviewRequestOptions({
    this.emailClients,
  });

  factory PreviewRequestOptions.fromJson(Map<String, dynamic> json) {
    return PreviewRequestOptions(
      emailClients: json['emailClients'] != null
          ? List<String>.from(json['emailClients'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailClients': emailClients,
    };
  }
}
