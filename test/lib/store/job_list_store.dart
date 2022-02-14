import 'package:mobx/mobx.dart';
import 'package:tpmapp/services/preferences_service.dart';
part 'job_list_store.g.dart';

class JobListStore = _JobListStore with _$JobListStore;

abstract class _JobListStore with Store {
  PreferencesService pref;
  _JobListStore(preference) {
    this.pref = preference;
    // jobs = this.pref.jobs;
  }
  @observable
  String jobs = "";

  @action
  addJob(String job) {
    print('new job $job');
    // var tmp = jobs;
    // if (!jobs.contains(job)) tmp.add(job);
    jobs = job;
    // print('job list $jobs');
    // pref.jobs = jobs;
  }
}
