import 'package:cleancity/data/model/history/HistoryResponse.dart';
import 'package:cleancity/data/services/HistoryService.dart';
import 'package:logger/logger.dart';

class HistoryViewModel{
  final HistoryService service = HistoryService();
  final logger = Logger();

  Future<List<HistoryResponse>> fetchHistory() async{
    final history =await service.fetchHistory();
    return history;
  }
}