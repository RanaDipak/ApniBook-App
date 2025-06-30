import '../../../features/client/data/datasources/client_firebase_data_source.dart';
import '../../../features/client/data/repositories/client_repository_impl.dart';
import '../../../features/client/domain/repositories/client_repository.dart';
import '../../../features/client/domain/usecases/add_client.dart';
import '../../../features/client/domain/usecases/delete_client.dart';
import '../../../features/client/domain/usecases/get_clients.dart';
import '../../../features/client/domain/usecases/search_clients.dart';
import '../../../features/client/domain/usecases/update_client.dart';
import '../../../features/stock/data/datasources/stock_firebase_data_source.dart';
import '../../../features/stock/data/repositories/stock_repository_impl.dart';
import '../../../features/stock/domain/repositories/stock_repository.dart';
import '../../../features/stock/domain/usecases/add_stock.dart';
import '../../../features/stock/domain/usecases/delete_stock.dart';
import '../../../features/stock/domain/usecases/get_stocks.dart';
import '../../../features/stock/domain/usecases/get_total_inventory_value.dart';
import '../../../features/stock/domain/usecases/update_stock.dart';
import '../../../features/stock/presentation/bloc/stock_bloc.dart';
import '../../../features/transaction/data/datasources/transaction_firebase_data_source.dart';
import '../../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../../features/transaction/domain/usecases/add_transaction.dart';
import '../../../features/transaction/domain/usecases/delete_transaction.dart';
import '../../../features/transaction/domain/usecases/get_transactions_for_client.dart';
import '../../../features/transaction/presentation/bloc/transaction_bloc.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Initialize service locator
  Future<void> init() async {
    // No initialization needed for Firebase-based features
  }

  // Data sources
  late final ClientFirebaseDataSource _clientFirebaseDataSource =
      ClientFirebaseDataSource();

  late final StockFirebaseDataSource _stockFirebaseDataSource =
      StockFirebaseDataSource();

  late final TransactionFirebaseDataSource _transactionFirebaseDataSource =
      TransactionFirebaseDataSource();

  // Repositories
  late final ClientRepository _clientRepository = ClientRepositoryImpl(
    firebaseDataSource: _clientFirebaseDataSource,
  );

  late final StockRepository _stockRepository = StockRepositoryImpl(
    firebaseDataSource: _stockFirebaseDataSource,
  );

  late final TransactionRepository _transactionRepository =
      TransactionRepositoryImpl(
        firebaseDataSource: _transactionFirebaseDataSource,
      );

  // Use cases
  late final AddClient _addClient = AddClient(_clientRepository);
  late final UpdateClient _updateClient = UpdateClient(_clientRepository);
  late final DeleteClient _deleteClient = DeleteClient(_clientRepository);
  late final GetClients _getClients = GetClients(_clientRepository);
  late final SearchClients _searchClients = SearchClients(_clientRepository);

  late final GetStocks _getStocks = GetStocks(_stockRepository);
  late final AddStock _addStock = AddStock(_stockRepository);
  late final UpdateStock _updateStock = UpdateStock(_stockRepository);
  late final DeleteStock _deleteStock = DeleteStock(_stockRepository);
  late final GetTotalInventoryValue _getTotalInventoryValue =
      GetTotalInventoryValue(_stockRepository);

  late final GetTransactionsForClient _getTransactionsForClient =
      GetTransactionsForClient(_transactionRepository);
  late final AddTransaction _addTransaction = AddTransaction(
    _transactionRepository,
  );
  late final DeleteTransaction _deleteTransaction = DeleteTransaction(
    _transactionRepository,
  );

  // Blocs
  late final StockBloc _stockBloc = StockBloc(
    getStocks: _getStocks,
    addStock: _addStock,
    updateStock: _updateStock,
    deleteStock: _deleteStock,
    getTotalInventoryValue: _getTotalInventoryValue,
  );

  late final TransactionBloc _transactionBloc = TransactionBloc(
    getTransactionsForClient: _getTransactionsForClient,
    addTransaction: _addTransaction,
    deleteTransaction: _deleteTransaction,
  );

  // Getters
  AddClient get addClient => _addClient;
  UpdateClient get updateClient => _updateClient;
  DeleteClient get deleteClient => _deleteClient;
  GetClients get getClients => _getClients;
  SearchClients get searchClients => _searchClients;

  GetStocks get getStocks => _getStocks;
  AddStock get addStock => _addStock;
  UpdateStock get updateStock => _updateStock;
  DeleteStock get deleteStock => _deleteStock;
  GetTotalInventoryValue get getTotalInventoryValue => _getTotalInventoryValue;

  GetTransactionsForClient get getTransactionsForClient =>
      _getTransactionsForClient;
  AddTransaction get addTransaction => _addTransaction;
  DeleteTransaction get deleteTransaction => _deleteTransaction;

  StockBloc get stockBloc => _stockBloc;
  TransactionBloc get transactionBloc => _transactionBloc;

  // Method to create fresh TransactionBloc instances
  TransactionBloc createTransactionBloc() {
    return TransactionBloc(
      getTransactionsForClient: _getTransactionsForClient,
      addTransaction: _addTransaction,
      deleteTransaction: _deleteTransaction,
    );
  }

  // Repository getters
  ClientRepository get clientRepository => _clientRepository;
  StockRepository get stockRepository => _stockRepository;
  TransactionRepository get transactionRepository => _transactionRepository;
}

// Global service locator instance
final serviceLocator = ServiceLocator();
