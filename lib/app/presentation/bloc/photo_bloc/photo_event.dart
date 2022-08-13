part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();
}

class LoadPhotoEvent extends PhotoEvent{
 final String id;

  const LoadPhotoEvent(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => [id];

}
