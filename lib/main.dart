import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:smarthealth_app/splash_screen.dart';
import 'package:smarthealth_app/login_page.dart';
import 'package:smarthealth_app/patient/home_page.dart';
import 'package:smarthealth_app/doctor/doctor_home_page.dart';
import 'package:smarthealth_app/doctor/update_medical_folder.dart';
import 'package:smarthealth_app/doctor/add_suivi_sante.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 12 taille référence
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          theme: ThemeData(
            primaryColor: const Color(0xFF4A90E2),
            scaffoldBackgroundColor: const Color(0xFFF8F7FC),

            // ✨ Fonts globales (Poppins)
            textTheme: GoogleFonts.poppinsTextTheme(),

            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF4A90E2),
              centerTitle: true,
              elevation: 0,
              titleTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              labelStyle: GoogleFonts.poppins(fontSize: 14.sp),
            ),
          ),

          routes: {
            '/login': (context) => const LoginPage(),

            // PATIENT
            '/patient_home': (context) => const HomePage(),

            // DOCTOR
            '/doctor_home': (context) => const DoctorHomePage(),

            // ROUTES AVEC PARAMÈTRES
            '/update_medical': (context) {
              final patientId = ModalRoute.of(context)!.settings.arguments as String;
              return UpdateMedicalFolderPage(patientId: patientId);
            },

            '/update_folder': (context) {
              final patientId = ModalRoute.of(context)!.settings.arguments as String;
              return UpdateMedicalFolderPage(patientId: patientId);
            },

            '/add_suivi': (context) {
              final patientId = ModalRoute.of(context)!.settings.arguments as String;
              return AddSuiviSantePage(patientId: patientId);
            },
          },
        );
      },
    );
  }
}
