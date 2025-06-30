import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../features/client/domain/entities/client.dart';
import '../../features/transaction/domain/entities/transaction.dart';
import '../constants/app_strings.dart';

/// Service for generating PDF reports
class PdfService {
  /// Generates a PDF report for client transaction history
  static Future<File> generateClientTransactionReport({
    required Client client,
    required List<Transaction> transactions,
  }) async {
    // Validate inputs
    if (client.name.isEmpty) {
      throw Exception(AppStrings.clientNameCannotBeEmpty);
    }

    if (client.id.isEmpty) {
      throw Exception(AppStrings.clientIdCannotBeEmpty);
    }

    // Create PDF document
    final pdf = pw.Document();

    // Calculate totals with null safety
    int totalReceived = 0;
    int totalPaid = 0;
    for (final tx in transactions) {
      // Validate transaction data
      if (tx.received < 0) {
        throw Exception(AppStrings.invalidReceivedAmount);
      }
      if (tx.paid < 0) {
        throw Exception(AppStrings.invalidPaidAmount);
      }
      totalReceived += tx.received;
      totalPaid += tx.paid;
    }
    final balance = totalReceived - totalPaid;

    // Add pages to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  AppStrings.appName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.Text(
                  AppStrings.transactionReport,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Client Information
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  AppStrings.clientInformation,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('${AppStrings.nameLabel}${client.name}'),
                pw.Text('${AppStrings.idLabel}${client.id}'),
                pw.Text(
                  '${AppStrings.generatedOn}${DateTime.now().toString().split('.').first}',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  AppStrings.transactionSummary,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(AppStrings.totalReceivedLabel),
                    pw.Text(
                      '₹$totalReceived',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(AppStrings.totalPaidLabel),
                    pw.Text(
                      '₹$totalPaid',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      AppStrings.balanceLabel,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      '₹$balance',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: balance >= 0 ? PdfColors.green : PdfColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Transactions Table
          if (transactions.isNotEmpty) ...[
            pw.Text(
              AppStrings.transactionHistory,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
              },
              children: [
                // Table header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        AppStrings.dateAndTimeColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        AppStrings.receivedColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        AppStrings.paidColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Transaction rows
                ...transactions.map(
                  (tx) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '${tx.dateTime.day}/${tx.dateTime.month}/${tx.dateTime.year} '
                          '${tx.dateTime.hour}:${tx.dateTime.minute.toString().padLeft(2, '0')}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          tx.received > 0 ? '₹${tx.received}' : '-',
                          style: const pw.TextStyle(
                            color: PdfColors.green,
                            fontSize: 10,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          tx.paid > 0 ? '₹${tx.paid}' : '-',
                          style: const pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 10,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Center(
                child: pw.Text(
                  AppStrings.noTransactionsFound,
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Footer
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  AppStrings.generatedByApp,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
                pw.Text(
                  '${AppStrings.generatedOn}${DateTime.now().toString().split('.').first}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Get the documents directory
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        '${client.name}_transactions_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Shares the generated PDF file
  static Future<void> sharePdfFile(File pdfFile, String clientName) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: '${AppStrings.shareText}$clientName - Generated by ApniBook App',
      subject: '${AppStrings.shareSubject}$clientName',
    );
  }
}
