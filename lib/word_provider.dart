import 'package:flutter/widgets.dart';
import 'word_bloc.dart';

class WordProvider extends InheritedWidget {
  WordProvider({Key key, WordBloc wordBloc, Widget child,}) : wordBloc = wordBloc ?? WordBloc(), super(key: key, child: child);

  final WordBloc wordBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static WordBloc of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<WordProvider>().wordBloc;
}
