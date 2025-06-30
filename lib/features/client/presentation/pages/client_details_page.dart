import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../transaction/presentation/bloc/transaction_bloc.dart';
import '../../../transaction/presentation/pages/add_transaction_page.dart';
import '../../domain/entities/client.dart';

class ClientDetailsPage extends StatefulWidget {
  final Client client;
  const ClientDetailsPage({super.key, required this.client});

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load transactions for this client when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionBloc>().add(LoadTransactions(widget.client.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ClientDetailsContent(client: widget.client);
  }
}

class _ClientDetailsContent extends StatefulWidget {
  final Client client;
  const _ClientDetailsContent({required this.client});

  @override
  State<_ClientDetailsContent> createState() => _ClientDetailsContentState();
}

class _ClientDetailsContentState extends State<_ClientDetailsContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header with avatar and name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 24),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                // Center content
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: context.iconSize,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: context.iconSize * 2,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.client.name,
                        style: AppTheme.headline.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                // Empty space to balance the back button
                SizedBox(width: context.iconSize * 2),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Transaction list
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionAdded) {
                  // Refresh the transaction list after adding
                  context.read<TransactionBloc>().add(
                    LoadTransactions(widget.client.id),
                  );
                } else if (state is TransactionDeleted) {
                  // Refresh the transaction list after deleting
                  context.read<TransactionBloc>().add(
                    LoadTransactions(widget.client.id),
                  );
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  final transactions = state.transactions;
                  int totalReceived = 0;
                  int totalPaid = 0;
                  for (final tx in transactions) {
                    totalReceived += tx.received;
                    totalPaid += tx.paid;
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.pagePadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryCard(
                              title: AppStrings.totalReceived,
                              value: totalReceived.toString(),
                              valueColor: AppTheme.primaryColor,
                            ),
                            _SummaryCard(
                              title: AppStrings.totalPaid,
                              value: totalPaid.toString(),
                              valueColor: Colors.red,
                            ),
                            _SummaryCard(
                              title: AppStrings.youWillGet,
                              value: (totalReceived - totalPaid).toString(),
                              valueColor: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: transactions.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      AppStrings.noTransactionsYet,
                                      style: AppTheme.body.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppStrings.addFirstTransactionMessage,
                                      style: AppTheme.caption.copyWith(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final tx = transactions[index];
                                  final isPaid = tx.paid > 0;
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: context.pagePadding,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? const Color(0xFFFFF0F0)
                                          : const Color(0xFFF0FFF0),
                                      borderRadius: BorderRadius.circular(
                                        context.cardRadius,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              '${tx.dateTime.day} ${_monthName(tx.dateTime.month)} ${tx.dateTime.year} - '
                                              '${tx.dateTime.hour}:${tx.dateTime.minute.toString().padLeft(2, '0')} ${tx.dateTime.hour >= 12 ? AppStrings.pm : AppStrings.am}',
                                              style: AppTheme.caption.copyWith(
                                                color: AppTheme.textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              tx.received.toString(),
                                              style: const TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              tx.paid.toString(),
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                } else if (state is TransactionError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.errorLoadingTransactions,
                          style: AppTheme.body.copyWith(
                            color: Colors.red[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: AppTheme.caption.copyWith(
                            color: Colors.red[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TransactionBloc>().add(
                              LoadTransactions(widget.client.id),
                            );
                          },
                          child: const Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      // Bottom bar with PAID/RECEIVED buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.pagePadding,
          vertical: 10,
        ),
        color: AppTheme.backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _navigateToAddTransaction(context, AppStrings.paid),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.cardRadius),
                  ),
                ),
                child: Text(
                  AppStrings.paid,
                  style: AppTheme.body.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _navigateToAddTransaction(context, AppStrings.received),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.cardRadius),
                  ),
                ),
                child: Text(
                  AppStrings.received,
                  style: AppTheme.body.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // PDF Download Button
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: () => _downloadPdf(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.cardRadius),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: context.iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
      // Properly positioned FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTransaction(context, null),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white, size: context.iconSize),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  void _navigateToAddTransaction(
    BuildContext context,
    String? transactionType,
  ) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransactionPage(
          client: widget.client,
          preSelectedType: transactionType,
        ),
      ),
    );

    if (result == true) {
      // Transaction was added successfully, the bloc listener will handle refresh
    }
  }

  void _downloadPdf(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Get current transaction state with null check
      final transactionBloc = context.read<TransactionBloc>();

      final transactionState = transactionBloc.state;

      if (transactionState is TransactionLoaded) {
        // Check if transactions list is not null
        if (transactionState.transactions.isEmpty) {
          // Close loading dialog
          if (mounted) {
            Navigator.of(context).pop();

            // Show message for empty transactions
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.noTransactionsToExport),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }

        // Generate PDF
        final pdfFile = await PdfService.generateClientTransactionReport(
          client: widget.client,
          transactions: transactionState.transactions,
        );

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Show success dialog with options
          _showPdfSuccessDialog(context, pdfFile);
        }
      } else if (transactionState is TransactionLoading) {
        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Show message to wait
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.pleaseWaitForTransactions),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (transactionState is TransactionError) {
        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.errorGeneratingPdf}${transactionState.message}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Show error if transactions not loaded
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.noTransactionDataAvailable),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        debugPrint('PDF generation error: ${e.toString()}');

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.errorGeneratingPdf}${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showPdfSuccessDialog(BuildContext context, File pdfFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.pdfGeneratedSuccessfully),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppStrings.fileSavedTo}${pdfFile.path}'),
              const SizedBox(height: 16),
              const Text(AppStrings.whatWouldYouLikeToDo),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.pdfSavedToDevice),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(AppStrings.ok),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await PdfService.sharePdfFile(pdfFile, widget.client.name);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${AppStrings.errorSharingPdf}${e.toString()}',
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.share),
              label: const Text(AppStrings.share),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Summary card widget
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: valueColor, width: 1.5),
          borderRadius: BorderRadius.circular(context.cardRadius),
        ),
        child: Column(
          children: [
            Text(
              title.replaceAll('\\n', '\n'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
