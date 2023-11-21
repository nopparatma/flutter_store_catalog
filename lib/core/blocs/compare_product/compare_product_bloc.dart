import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';

part 'compare_product_event.dart';
part 'compare_product_state.dart';

class CompareProductBloc extends Bloc<CompareProductEvent, CompareProductState> {
  @override
  CompareProductState get initialState => CompareProductState([]);

  @override
  Stream<CompareProductState> mapEventToState(CompareProductEvent event) async* {
    if (event is AddProductCompareEvent) {
      yield* mapEventAddProductCompareEvent(event);
    } else if (event is RemoveProductCompareEvent) {
      yield* mapEventRemoveProductCompareEvent(event);
    } else if (event is RemoveAllProductCompareEvent) {
      yield* mapEventRemoveAllProductCompareEvent(event);
    }
  }

  Stream<CompareProductState> mapEventAddProductCompareEvent(AddProductCompareEvent event) async* {
    List<ArticleList> articleList = List.from(state.articleList);
    articleList.add(event.article);

    yield CompareProductState(articleList);
  }

  Stream<CompareProductState> mapEventRemoveProductCompareEvent(RemoveProductCompareEvent event) async* {
    List<ArticleList> articleList = List.from(state.articleList);
    articleList.removeAt(event.index);

    yield CompareProductState(articleList);
  }

  Stream<CompareProductState> mapEventRemoveAllProductCompareEvent(RemoveAllProductCompareEvent event) async* {
    yield CompareProductState([]);
  }
}
