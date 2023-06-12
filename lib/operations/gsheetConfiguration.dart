import 'package:gsheets/gsheets.dart';

class AttendanceAPI {

  static const credentials = r''' 
{
  "type": "service_account",
  "project_id": "orthocare-373306",
  "private_key_id": "e47c6ca0d5ab838ae3ae0800cfe6f09eb05445df",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCxVgc1gjWYALvZ\nsA0ma5jlVsFUeWyB/AVl004SH+Pt/leszHngEkWWliP+SB89soCJg6B5BMlcMadL\ns/G3FAbmOVXlf7RHDRvEBA2a+E+Un/WrnsVYsyTHW63CM+81hn3OzyXM2q5UVAKv\nrmvS/0incXA6Kk22CHdCsnssGaeq/rT+YRmXNs+R5Mlv4pqxZaX7pm4JcxAyijKZ\ninBURgpFyFw7nbU3G5gyiZNN5gGMy1vCRiQRdTIEBMoLy8jLK+V7ztuHX18eovMf\nEv3caxbPgO4BE2IJwBZfSxjUbncM5XkFxi/evTzRwZIeT6eKrSBxNaPfl/IHjyJ5\nzs1OAIapAgMBAAECggEABUVsvQQQBoLavUQ4xy11K8z96GjxvHU4A7BfHoC3la46\nSjBA8lPXYRwOTsDIpUd3lLmBRROgY3bfiuDQNKb6CQYc2zpmFWNqpxNlRE0w+rac\nrB4nLiVTY1XNQYu/EVDcT2VJfFA8P2oIsz2R+4FmgMFUFWCG8zwcxRJj1k+JaWFb\nG5AEePdQyIZr4VlNiJ76McnmT9UVEt6P897AEc69sDQUbHvRX674hc31CP1ZalXP\nXjIqHMkW3EPegs2jp2X/vIoMUxqg6DCdL//VPj4ujc0ctA5kr2vr3dl4SV75JAok\nyfvmYiLRafjLi6XauFDi8OkoxN40JpQPVYE94zP+IQKBgQD2A+9t1CztwMalhAEU\nUUKUXHSVqWbWmJvhNcKVCS8gGkmOJAnK5cMjKAKA1eQmMfXldZ2IKKqTr9trQz7c\nf3LZyB65jq0fEPph0Cl+GmQcOsMGrlz0Wtj8p0QRyAd80/QCJAcV3VrJDoqfUi70\nzf/9zx3OnoK9EuZUJxK8WCBjYQKBgQC4iIZD9p/ixMa397TABBzlDGouZiO6RHdw\nYo4MP5abHBng+BPuac8Y0s+L0JFwbN5ASDJ+NJR062v8/oJRJUfTZDX5T8qnR/F8\nU8ySkUm5vGP+cNfPCTr7PTASMLWmKkDPy0QrlTGEDBQBpjCKPTZt3fHJdMw/alLt\nbUw1b2IwSQKBgQCdLzx+Ts96BO6m+CV8ZsMEaeIvcXH8cLs/9IpjkN+kQkd24v3C\nvnSkdL7MtFy2LruupSxGv7zk6bpm2StD1MZ78Un4QvnH3KAteMPaB2CpTL4o+aT4\nl0cGfpSWS9jE3+OKrpw8UxbbWUgmrWrFDQ2fjAK+bjaYOYgigmiNID1pYQKBgCdf\n+kZGOZeJpV1b3ZWbSw8UtxNvd/Am69VvMiAq8Vfnhx4Z0SbuLOJ/GQocVuxGTqYo\nwZ1sWsEX+tLg+62U5t6UY2/vNq67CywcNWqQ1cpsCGoiaeojbhJt2/QFsLzkBzBP\njxw9mXMzoJE5hOH6bcLDuPPjmDFv3oIK8Ff2jF0BAoGBAMysP6JC0acc8OYndkYs\n8qKPaF5W4RrYg45DfqeXK8ZiROhGg+iuI/9imQIutE1+mAR1vygi8yn+fLZgukhX\nXoCFN/I2cxNrBi3F6RRlxRBsZU7krHZcL+66peVqIHE//OiPVg8w4ylhRh5P3RMD\n+f5hgZnqnrLBuvSpYr4hzV66\n-----END PRIVATE KEY-----\n",
  "client_email": "orthocare@orthocare-373306.iam.gserviceaccount.com",
  "client_id": "103291155697119856271",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/orthocare%40orthocare-373306.iam.gserviceaccount.com"
}



''';
  static final spreadSheetId = '1yYTpxNKurx5my0dpGz_GjzAhwqT5N_5n3oT9_76FonY';
  final attspreadsheet = gsheets.spreadsheet(spreadSheetId);
  static final gsheets = GSheets(credentials);
  static Worksheet? attendanceSheet;

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}
