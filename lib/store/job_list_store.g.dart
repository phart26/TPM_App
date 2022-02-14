// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$JobListStore on _JobListStore, Store {
  final _$jobsAtom = Atom(name: '_JobListStore.jobs');

  @override
  String get jobs {
    _$jobsAtom.reportRead();
    return super.jobs;
  }

  @override
  set jobs(String value) {
    _$jobsAtom.reportWrite(value, super.jobs, () {
      super.jobs = value;
    });
  }

  final _$_JobListStoreActionController =
      ActionController(name: '_JobListStore');

  @override
  dynamic addJob(String job) {
    final _$actionInfo = _$_JobListStoreActionController.startAction(
        name: '_JobListStore.addJob');
    try {
      return super.addJob(job);
    } finally {
      _$_JobListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
jobs: ${jobs}
    ''';
  }
}
