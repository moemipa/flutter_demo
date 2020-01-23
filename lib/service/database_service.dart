import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/database_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_demo1/utility/extension.dart';

class DatabaseService {
  static DatabaseService _instance;
  DatabaseService._internal();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseService._internal();
      final DatabaseService instance = _instance;
      instance._getAllRepository()
        .listen((it) => instance.repositories.add(it));
    }
    return _instance;
  }
  factory DatabaseService.getInstance() => _getInstance();

  DatabaseHelper _helper = DatabaseHelper.getInstance();

  final BehaviorSubject<List<Repository>> repositories = BehaviorSubject.seeded([]);

  Stream<List<Repository>> _getAllRepository() => _helper
    .getAllRepository()
    .then((it) => Stream
    .fromIterable(it)
//    .doOnData((it) => log("_getAllRepository: $it"))
    .doOnData((it) => it.isSubscribed.value = true)
    .toList())
    .asStream();

  void add(Repository repository) => Stream
    .fromFuture(_helper.add(repository))
    .flatMap((it) => this._getAllRepository())
    .listen((it) => repositories.add(it));

  void delete(Repository repository) => Stream
    .fromFuture(_helper.delete(repository))
    .flatMap((it) => this._getAllRepository())
    .listen((it) => repositories.add(it));

  void synchronizeSubscription(Repositories repositories) {
    for (Repository repository in repositories.items) {
      for (Repository favouriteRepository in this.repositories.value) {
        repository.isSubscribed.value = repository.id == favouriteRepository.id;
        if (repository.isSubscribed.value) {
          log("synchronizeSubscription: $repository");
          break;
        }
      }
    }
  }

}