import 'package:scrumpoker/data/remote/dio_client.dart';

abstract class BaseRepository {
  DioClient? dioClient;

  BaseRepository(this.dioClient);
}
