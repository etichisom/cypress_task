

import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/model/photo_model.dart';


abstract class StorageRepositoryInterface{
  void storeAlbum(List<AlbumModel> album);
  void storePhoto(List<PhotoModel> photo,String id);
  Future<List<AlbumModel>?>  getAlbum();
  Future<List<PhotoModel>?>  getPhoto(String id);

}