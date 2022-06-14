import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/models/user_model.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/types/data_container.dart';

DataContainer<UserModel> useUserData() {
  final state = useState<DataContainer<UserModel>>(DataContainer.waiting());
  useEffect(() {
    final sub = DataService.getInstance().getUserData().listen((event) {
      state.value = DataContainer(data: event);
    });
    return sub.cancel;
  }, ["_"]);
  return state.value;
}
