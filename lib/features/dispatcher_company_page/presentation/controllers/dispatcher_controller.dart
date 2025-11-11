
import '../../models/dispatcher_model.dart';

class DispatcherController {
  List<Dispatcher> dispatchers = [
    Dispatcher(
      id: 1,
      name: "Karim benz",
      mobile: "+8985784374",
    ),
    Dispatcher(
      id: 2,
      name: "Karim benz",
      mobile: "+8985784374",
    ),
    Dispatcher(
      id: 3,
      name: "Karim benz",
      mobile: "+8985784374",
    ),
  ];

  Future<List<Dispatcher>> fetchDispatchers() async {
    await Future.delayed(Duration(seconds: 1));
    return dispatchers;
  }

  Future<void> addDispatcher(Dispatcher newDispatcher) async {
    dispatchers.add(newDispatcher);
  }

  Future<void> removeDispatcher(int dispatcherId) async {
    dispatchers.removeWhere((dispatcher) => dispatcher.id == dispatcherId);
  }
}