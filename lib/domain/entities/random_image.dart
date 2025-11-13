import 'package:equatable/equatable.dart';

/// Domain entity - framework agnostic, no Flutter dependencies
class RandomImage extends Equatable {
  final String url;

  const RandomImage({required this.url});

  @override
  List<Object> get props => [url];
}
