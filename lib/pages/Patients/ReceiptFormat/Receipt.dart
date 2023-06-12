import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:jiffy/jiffy.dart';

import '../../../model/receipt.dart';

class GenerateDonatorVersionDonationPdf {
  ReceiptModel receiptData;
  bool flag;
  GenerateDonatorVersionDonationPdf(this.receiptData, this.flag);

  Future<void> generateInvoice(ReceiptModel billFormat) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 0, 255)));
    page.graphics.drawImage(PdfBitmap(await _readImageData('doct.jpg')),
        Rect.fromLTWH(3, 2, pageSize.width - 450, 70));
    // print(pageSize.width - 420);
    // page.graphics.drawImage(PdfBitmap(await _readImageData('raghavendra.jpg')),
    //     Rect.fromLTWH(435, 2, pageSize.width - 437, 110));
    // page.graphics.drawImage(PdfBitmap(await _readImageData('image23.png')),
    //     Rect.fromLTWH(pageSize.width - 130, pageSize.height - 50, 0, 0));
    //Generate PDF grid.
    // final PdfGrid grid = getGrid(billFormat);
    //Draw the header section by creating text element

    final PdfLayoutResult result = drawHeader(page, pageSize, billFormat);
    //Draw grid
    // drawGrid(page, grid, result, billFormat);
    //Add invoice footer
    drawFooter(page, pageSize, billFormat);
    //Save the PDF document
    final List<int> bytes = await document.save();
    //Dispose the document.
    final directory = await getExternalStorageDirectory();

//Get directory path
    final path = directory!.path;

//Create an empty file to write PDF data
    print('$path/${billFormat.petientName}.pdf');
    File file = File('$path/${billFormat.petientName}.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    if (flag) {
      OpenFile.open('$path/${billFormat.petientName}.pdf');
    }
    document.dispose();
    //Save and launch the file.
  }

//Draws the invoice header
  PdfLayoutResult drawHeader(
      PdfPage page, Size pageSize, ReceiptModel billFormat) {
    // page.graphics.drawRectangle(
    //     bounds: Rect.fromLTWH(3, 2, pageSize.width - 400, 110),
    //     brush: PdfSolidBrush(PdfColor(255, 255, 255)));
    //Draw rectangle

    //Draw string
    print("done");
    page.graphics.drawString(
        'ORTHOCARE PHYSIOTHERAPY CLINIC & REHABILITATION CENTER ',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(70, 0, pageSize.width - 65, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        '(ORTHOCARE PHYSIOTHERPY CLINIC & PATHOLOGY CENTRE)',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(100, 10, pageSize.width - 95, 40),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    // page.graphics.drawRectangle(
    //     bounds: Rect.fromLTWH(398, 1, pageSize.width - 398, 110),
    //     brush: PdfSolidBrush(PdfColor(255, 255, 255)));
    // page.graphics.drawString('C/o. Satyadhyana Vidyapeetha',
    //     PdfStandardFont(PdfFontFamily.helvetica, 16),
    //     brush: PdfBrushes.black,
    //     bounds: Rect.fromLTWH(150, 33, pageSize.width - 95, 40),
    //     format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawString(
        'Shnop np .10 & 11, B-Wing, Patils Heritages,S. N. Road , Near Tambe Nagar',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(110, 28, pageSize.width - 95, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        'Below Rai Nursing Home, Next to Bank of India ,Mulund(W),Mumbai-400 080',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(110, 35, pageSize.width - 95, 40),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        '----------------------------------------------------------------------------------www.physioclinic.co.in---------------------------------------------------------------------------------',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 50, pageSize.width, 40),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    // page.graphics.drawString(
    //   'Seller GST Number  :',
    //   PdfStandardFont(PdfFontFamily.helvetica, 10),
    //   bounds: Rect.fromLTWH(400, 40, pageSize.width - 370, 40),
    //   brush: PdfBrushes.white,
    // );

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 14);
    //Draw string
    // page.graphics.drawString('Amount', contentFont,
    //     brush: PdfBrushes.white,
    //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
    //     format: PdfStringFormat(
    //         alignment: PdfTextAlignment.center,
    //         lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat('dd-MMMM-yyyy');
    final String invoiceNumber = 'Date: ${format.format(DateTime.now())} ';
    final Size contentSize = contentFont.measureString(invoiceNumber);

    // ignore: leading_newlines_in_multiline_strings
    String billingAddress = '''Sr. No. : ${billFormat.id}''';
    final Size contentSize1 = contentFont.measureString(billingAddress);
    String donatorDetail = '';

    page.graphics.drawString(
        'Paitient Name   : ${receiptData.petientName}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(30, 150, pageSize.width - 65, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        'Mode Of Payment   :  ${receiptData.modeOfPayment} ',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(30, 210, pageSize.width - 65, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString('Treatement mode   :  ${receiptData.therepy}  ',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(30, 240, pageSize.width - 65, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 380, pageSize.width, 40),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        '*********************************************************************************************************************************************************************',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 390, pageSize.width, 40),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        'Received a sum of Rupees:  ${receiptData.amount} /-',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(30, 420, pageSize.width - 65, 30),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        ' Brought to you by Blue Horizon Automation Research Pvt Ltd. www.bhar.co.in',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfBrushes.blue,
        bounds: Rect.fromLTWH(80, 755, pageSize.width - 110, 0),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    // if (billFormat.paymentMethod == 'Cash') {
    //   donatorDetail =
    //       '''Received with thanks from ${billFormat.nameBeginner}. ${billFormat.donatorName}  The sum of Rs.${billFormat.totalAmount}/- ${(NumberToWord().convert('en-in', int.parse(billFormat.totalAmount)))} by ${billFormat.paymentMethod} for the Following Seva/s''';
    // } else if (billFormat.paymentMethod == 'Cheque') {
    //   donatorDetail =
    //       '''Received with thanks from ${billFormat.nameBeginner}. ${billFormat.donatorName}  The sum of Rs..${billFormat.totalAmount} /- (${(NumberToWord().convert('en-in', int.parse(billFormat.totalAmount)))}) by  ${billFormat.paymentMethod}  No.${billFormat.chequeNumber}  Dated ${billFormat.chequeDate}  Drawn on ${billFormat.chequeDrawnDate} for the Following Seva/s''';
    // }
    // if (billFormat.paymentMethod == 'Online') {
    //   donatorDetail =
    //   '''Received with thanks from ${billFormat.nameBeginner}. ${billFormat.donatorName}  Gotram ${billFormat.gotramName} Nakshatram ${billFormat.nakshatramName} a sum of Rs.${billFormat.totalAmount}/- ${(NumberToWord().convert('en-in', int.parse(billFormat.totalAmount)))} by ${billFormat.paymentMethod} UTR Number :- ${billFormat.UTRNumber} for the Following Seva/s''';
    // }else {
    //   donatorDetail =
    //       '''Received with thanks from ${billFormat.nameBeginner}. ${billFormat.donatorName}  The sum of Rs..${billFormat.totalAmount} /- ( Rupees ${(NumberToWord().convert('en-in', int.parse(billFormat.totalAmount)))} only ) by  ${billFormat.paymentMethod}  for the Following Seva/s''';
    // }

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: billingAddress, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;

    // PdfTextElement(text: "", font: contentFont).draw(
    //    page: page,
    //    bounds: Rect.fromLTWH(
    //        30, 150, pageSize.width - 65, pageSize.height - 120))!;
  }

//Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result,
      ReceiptModel billFormat) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(30, result.bounds.bottom + 40,
            page.getClientSize().width - 60, 0))!;

    //Draw grand total.
    // page.graphics.drawString(getTotalAmount(grid).toString(),
    //     PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         totalPriceCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         totalPriceCellBounds!.width,
    //         totalPriceCellBounds!.height));
  }

//Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize, ReceiptModel billFormat) async {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 150),
        Offset(pageSize.width, pageSize.height - 150));
    const String forSignature =
        // ignore: leading_newlines_in_multiline_strings
        '''Dr. Venkatramesh S. Achari''';

    //Added 30 as a margin for the layout

    String contactNumber =
        // ignore: leading_newlines_in_multiline_strings
        '''Dr. Venkatramesh S. Achari
           M.P.Th.., MIAP
           Consultant Physiotherapist
           Reg. No. 7606
           OT/PT COUNCIL : PR-2017/03/PT/005776
         ''';
    page.graphics.drawString(
        contactNumber, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(20, pageSize.height - 110, 0, 0));

    //PdfImage image = PdfBitmap.fromBase64String('https://lh3.googleusercontent.com/kgUyX94vv3b3R4oFZNrGP3aprm2741c1GQDI8e1SPJGNDxAlyml-k6bmvfgksjM=w600');

//Draws the image to the PDF page
    //Save the docuemnt

    //page.graphics.drawImage(image, Rect.fromLTWH(176, 0, 390, 130));
    //Added 30 as a margin for the layout

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        forSignature, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));

    page.graphics.drawString(
        contactNumber, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(20, pageSize.height - 110, 0, 0));
    String blueHorizonName =
        ''' This app is conceputalised and coded by Blue Horizon Automation Research Pvt Ltd. www.bhar.co.in''';
  }

//Create PDF grid and return
  PdfGrid getGrid(ReceiptModel billFormat) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 3);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(0, 0, 0));
    headerRow.style.textBrush = PdfBrushes.black;
    headerRow.cells[0].value = 'Sr number';
    headerRow.cells[1].value = 'Particulars';
    headerRow.cells[2].value = 'Amount';
    int sr = 0;
    // billFormat..map((e) {
    //   addProducts(++sr, e.donationTypeName, e.donationTypeAmount, grid);
    // }).toList();
    //   var total = double.parse(
    //       (int.parse(e.itemQty) * int.parse(e.itemPrice)).toString());
    //   var discountAmount =
    //   double.parse((double.parse(e.discount) / 100 * total).toString());
    //   var grossTotal = double.parse((total - discountAmount).toString());
    //   var gstAmount =
    //   double.parse((double.parse(e.gstRate) / 100 * grossTotal).toString());
    //   var netTotal = double.parse((grossTotal + gstAmount).toString());
    //   addProducts(
    //       1,
    //       e.itemBarcodeReading,
    //       e.itemName,
    //       e.itemBatchNo,
    //       e.itemHSNCode,
    //       e.itemUOM,
    //       int.parse(e.itemQty),
    //       double.parse(e.itemPrice),
    //       double.parse(e.discount),
    //       grossTotal,
    //       e.gstType,
    //       e.gstRate,
    //       gstAmount,
    //       netTotal,
    //       grid);
    // }).toList();
    //Add rows
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[0].width = 70;
    grid.columns[1].width = 230;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 4, right: 4, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

//Create and row for the grid.
  void addProducts(
      int srNo, String budgetName, String budgetAmount, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = srNo.toString();
    row.cells[1].value = budgetName;
    row.cells[2].value = budgetAmount;
  }

//Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final double value =
          double.parse(grid.rows[i].cells[grid.columns.count - 1].value);
      total += value;
    }
    return total;
  }

  double getTotalGrossAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final double value =
          double.parse(grid.rows[i].cells[grid.columns.count - 5].value);
      total += value;
    }
    return total;
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
