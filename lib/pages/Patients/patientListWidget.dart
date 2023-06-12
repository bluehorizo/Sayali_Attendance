import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:googlesheet/model/inTimeEntry.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:googlesheet/operations/patientOperation.dart';
import 'package:googlesheet/pages/Patients/createDiagnosisMainPage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mailto/mailto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../operations/authOperations.dart';
import '../../operations/inTimePatientOperation.dart';
import '../../operations/receiptOperation.dart';
import 'ReceiptFormat/Receipt.dart';

class PatietListWidget extends StatelessWidget {
  late final PatientModel patientModel;
  late final ReceiptModel receiptModel;
  FlutterTts flutterTts = FlutterTts();
  int id;
  PatietListWidget({required this.receiptModel, required this.id});
  @override
  Widget build(BuildContext context) {
    openwhatsapp(PatientModel patientModel) async {
      var msg = '''Namaste ${patientModel.patient_name},

    Thank you for your generous contribution to Temple. We are pleased to have your support. Through your donation we have been able to work on good cause. You truly make the difference for us, and we are extremely grateful!

    ''';
      var whatsapp = '+91${patientModel.patient_mobile_number}';
      var whatsappURl_android =
          "whatsapp://send?phone=" + whatsapp + "&text=$msg";
      var whatappURL_ios =
          "https://wa.me/$whatsapp?text=${Uri.parse("Thanks For Donation")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappURL_ios)) {
          await launch(whatappURL_ios, forceSafariVC: false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunch(whatsappURl_android)) {
          await launch(whatsappURl_android);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("whatsapp no installed")));
        }
      }
    }

    final scaffold = Scaffold.of(context);
    return ListTile(
      tileColor: Colors.green.shade50,
      style: ListTileStyle.list,
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(receiptModel.id.toString()),
      ),
      title: Text.rich(TextSpan(
          text: ' Patient Name:- ',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
          children: <InlineSpan>[
            TextSpan(
                text: '${receiptModel.petientName}',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
          ])),
      subtitle: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: <Widget>[
                TextButton.icon(
                  label: Text(
                    "Open Receipt",
                    style: TextStyle(color: Colors.red),
                  ),
                  icon:
                      const Icon(Icons.picture_as_pdf_sharp, color: Colors.red),
                  onPressed: () async {
                    await GenerateDonatorVersionDonationPdf(
                            Provider.of<RceiptOperation>(context, listen: false)
                                .receiptsData[id],
                            true)
                        .generateInvoice(
                            Provider.of<RceiptOperation>(context, listen: false)
                                .receiptsData[id]);
                    // educationBillFormat.donation = [];
                    // UsersSheetsApi.donationDetailList.map((e) {
                    //   if (educationBillFormat.srNumber == e.invoiceNumber) {
                    //     educationBillFormat.donation.add(DonationType(
                    //         id: e.id,
                    //         donationTypeName: e.donationName,
                    //         donationTypeAmount: e.donationAmount,
                    //         donationTypeDate: e.donationDate));
                    //   }
                    // }).toList();
                    // GenerateDonatorVersionDonationPdf(educationBillFormat, true)
                    //     .generateInvoice(educationBillFormat);
                  },
                ),
                IconButton(
                  icon: Icon(MdiIcons.shareAll),
                  onPressed: () async {
                    var msg = '''Namaste ${receiptModel.petientName},

    Thank you for your generous contribution to Temple. We are pleased to have your support. Through your donation we have been able to work on good cause. You truly make the difference for us, and we are extremely grateful!

    ''';

                    GenerateDonatorVersionDonationPdf(receiptModel, false)
                        .generateInvoice(receiptModel);
                    final directory = await getExternalStorageDirectory();

//Get directory path
                    final path = directory!.path;
                    Share.shareFiles(['$path/${receiptModel.petientName}.pdf'],
                        text: msg);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static textMe(PatientModel educationBillFormat) async {
    // Android
    var msg = '''Namaste ${educationBillFormat.patient_name},



    Sincerely,
    ''';
    var uri = 'sms:+91${educationBillFormat.patient_mobile_number} ?body=$msg';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:0039-222-060-888?body=$msg';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  launchMailto(PatientModel patientModel) async {
    var msg = '''Namaste ${patientModel.patient_name},

  

    Sincerely,
    ''';

    final Email email = Email(
      body: msg,
      subject: 'Thanks for donation',
      recipients: ['${patientModel.email}'],
      // attachmentPaths: ['$path/${educationBillFormat.srNumber}.pdf'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
