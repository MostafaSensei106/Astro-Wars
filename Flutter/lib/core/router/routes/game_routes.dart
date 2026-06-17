import 'package:go_router/go_router.dart';
import '../../../../modules/game/presentation/pages/game_page.dart';
import '../routes_names.dart';

final List<RouteBase> gameRoutes = [
  GoRoute(
    path: RoutesNames.game,
    builder: (context, state) => const GamePage(),
  ),
];
