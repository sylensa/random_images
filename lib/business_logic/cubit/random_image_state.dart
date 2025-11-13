part of 'random_image_cubit.dart';

abstract class RandomImageState extends Equatable {
  const RandomImageState();

  @override
  List<Object?> get props => [];
}

class RandomImageInitial extends RandomImageState {
  const RandomImageInitial();
}

class RandomImageLoading extends RandomImageState {
  const RandomImageLoading();
}

class RandomImageError extends RandomImageState {
  final String errorMessage;

  const RandomImageError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class RandomImageLoaded extends RandomImageState {
  final String imageUrl;
  final bool isFromCache;

  const RandomImageLoaded({
    required this.imageUrl,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [imageUrl, isFromCache];
}


