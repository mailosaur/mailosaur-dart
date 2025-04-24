class MessageAddress {
  String? name;
  String? email;
  String? phone;

  MessageAddress({
    this.name,
    this.email,
    this.phone,
  });

  factory MessageAddress.fromJson(Map<String, dynamic> json) {
    return MessageAddress(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
