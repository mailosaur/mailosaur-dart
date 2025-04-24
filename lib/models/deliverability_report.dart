import 'block_list_result.dart';
import 'content.dart';
import 'dns_records.dart';
import 'email_authentication_result.dart';
import 'spam_assassin_result.dart';

class DeliverabilityReport {
  final EmailAuthenticationResult spf;
  final List<EmailAuthenticationResult> dkim;
  final EmailAuthenticationResult dmarc;
  final List<BlockListResult> blockLists;
  final Content content;
  final DnsRecords dnsRecords;
  final SpamAssassinResult spamAssassin;

  const DeliverabilityReport({
    required this.spf,
    required this.dkim,
    required this.dmarc,
    required this.blockLists,
    required this.content,
    required this.dnsRecords,
    required this.spamAssassin,
  });

  factory DeliverabilityReport.fromJson(Map<String, dynamic> json) {
    return DeliverabilityReport(
      spf: EmailAuthenticationResult.fromJson(json['spf']),
      dkim: List<EmailAuthenticationResult>.from(
          json['dkim'].map((item) => EmailAuthenticationResult.fromJson(item))),
      dmarc: EmailAuthenticationResult.fromJson(json['dmarc']),
      blockLists: List<BlockListResult>.from(
          json['blockLists'].map((item) => BlockListResult.fromJson(item))),
      content: Content.fromJson(json['content']),
      dnsRecords: DnsRecords.fromJson(json['dnsRecords']),
      spamAssassin: SpamAssassinResult.fromJson(json['spamAssassin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spf': spf.toJson(),
      'dkim': dkim.map((item) => item.toJson()).toList(),
      'dmarc': dmarc.toJson(),
      'blockLists': blockLists.map((item) => item.toJson()).toList(),
      'content': content.toJson(),
      'dnsRecords': dnsRecords.toJson(),
      'spamAssassin': spamAssassin.toJson(),
    };
  }
}
