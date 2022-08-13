import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/model/photo_model.dart';
import 'package:cypress/app/domain/repository/storage_repository_interface.dart';
import 'package:hive/hive.dart';

class LocalDatabase extends StorageRepositoryInterface{
 Box albumBox = Hive.box("album");
 Box photoBox = Hive.box("photo");
 String albumKey ="photoAlbums";


  @override
  Future<List<AlbumModel>?> getAlbum() async{
    var data = await albumBox.get(albumKey);
    if(data!=null){
      return albumModelFromJson(data);
    }
    return null;

  }

  @override
 Future<List<PhotoModel>?> getPhoto(String id) async{
    var data = await photoBox.get(id);
    if(data!=null){
      return photoModelFromJson(data);
    }
    return null;
  }

  @override
  void storeAlbum(List<AlbumModel> album) {
    var data = albumModelToJson(album);
    albumBox.put(albumKey, data);
  }

  @override
  void storePhoto(List<PhotoModel> photo,String id) {
    var data = photoModelToJson(photo);
    photoBox.put(id, data);
  }






}