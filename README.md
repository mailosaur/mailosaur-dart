# [Mailosaur - Dart library](https://mailosaur.com/) &middot; [![](https://github.com/mailosaur/mailosaur-dart/workflows/CI/badge.svg)](https://github.com/mailosaur/mailosaur-dart/actions)

Mailosaur lets you automate email and SMS tests as part of software development and QA.

- **Unlimited test email addresses for all** - every account gives users an unlimited number of test email addresses to test with.
- **End-to-end (e2e) email and SMS testing** Allowing you to set up end-to-end tests for password reset emails, account verification processes and MFA/one-time passcodes sent via text message.
- **Fake SMTP servers** Mailosaur also provides dummy SMTP servers to test with; allowing you to catch email in staging environments - preventing email being sent to customers by mistake.

## Get Started

This guide provides several key sections:

- [Mailosaur - Dart library · ](#mailosaur---dart-library--)
  - [Get Started](#get-started)
    - [Installation](#installation)
    - [API Reference](#api-reference)
  - [Creating an account](#creating-an-account)
  - [Test email addresses with Mailosaur](#test-email-addresses-with-mailosaur)
  - [Find an email](#find-an-email)
    - [What is this code doing?](#what-is-this-code-doing)
    - [My email wasn't found](#my-email-wasnt-found)
  - [Find an SMS message](#find-an-sms-message)
  - [Testing plain text content](#testing-plain-text-content)
    - [Extracting verification codes from plain text](#extracting-verification-codes-from-plain-text)
  - [Testing HTML content](#testing-html-content)
  - [Working with hyperlinks](#working-with-hyperlinks)
    - [Links in plain text (including SMS messages)](#links-in-plain-text-including-sms-messages)
  - [Working with attachments](#working-with-attachments)
    - [Writing an attachment to disk](#writing-an-attachment-to-disk)
  - [Working with images and web beacons](#working-with-images-and-web-beacons)
    - [Remotely-hosted images](#remotely-hosted-images)
    - [Triggering web beacons](#triggering-web-beacons)
  - [Spam checking](#spam-checking)
  - [Development](#development)
  - [Contacting us](#contacting-us)

You can find the full [Mailosaur documentation](https://mailosaur.com/docs/) on the website.

If you get stuck, just contact us at support@mailosaur.com.

### Installation

```
dart pub add mailosaur
```

Then import the library into your code. The value for `YOUR_API_KEY` is covered in the next step ([creating an account](#creating-an-account)):

```dart
import 'package:mailosaur/mailosaur.dart';

final mailosaur = MailosaurClient("YOUR_API_KEY");
```

### API Reference

This library is powered by the Mailosaur [email & SMS testing API](https://mailosaur.com/docs/api/). You can easily check out the API itself by looking at our [API reference documentation](https://mailosaur.com/docs/api/) or via our Postman or Insomnia collections:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/6961255-6cc72dff-f576-451a-9023-b82dec84f95d?action=collection%2Ffork&collection-url=entityId%3D6961255-6cc72dff-f576-451a-9023-b82dec84f95d%26entityType%3Dcollection%26workspaceId%3D386a4af1-4293-4197-8f40-0eb49f831325)
[![Run in Insomnia}](https://insomnia.rest/images/run.svg)](https://insomnia.rest/run/?label=Mailosaur&uri=https%3A%2F%2Fmailosaur.com%2Finsomnia.json)

## Creating an account

Create a [free trial account](https://mailosaur.com/app/signup) for Mailosaur via the website.

Once you have this, navigate to the [API tab](https://mailosaur.com/app/project/api) to find the following values:

- **Server ID** - Servers act like projects, which group your tests together. You need this ID whenever you interact with a server via the API.
- **Server Domain** - Every server has its own domain name. You'll need this to send email to your server.
- **API Key** - You can create an API key per server (recommended), or an account-level API key to use across your whole account. [Learn more about API keys](https://mailosaur.com/docs/managing-your-account/api-keys/).

## Test email addresses with Mailosaur

Mailosaur gives you an **unlimited number of test email addresses** - with no setup or coding required!

Here's how it works:

- When you create an account, you are given a server.
- Every server has its own **Server Domain** name (e.g. `abc123.mailosaur.net`)
- Any email address that ends with `@{YOUR_SERVER_DOMAIN}` will work with Mailosaur without any special setup. For example:
  - `build-423@abc123.mailosaur.net`
  - `john.smith@abc123.mailosaur.net`
  - `rAnDoM63423@abc123.mailosaur.net`
- You can create more servers when you need them. Each one will have its own domain name.

**\*Can't use test email addresses?** You can also [use SMTP to test email](https://mailosaur.com/docs/email-testing/sending-to-mailosaur/#sending-via-smtp). By connecting your product or website to Mailosaur via SMTP, Mailosaur will catch all email your application sends, regardless of the email address.\*

## Find an email

In automated tests you will want to wait for a new email to arrive. This library makes that easy with the `messages.get` method. Here's how you use it:

```dart
final client = MailosaurClient("YOUR_API_KEY");
var serverId = "abc123";

var criteria = SearchCriteria(sentTo: "test@abc123.mailosaur.net");
var email = await mailosaur.messages.get(serverId, criteria);

print("Email subject: ${email.subject}"); // "Hello world!"
```

### What is this code doing?

1. Sets up an instance of `MailosaurClient` with your API key.
2. Waits for an email to arrive at the server with ID `abc123`.
3. Outputs the subject line of the email.

### My email wasn't found

First, check that the email you sent is visible in the [Mailosaur Dashboard](https://mailosaur.com/api/project/messages).

If it is, the likely reason is that by default, `messages.get` only searches emails received by Mailosaur in the last 1 hour. You can override this behavior (see the `receivedAfter` option below), however we only recommend doing this during setup, as your tests will generally run faster with the default settings:

```dart
var email = await mailosaur.messages.get(
  serverId,
  searchCriteria,
  // Override receivedAfter to search all messages since Jan 1st
  receivedAfter: DateTime(2021, 01, 01).millisecondsSinceEpoch
);
```

## Find an SMS message

**Important:** Trial accounts do not automatically have SMS access. Please contact our support team to enable a trial of SMS functionality.

If your account has [SMS testing](https://mailosaur.com/sms-testing/) enabled, you can reserve phone numbers to test with, then use the Mailosaur API in a very similar way to when testing email:

```dart
final client = MailosaurClient("YOUR_API_KEY");
var serverId = "abc123";

var criteria = SearchCriteria(sentTo: "+1234567890");
var email = await mailosaur.messages.get(serverId, criteria);

print("SMS content: ${sms.text.body}");
```

## Testing plain text content

Most emails, and all SMS messages, should have a plain text body. Mailosaur exposes this content via the `text.body` property on an email or SMS message:

```dart
print(message.text.body); // "Hi Jason, ..."

if (message.text.body.contains('Jason')) {
  print('Email contains "Jason"');
}
```

### Extracting verification codes from plain text

You may have an email or SMS message that contains an account verification code, or some other one-time passcode. You can extract content like this using a simple regex.

Here is how to extract a 6-digit numeric code:

```dart
print(message.text.body);  // "Your access code is 243546."

RegExp regEx = RegExp(r'([0-9]{6})');
Match? match = regEx.firstMatch(message.text.body);

if (match != null) {
  print(match.group(0)); // "243546"
}
```

[Read more](https://mailosaur.com/docs/test-cases/text-content/)

## Testing HTML content

Most emails also have an HTML body, as well as the plain text content. You can access HTML content in a very similar way to plain text:

```dart
print(message.html.body); // "<html><head ..."
```

[Read more](https://mailosaur.com/docs/test-cases/html-content/)

## Working with hyperlinks

When an email is sent with an HTML body, Mailosaur automatically extracts any hyperlinks found within anchor (`<a>`) and area (`<area>`) elements and makes these viable via the `html.links` array.

Each link has a text property, representing the display text of the hyperlink within the body, and an href property containing the target URL:

```dart
// How many links?
print(message.html.links.length); // 2

var firstLink = message.html.links[0];
print(firstLink.text); // "Google Search"
print(firstLink.href); // "https://www.google.com/"
```

**Important:** To ensure you always have valid emails. Mailosaur only extracts links that have been correctly marked up with `<a>` or `<area>` tags.

### Links in plain text (including SMS messages)

Mailosaur auto-detects links in plain text content too, which is especially useful for SMS testing:

```dart
// How many links?
print(message.text.links.length); // 2

var firstLink = message.text.links[0];
print(firstLink.href); // "https://www.google.com/"
```

## Working with attachments

If your email includes attachments, you can access these via the `attachments` property:

```dart
// How many attachments?
print(message.attachments.length); // 2
```

Each attachment contains metadata on the file name and content type:

```dart
var firstAttachment = message.attachments[0];
print(firstAttachment.fileName); // "contract.pdf"
print(firstAttachment.contentType); // "application/pdf"
```

The `length` property returns the size of the attached file (in bytes):

```dart
var firstAttachment = message.attachments[0];
print(firstAttachment.length); // 4028
```

### Writing an attachment to disk

```dart
import 'dart:io';
import 'dart:typed_data';

// ...

var firstAttachment = message.attachments[1];

Uint8List fileBytes = await mailosaur.files.getAttachment(firstAttachment.id);

final file = File(firstAttachment.fileName);
await file.writeAsBytes(fileBytes);
```

## Working with images and web beacons

The `html.images` property of a message contains an array of images found within the HTML content of an email. The length of this array corresponds to the number of images found within an email:

```dart
// How many images in the email?
print(message.html.images.length); // 1
```

### Remotely-hosted images

Emails will often contain many images that are hosted elsewhere, such as on your website or product. It is recommended to check that these images are accessible by your recipients.

All images should have an alternative text description, which can be checked using the `alt` attribute.

```dart
var image = message.html.images[0];
print(image.alt); // "Hot air balloon"
```

### Triggering web beacons

A web beacon is a small image that can be used to track whether an email has been opened by a recipient.

Because a web beacon is simply another form of remotely-hosted image, you can use the `src` attribute to perform an HTTP request to that address:

```dart
import 'package:http/http.dart' as http;

// ...

var image = message.html.images[0];
print(image.src); // "https://example.com/s.png?abc123"

// Make an HTTP call to trigger the web beacon
var response = await http.get(Uri.parse(image.src));
print(response.statusCode); // 200
```

## Spam checking

You can perform a [SpamAssassin](https://spamassassin.apache.org/) check against an email. The structure returned matches the [spam test object](https://mailosaur.com/docs/api/#spam):

```dart
var result = await mailosaur.analysis.spam(message.id);

print(result.score); // 0.5

for (final r in result.spamFilterResults.spamAssassin) {
  print(r.rule);
  print(r.description);
  print(r.score);
}
```

## Development

Install all development dependencies:

```sh
dart pub get
```

The test suite requires the following environment variables to be set:

```sh
export MAILOSAUR_BASE_URL=https://mailosaur.com/
export MAILOSAUR_API_KEY=your_api_key
export MAILOSAUR_SERVER=server_id
```

Run all tests:

```sh
dart test
```

Lint code:

```sh
dart analyze
```

## Contacting us

You can get us at [support@mailosaur.com](mailto:support@mailosaur.com)
