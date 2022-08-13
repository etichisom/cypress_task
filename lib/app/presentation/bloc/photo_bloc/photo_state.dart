part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();
}

class PhotoInitial extends PhotoState {
  @override
  List<Object> get props => [];
}


class PhotoLoaded extends PhotoState{
 final  List<PhotoModel> photoModel;

  const PhotoLoaded(this.photoModel);

  @override
  List<Object?> get props => [photoModel];

}

class PhotoError extends PhotoState{
  final String error;

  const PhotoError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];

}