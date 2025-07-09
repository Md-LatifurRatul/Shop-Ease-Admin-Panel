import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarNavigationCubit extends Cubit<String> {
  SidebarNavigationCubit() : super('/dashboard'); // Set your default route

  void selectRoute(String route) => emit(route);
}
