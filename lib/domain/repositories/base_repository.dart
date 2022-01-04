import 'package:SuperNinja/data/remote/dio_client.dart';

abstract class BaseRepository {
  DioClient? dioClient;

  BaseRepository(this.dioClient);
}
