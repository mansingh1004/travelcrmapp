import '../entities/operations.dart';
import '../entities/operations_enums.dart';

/// One page of the operations board.
class OpsBoardPage {
  const OpsBoardPage({
    required this.rows,
    required this.pageNumber,
    required this.totalElements,
    required this.hasMore,
  });

  final List<OpsBoardRow> rows;
  final int pageNumber;
  final int totalElements;
  final bool hasMore;

  static const empty =
      OpsBoardPage(rows: [], pageNumber: 0, totalElements: 0, hasMore: false);
}

abstract interface class OperationsRepository {
  /// The board. The window defaults to the next fortnight server-side.
  Future<OpsBoardPage> getBoard({
    OpsBoardTab tab,
    DateTime? from,
    DateTime? to,
    String? search,
    int page,
    int size,
  });

  /// Badge counts keyed by tab.
  Future<Map<OpsBoardTab, int>> getTabCounts({
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<OpsSummary> getSummary({DateTime? from, DateTime? to, String? search});

  /// One booking's nine checkpoints and derived severity.
  Future<OpsDetail> getCheckpoints(String bookingPublicId);

  /// Sparse patch — only the named fields change.
  Future<void> updateCheckpoint(
    String checkpointPublicId, {
    OpsCheckpointStatus? status,
    String? vendorName,
    String? referenceNo,
    String? notes,
  });
}
