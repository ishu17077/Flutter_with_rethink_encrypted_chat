//@dart = 2.9
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/cache/local_cache.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/sqflite_datasource.dart';
import 'package:flutter_with_rethink_encrypted_app/data/factories/db_factory.dart';
import 'package:flutter_with_rethink_encrypted_app/data/services/image_uploader.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/chats_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message/message_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message_thread/message_thread_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/receipt/receipt_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/typing/typing_notification_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/home/home.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/home/home_router.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/message_thread/message_thread.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/onboarding/onboarding.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/onboarding/onboarding_router.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chat_view_model.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chats_view_model.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'data/datasources/datasource_contract.dart';

class CompositionRoot {
  static Rethinkdb _r;
  static Connection _connection;
  static IUserService _userService;
  static Database _db;
  static IMessageService _messageService;
  static IDatasource _dataSource;
  static ILocalCache _localCache;
  static MessageBloc _messageBloc;
  static TypingNotification _typingNotification;
  static TypingNotificationBloc _typingNotificationBloc;
  static ChatsCubit _chatsCubit;

  static configure() async {
    _r = Rethinkdb();
    _connection = await _r.connect(host: '192.168.2.49', port: 28015);
    _userService = UserService(_r, _connection);
    _db = await LocalDatabaseFactory().createDatabase();
    _messageService = MessageService(_r, _connection);
    _typingNotification = TypingNotification(_r, _connection, _userService);
    _dataSource = SqfliteDatasource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_messageService);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification);
    final viewModel = ChatsViewModel(_dataSource, userService: _userService);
    _chatsCubit = ChatsCubit(viewModel);
    // _db.delete('users');
    // _db.delete('messages');
  }

  static Widget start() {
    final user = _localCache.fetch('USER');
    //? determines the user logged in currently and i logged in composeHomeUi and if not composeOnBoardingUi
    return user.isEmpty
        ? composeOnBoardingUI()
        : composeHomeUi(User.fromJson(user));
  }

  static Widget composeOnBoardingUI() {
    ImageUploader imageUploader =
        ImageUploader('http://192.168.2.49:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, imageUploader, _localCache);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    IOnboardingRouter router = OnboardingRouter(composeHomeUi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Onboarding(router),
    );
  }

  static Widget composeHomeUi(User me) {
    HomeCubit homeCubit = HomeCubit(_userService, _localCache);
    IHomeRouter router = HomeRouter(showMessageThread: composeMessageThreadUi);
    ChatsViewModel viewModel =
        ChatsViewModel(_dataSource, userService: _userService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(create: (BuildContext context) => _messageBloc),
        //? So we can recieve messages in real time
        BlocProvider(create: (BuildContext context) => _chatsCubit),
        BlocProvider(create: (BuildContext context) => _typingNotificationBloc),
      ],
      child: Home(me, router),
    );
  }

  static Widget composeMessageThreadUi(User receiver, User me,
      {String chatId}) {
    ChatViewModel viewModel = ChatViewModel(_dataSource);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    IReceiptService receiptService = ReceiptService(_r, _connection);
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => messageThreadCubit),
          BlocProvider(create: (BuildContext context) => receiptBloc)
        ],
        child: MessageThread(
            receiver, me, _messageBloc, _chatsCubit, _typingNotificationBloc,
            chatId: chatId));
  }
}
