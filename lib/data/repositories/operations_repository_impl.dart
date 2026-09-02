import '../../domain/entities/operations.dart';
import '../../domain/entities/operations_enums.dart';
import '../../domain/repositories/operations_repository.dart';
import '../mappers/operations_mapper.dart';
import '../services/operations_api.dart';

class OperationsRepositoryImpl implements OperationsRepository {
  const OperationsRepositoryImpl(this._api);

  final OperationsApi _api;

  @override
  Future<OpsBoardPage> getBoard({
    OpsBoardTab tab = OpsBoardTab.all,
    DateTime? from,
    DateTime? to,
    String? search,
    int page = 0,
    int size = 25,
  }) async {
    final envelope = await _api.getBoard(
      tab: tab.wire,
      from: from,
      to: to,
      search: search,
      page: page,
      size: size,
    );

    return OpsBoardPage(
      rows: envelope.content
          .map(OperationsMapper.toBoardRow)
          .where((r) => r.bookingId.isNotEmpty)
          .toList(growable: false),
      pageNumber: envelope.pageNumber,
      totalElements: envelope.totalElements,
      hasMore: envelope.hasMore,
    );
  }

  @override
  Future<Map<OpsBoardTab, int>> getTabCounts({
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    final raw = await _api.getTabCounts(from: from, to: to, search: search);
    final counts = <OpsBoardTab, int>{};
    for (final tab in OpsBoardTab.values) {
      final value = raw[tab.wire];
      if (value != null) counts[tab] = value;
    }
    return counts;
  }

  @override
  Future<OpsSummary> getSummary({DateTime? from, DateTime? to, String? search}) async =>
      OperationsMapper.toSummary(
        await _api.getSummary(from: from, to: to, search: search),
      );

  @override
  Future<OpsDetail> getCheckpoints(String bookingPublicId) async =>
      OperationsMapper.toDetail(await _api.getCheckpoints(bookingPublicId));

  @override
  Future<void> updateCheckpoint(
    String checkpointPublicId, {
    OpsCheckpointStatus? status,
    String? vendorName,
    String? referenceNo,
    String? notes,
  }) =>
      _api.updateCheckpoint(
        checkpointPublicId,
        status: status?.wire,
        vendorName: vendorName,
        referenceNo: referenceNo,
        notes: notes,
      );
}
