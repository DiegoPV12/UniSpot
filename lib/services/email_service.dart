import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static String _host = 'smtp.office365.com';
  static int _port = 587; 
  static String _username = 'tbp6000372@est.univalle.edu'; 
  static String _password = 'PTBscz2210'; 

  static Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final smtpServer = SmtpServer(
      _host,
      port: _port,
      username: _username,
      password: _password,
      ignoreBadCertificate: true, 
    );

    final message = Message()
      ..from = Address(_username)
      ..recipients.add(to)
      ..subject = subject
      ..text = body;

    try {
      await send(message, smtpServer);
      print('Correo enviado a $to');
    } on MailerException catch (e) {
      print('Error al enviar correo: $e');
    }
  }
}
