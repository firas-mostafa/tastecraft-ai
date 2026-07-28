// ignore_for_file: must_be_immutable

part of 'index_cubit.dart';

class IndexState extends Equatable {
  final int indexValue;

  const IndexState(this.indexValue);

  @override
  List<int> get props => [indexValue];
}
