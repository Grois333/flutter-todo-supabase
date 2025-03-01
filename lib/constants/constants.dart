import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const double defaultPadding = 16.0;

final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
final String googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
final String iosClientId = dotenv.env['IOS_CLIENT_ID'] ?? '';
