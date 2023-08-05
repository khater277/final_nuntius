import 'package:dio/dio.dart';
import 'package:final_nuntius/core/apis/fcm/fcm_api.dart';
import 'package:final_nuntius/core/apis/fcm/fcm_end_points.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/core/network/network_info.dart';
import 'package:final_nuntius/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:final_nuntius/features/chats/data/datasources/chats_remote_data_source.dart';
import 'package:final_nuntius/features/chats/data/repositories/chats_repository.dart';
import 'package:final_nuntius/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/home/data/datasources/home_remote_data_source.dart';
import 'package:final_nuntius/features/home/data/repositories/home_repository.dart';
import 'package:final_nuntius/features/home/data/repositories/home_repository_impl.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository.dart';
import 'package:final_nuntius/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:final_nuntius/features/search/cubit/search_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:final_nuntius/core/apis/agora/agora_api.dart';
import 'package:final_nuntius/core/apis/agora/agora_end_points.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/calls/data/datasources/calls_remote_data_source.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository_impl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../features/chats/cubit/chats_cubit.dart';
import '../features/stories/cubit/stories_cubit.dart';

final di = GetIt.instance;

void setupGetIt() {
  /// CUBITS
  di.registerLazySingleton<AuthCubit>(() => AuthCubit(
        authRepository: di(),
        homeRepository: di(),
      ));
  di.registerLazySingleton<HomeCubit>(() => HomeCubit(
        homeRepository: di(),
        authRepository: di(),
      ));
  di.registerLazySingleton<CallsCubit>(() => CallsCubit(callsRepository: di()));
  di.registerLazySingleton<ChatsCubit>(() => ChatsCubit(chatsRepository: di()));
  di.registerLazySingleton<StoriesCubit>(() => StoriesCubit());
  di.registerLazySingleton<ContactsCubit>(() => ContactsCubit());
  di.registerLazySingleton<MessagesCubit>(() => MessagesCubit(
        messagesRepository: di(),
        authRepository: di(),
      ));
  di.registerLazySingleton<SearchCubit>(() => SearchCubit());

  /// DATASOURCES
  di.registerLazySingleton<CallsRemoteDataSource>(
      () => CallsRemoteDataSourceImpl(
            agoraApi: di(),
          ));
  di.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        firebaseHelper: di(),
      ));
  di.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
        firebaseHelper: di(),
      ));
  di.registerLazySingleton<MessagesRemoteDataSource>(
      () => MessagesRemoteDataSourceImpl(
            firebaseHelper: di(),
            fcmApi: di(),
          ));
  di.registerLazySingleton<ChatsRemoteDataSource>(
      () => ChatsRemoteDataSourceImpl(
            firebaseHelper: di(),
          ));

  /// REPOSITORIES
  di.registerLazySingleton<CallsRepository>(() => CallsRepositoryImpl(
        callsRemoteDataSource: di(),
      ));
  di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: di(),
        networkInfo: di(),
      ));
  di.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        homeRemoteDataSource: di(),
        networkInfo: di(),
      ));
  di.registerLazySingleton<MessagesRepository>(() => MessagesRepositoryImpl(
        messagesRemoteDataSource: di(),
        networkInfo: di(),
      ));
  di.registerLazySingleton<ChatsRepository>(() => ChatsRepositoryImpl(
        chatsRemoteDataSource: di(),
        networkInfo: di(),
      ));

  /// NETWORK INFO
  di.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: di()));
  di.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  /// FIREBASE
  di.registerLazySingleton<FirebaseHelper>(() => FirebaseHelperImpl());

  /// APIS
  di.registerLazySingleton<AgoraApi>(
      () => AgoraApi(di(instanceName: 'agora-dio')));
  di.registerLazySingleton<FcmApi>(() => FcmApi(di(instanceName: 'fcm-dio')));

  /// DIOs
  Dio createAndSetupAgoraDio() {
    Dio dio = Dio();

    dio.options
      ..baseUrl = AgoraEndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..headers = {
        'Content-Type': 'application/json',
      }
      ..connectTimeout = const Duration(seconds: 20)
      ..followRedirects = false;

    dio.interceptors.add(
      LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
          error: true),
    );

    return dio;
  }

  di.registerLazySingleton<Dio>(
    () => createAndSetupAgoraDio(),
    instanceName: 'agora-dio',
  );

  Dio createAndSetupFcmDio() {
    Dio dio = Dio();

    dio.options
      ..baseUrl = FcmEndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..headers = {
        'Content-Type': 'application/json',
        'Authorization':
            "key=AAAAtA396zI:APA91bF7St3PW9Au3T7cuudgMsua-9UUKl9dlyYjngO9m5QcHVz_qLbULTicQ7eBvAOw9bwUYhnm8kj4jHf9yxVK-KEsTI19DF6cayVmCTHXH5cKybobLWy40-ZXdjLh9ZKAzOWx3xM1"
      }
      ..connectTimeout = const Duration(seconds: 20)
      ..followRedirects = false;

    dio.interceptors.add(
      LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
          error: true),
    );

    return dio;
  }

  di.registerLazySingleton<Dio>(
    () => createAndSetupFcmDio(),
    instanceName: 'fcm-dio',
  );
}
