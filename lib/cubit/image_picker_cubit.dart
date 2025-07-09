import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<Uint8List?> {
  ImagePickerCubit() : super(null);

  void setImage(Uint8List? bytes) => emit(bytes);
  void clearImage() => emit(null);
}
