import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/data_provider.dart';
import 'data/repository/category_repository.dart';
import 'data/repository/icons_repository.dart';
import 'data/repository/messages_repository.dart';
import 'data/repository/pages_repository.dart';
import 'filter_screen/filter_screen_cubit.dart';
import 'home_screen/home_screen_cubit.dart';
import 'messages_screen/screen_message_cubit.dart';
import 'router/app_router.dart';
import 'screen_creating_page/screen_creating_page_cubit.dart';
import 'search_messages_screen/search_message_screen_cubit.dart';
import 'settings_screen/chat_interface_setting_cubit.dart';
import 'settings_screen/visual_setting_cubit.dart';
import 'timeline_screen/timeline_screen_cubit.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<PagesAPI>(PagesAPI());
  Bloc.observer = MyBlocObserver();
  runApp(
    MyApp(),
  );
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    print('onCreate -- cubit: ${cubit.runtimeType}');
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    print('onChange -- cubit: ${cubit.runtimeType}, change: $change');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('onError -- cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    print('onClose -- cubit: ${cubit.runtimeType}');
  }
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MessagesRepository>(
          create: (context) => MessagesRepository(
            api: getIt<PagesAPI>(),
          ),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
        RepositoryProvider<IconsRepository>(
          create: (context) => IconsRepository(),
        ),
        RepositoryProvider<PagesRepository>(
          create: (context) => PagesRepository(
            pagesAPI: getIt<PagesAPI>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeScreenCubit(
              repository: RepositoryProvider.of<PagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ScreenMessageCubit(
              time: DateTime.now(),
              repository: RepositoryProvider.of<MessagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => SearchMessageScreenCubit(
              repository: RepositoryProvider.of<MessagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ScreenCreatingPageCubit(
              repository: RepositoryProvider.of<IconsRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ChatInterfaceSettingCubit(),
          ),
          BlocProvider(
            create: (context) => VisualSettingCubit(),
          ),
          BlocProvider(
            create: (context) => TimelineScreenCubit(
              repository: RepositoryProvider.of<MessagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => FilterScreenCubit(
              pagesRepository: RepositoryProvider.of<PagesRepository>(context),
              messagesRepository:
                  RepositoryProvider.of<MessagesRepository>(context),
              categoryRepository:
                  RepositoryProvider.of<CategoryRepository>(context),
            ),
          ),
        ],
        child: BlocBuilder<VisualSettingCubit, VisualSettingState>(
          builder: (context, state) => MaterialApp(
            title: 'Chat Journal',
            theme: ThemeData(
              brightness: state.appBrightness,
              primaryColor: state.appPrimaryColor,
              accentColor: state.appAccentColor,
              fontFamily: state.appFontFamily,
              iconTheme: IconThemeData(
                color: state.iconColor,
              ),
              appBarTheme: AppBarTheme(
                textTheme: TextTheme(
                  headline6: TextStyle(
                    fontSize: state.appBarTitleFontSize,
                  ),
                ),
                centerTitle: true,
              ),
              textTheme: TextTheme(
                subtitle1: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: state.titleFontSize,
                  color: state.titleColor,
                ),
                bodyText2: TextStyle(
                  fontSize: state.bodyFontSize,
                  color: state.bodyColor,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Colors.teal,
                unselectedItemColor: Colors.grey,
              ),
            ),
            onGenerateRoute: _appRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
