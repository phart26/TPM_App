import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tpmapp/screens/device_setup_screen.dart';
import 'package:tpmapp/screens/inspection_user/direct_pack_inspection_screen.dart';
import 'package:tpmapp/screens/inspection_user/form_selection_screen.dart';
import 'package:tpmapp/screens/geoForm/geo_form_selection_screen.dart';
import 'package:tpmapp/screens/job_screen.dart';
import 'package:tpmapp/screens/mill_operator/job_waiting_screen.dart';
import 'package:tpmapp/screens/geoForm/job_screen_geo.dart';
import 'package:tpmapp/screens/mill_operator/login_screen.dart';
import 'package:tpmapp/screens/mill_operator/test_screen.dart';
import 'package:tpmapp/screens/mill_operator/tube_mill_setup_form.dart';
import 'package:tpmapp/screens/mill_operator/welding_checksheet_form.dart';
import 'package:tpmapp/screens/mode_selection.dart';
import 'package:tpmapp/store/job_list_store.dart';
import 'constants/routes_name.dart';
import 'screens/inspection_user/cutoff_station_check_sheet.dart';
import 'screens/geoForm/geo_cutoff_station_check_sheet.dart';
import 'screens/geoForm/geo_inspection_station_check_list.dart';
import 'screens/geoForm/ring_weld_sheet.dart';
import 'screens/geoForm/tube_selection_screen.dart';
import 'screens/geoForm/final_inspection_geo_form.dart';
import 'screens/inspection_user/geo_form_ring_inspection.dart';
import 'screens/inspection_user/inspection_station_check_list.dart';
import 'screens/inspection_user/tack_weld_sheet.dart';
import 'screens/inspection_user/ring_station_check_sheet.dart';
import 'screens/mill_operator/mill_instruction_setup.dart';
import 'screens/mill_operator/part_mfg_form.dart';
import 'screens/stamping/job_screen_stamping.dart';
import 'screens/stamping/press_setup_form.dart';
import 'screens/stamping/die_setup_form.dart';
import 'screens/stamping/cycle_checksheet_form.dart';
import 'screens/steel_receiving/job_screen_steel_receiving.dart';
import 'screens/steel_receiving/coil_select_screen.dart';
import 'screens/mesh_user/job_screen_mesh.dart';
import 'screens/mesh_user/mesh_combo_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  PushNotificationsManager().init();
  final sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp(PreferencesService(sharedPreferences)));
  });
}

class MyApp extends StatelessWidget {
  final PreferencesService _preferencesService;

  const MyApp(this._preferencesService);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesService>(
          create: (_) => _preferencesService,
        ),
        Provider<JobListStore>(
          create: (_) => JobListStore(_preferencesService),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff0d0d26),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: Routes.modeSelection,
        routes: {
          Routes.modeSelection: (_) => Consumer<PreferencesService>(
              builder: (_, pref, __) => ModeSelectionScreen(pref)),
          Routes.jobScreen: (_) => JobScreen(_preferencesService),
          Routes.tubeMillSetupForm: (_) =>
              TubeMillSetupForm(_preferencesService),
          Routes.millInstSetup: (_) => MillInstSetup(),
          Routes.partMfgInfo: (_) => PartMfgFrom(_preferencesService),
          Routes.testScreen: (_) => TestScreen(_preferencesService),
          Routes.weldingForm: (_) => WeldingCheckSheetForm(_preferencesService),
          Routes.loginScreen: (_) => LoginScreen(_preferencesService),
          Routes.cutoffStationCheckSheet: (_) =>
              CutoffStationCheckSheet(_preferencesService),
          Routes.directPackInspection: (_) =>
              DirectPackInspectionScreen(_preferencesService),
          Routes.finalInspectionGeoForm: (_) =>
              FinalInspectionGeoForm(_preferencesService),
          Routes.inspectionStationCheckSheet: (_) =>
              InspectionStationCheckList(_preferencesService),
          Routes.tpmappGeoformRingInspection: (_) =>
              GeoFormRingInspection(_preferencesService),
          Routes.ringStationCheckSheet: (_) =>
              RingStationCheckSheet(_preferencesService),
          Routes.jobWaitingScreen: (_) =>
              Consumer2<PreferencesService, JobListStore>(
                  builder: (_, pref, store, __) =>
                      JobWaitingScreen(pref, store)),
          Routes.formSelectionScreen: (_) =>
              FormSelectionScreen(_preferencesService),
          Routes.deviceSetupScreen: (_) =>
              DeviceSetupScreen(_preferencesService),
          Routes.tackWeldSheet: (_) => TackWeldSheet(_preferencesService),
          Routes.geoInspectionStationCheckSheet: (_) =>
              GeoInspectionStationCheckList(_preferencesService),
          Routes.geoCutoffStationCheckSheet: (_) =>
              GeoCutoffStationCheckSheet(_preferencesService),
          Routes.geoformSelectionScreen: (_) =>
              GeoFormSelectionScreen(_preferencesService),
          Routes.tubeSelectionScreen: (_) =>
              TubeSelectionScreen(_preferencesService),
          Routes.jobScreenGeo: (_) => JobScreenGeo(_preferencesService),
          Routes.ringWeldSheet: (_) => RingWeldSheet(_preferencesService),
          Routes.jobScreenMesh: (_) => MeshJobScreen(_preferencesService),
          Routes.meshComboScreen: (_) => MeshComboScreen(_preferencesService),
          Routes.jobScreenStamping: (_) =>
              Consumer2<PreferencesService, JobListStore>(
                  builder: (_, pref, store, __) =>
                      JobScreenStamping(pref, store)),
          Routes.pressSetupForm: (_) => PressSetupForm(_preferencesService),
          Routes.dieSetupForm: (_) => DieSetupForm(_preferencesService),
          Routes.cycleForm: (_) => CycleCheckSheetForm(_preferencesService),
          Routes.jobScreenSteelReceiving: (_) =>
              JobScreenSteelReceiving(_preferencesService),
          Routes.coilSelectScreen: (_) => CoilSelectScreen(_preferencesService)
        },
      ),
    );
  }
}
