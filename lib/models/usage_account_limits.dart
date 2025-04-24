import 'usage_account_limit.dart';

class UsageAccountLimits {
  UsageAccountLimit servers;
  UsageAccountLimit users;
  UsageAccountLimit email;
  UsageAccountLimit sms;

  UsageAccountLimits({
    this.servers = const UsageAccountLimit(),
    this.users = const UsageAccountLimit(),
    this.email = const UsageAccountLimit(),
    this.sms = const UsageAccountLimit(),
  });

  factory UsageAccountLimits.fromJson(Map<String, dynamic> json) {
    return UsageAccountLimits(
      servers: UsageAccountLimit.fromJson(json['servers']),
      users: UsageAccountLimit.fromJson(json['users']),
      email: UsageAccountLimit.fromJson(json['email']),
      sms: UsageAccountLimit.fromJson(json['sms'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servers': servers?.toJson(),
      'users': users?.toJson(),
      'email': email?.toJson(),
      'sms': sms?.toJson(),
    };
  }
}
