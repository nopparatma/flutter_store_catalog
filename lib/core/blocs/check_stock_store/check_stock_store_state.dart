part of 'check_stock_store_bloc.dart';

@immutable
abstract class CheckStockStoreState {}

class InitialCheckStockStoreState extends CheckStockStoreState {
  @override
  String toString() {
    return 'InitialCheckStockStoreState{}';
  }
}

class LoadingCheckStockStoreState extends CheckStockStoreState {
  @override
  String toString() {
    return 'LoadingCheckStockStoreState{}';
  }
}

class ErrorCheckStockStoreState extends CheckStockStoreState {
  final dynamic error;

  ErrorCheckStockStoreState(this.error);

  @override
  String toString() {
    return 'ErrorCheckStockStoreState{error: $error}';
  }
}

class GetStockStoreSuccessState extends CheckStockStoreState {
  final List<StockStores> stockStoreList;
  final bool isThisStoreHaveStock;

  GetStockStoreSuccessState(this.stockStoreList, this.isThisStoreHaveStock);

  @override
  String toString() {
    return 'GetStockStoreSuccessState{stockStoreList: $stockStoreList, isThisStoreHaveStock: $isThisStoreHaveStock}';
  }
}