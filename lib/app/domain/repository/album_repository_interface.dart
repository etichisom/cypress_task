import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/model/photo_model.dart';



abstract class AlbumRepositoryInterface{
  Future<List<AlbumModel>?> getAlbum();
  Future<List<PhotoModel>?> getAlbumPhoto(String id);
}