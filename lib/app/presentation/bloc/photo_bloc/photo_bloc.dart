
import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/model/photo_model.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final AlbumRepository albumRepository;
  final LocalDatabase localDatabase;

  PhotoBloc({
    required this.albumRepository,
    required this.localDatabase
  }) : super(PhotoInitial()) {
    on<LoadPhotoEvent>((event, emit) async{
       var data = await localDatabase.getPhoto(event.id);
       if(data !=null){
         emit(PhotoLoaded(data));
       }else{
        await loadPhotoFromApi(event,emit);
       }
    });
  }

  Future<void> loadPhotoFromApi(LoadPhotoEvent event, Emitter<PhotoState> emit) async {
    try{
      var data = await albumRepository.getAlbumPhoto(event.id);
      if(data!=null){
        localDatabase.storePhoto(data, event.id);
        emit(PhotoLoaded(data));
      }
    }catch(e){
      emit(const PhotoError("something went wrong"));
    }
  }
}
