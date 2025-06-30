import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions_for_client.dart';

// Events
abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {
  final String clientId;
  LoadTransactions(this.clientId);
}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;
  AddTransactionEvent(this.transaction);
}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;
  DeleteTransactionEvent(this.transactionId);
}

// States
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  TransactionLoaded(this.transactions);
}

class TransactionAdded extends TransactionState {
  final String transactionId;
  TransactionAdded(this.transactionId);
}

class TransactionDeleted extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

/// Bloc for managing transaction state
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsForClient getTransactionsForClient;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionBloc({
    required this.getTransactionsForClient,
    required this.addTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial()) {
    // Handle loading transactions for a client
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactions = await getTransactionsForClient(event.clientId);
        emit(TransactionLoaded(transactions));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    // Handle adding a new transaction
    on<AddTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactionId = await addTransaction(event.transaction);
        emit(TransactionAdded(transactionId));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    // Handle deleting a transaction
    on<DeleteTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        await deleteTransaction(event.transactionId);
        emit(TransactionDeleted());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}
