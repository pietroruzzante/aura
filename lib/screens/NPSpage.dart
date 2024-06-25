import 'package:flutter/material.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Loginpage.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const credentials = {
  "type": "service_account",
  "project_id": "aura-426910",
  "private_key_id": "9bc458157648e6a7febcffc635a935d0519ed0b7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1QX4dDLrq4iz1\nvDMVR0iHzUpK9/eIfTZJtZvXnoHsMU3JNURIQhqJks47bxHpxlHIT1zSVtIO3jOv\ntlhCJ/II8RhMpGIJ+wRdttQas7b0j42RNtxBIoiThPQFEqSmyz4N/lrs9FFeYXnK\nylDu3SxzJe7KZkfZhCXOw6bONy4X8z3Wze98WpCHgOp5Kblho7iHsuhWNZosWHOA\n/4+d9m98mDrkZLskl4r/XUBVujbjUtSsdheJmrev9J0YJKMX5259Bsq21hfyDmwn\nPnMwOFD1I6L0Zq3JSqDKpcPn2stPe1B/p7kViwPRG3F6lCxYZEuFLNo5kEoKgDDm\nXA48cI4hAgMBAAECggEAKLPACuxype+rynPcYcUb3bkFG6Ai0yDQ+czhJdJ3mO86\naTo/rt0/QdD4ZELNGjq5XzqpHKe37HRL1YOkPpjjQkxHmWBZjqWyZYv6hdOA/Fqn\nHuqbm7nSQxQ6StBUrorZ0MEjMG4tvnyzoYz8jyMWCfaE8Kj2rfr9lXh8gvbDsEdC\n5N5ylade6o6lSb5KodeIYgvXBohTiEocDOdY7Nq7xMJ6gA7ihvlZSlWZrJrLeDbP\nVIvvRyDO5+TXURA0K+TM+GOt4V9qMs9x5SjS78SLSk8pPN9OcY2uREMMRuMLz0fR\nvkAqKnZ6W7S8K1pH2FkSMZcD/bbciG2xP0S6K+Wn5QKBgQDxh+T6DNamUyaC4GiA\njkzkK68crLqd+n/q4aThOBb7mousDO1pGPmQG41+FX6Hbtj79hYzuBKZMuBCRihy\nxuaA0+flwGusGRGC4t7xGjJC34aonF7JciDenPTn4SeOPNVxov+gQbIOsWMeK1ML\nbfajtsvp5Y+Jj8z6HqQd1kIUtQKBgQDAHTk4gnAJDB8XBRyyTnsbh8FhMEYL1dTt\nTisjkXDKk4BXAuUjjy7fZeT0Ym666fQcpJeVYfdpou5wOgVRLbJBv/L/VSuuGyyJ\nGKERm4BULkNRcxEDumVaYfUyFMItdZkUkpS81d8cHKcKijHCyLWVbOa9pu64y1cM\nDvBkRlWDPQKBgF/xPFq7mNRu+UBJxhky7YZBeAjq8CJq7D8wLN+t+Ssuw8avR+tU\nmWXOHBF2llFUDetgYIdg2jpyxDRvTAfzzIJmKprQKbUuLA+S8T5Syp5XzlTR8LES\nnc3wCTTG8oCE18CRH/vXvNQrUJUeXpmOr8duiGe74Z2iOqksXMLhZlR1AoGAdxEl\np7pgCZtzoWbPtEsjzZpD5iJvJ2KuBy3NWswHZeYpQsROk81oNZkHX9ep3TqmyyHP\nuQvwtY3/zZqINRnnQwzeZBW7brr0zTtwiGMiFApgOpjgULkzm+Left2Sw24BJFj8\nylSbZOb1OHkSAjE3KZdHIv/VML8GAjk4EE3vLdkCgYBNQuymJ86nxW7Hz4UpKC2f\nwceC5ebRPSk+/7CPDSlplzhZMPSlRntkTXa9yO5Nrk1yFTCQ9dwd+hn+hJd6aZGZ\nPWQtxZDNyUXTz2zwIMKPtFWXiIDrLNOUfoG3sg3WJrf5C6t5qQ/Cw2nAPhL/pJQc\no0AZNI2NaE1cyhW3R8R4sQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "aura-app@aura-426910.iam.gserviceaccount.com",
  "client_id": "103769477086665935737",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/aura-app%40aura-426910.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};


Future<Spreadsheet> getSpreadsheet(GSheets gsheets, String spreadsheetId) async {
  return await gsheets.spreadsheet(spreadsheetId);
}

Future<Worksheet?> getWorksheet(Spreadsheet ss, String title) async {
  final ws = ss.worksheetByTitle(title);
  if (ws == null) {
    print('Worksheet "$title" not found!');
    // Print all available worksheet titles
    ss.sheets.forEach((sheet) {
      print('Available worksheet title: ${sheet.title}');
    });
  }
  return ws;
}

class NPSpage extends StatefulWidget {
  @override
  _NPSpageState createState() => _NPSpageState();
}

class _NPSpageState extends State<NPSpage> {
  double selectedScore = 5.0;

  IconData getIconForScore(int score) {
    if (score >= 0 && score <= 6) {
      return Icons.sentiment_dissatisfied_outlined; 
    } else if (score >= 7 && score <= 8) {
      return Icons.sentiment_neutral_outlined;
    } else if (score >= 9 && score <= 10) {
      return Icons.sentiment_satisfied_outlined;
    } else {
      return Icons.sentiment_neutral_outlined; 
    }
  }

  Color getColorForScore(int score) {
    if (score >= 0 && score <= 6) {
      return Colors.red;
    } else if (score >= 7 && score <= 8) {
      return Colors.orange;
    } else if (score >= 9 && score <= 10) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  Future<void> saveScoreToSheet(double score) async {
    try {
      final gsheets = GSheets(credentials);
      final spreadsheetId = '1Vh9Z8kYfYW5tH93Nty9iP-wmrYkkzj_oYPDLAcPWtE4'; 
      final spreadsheet = await getSpreadsheet(gsheets, spreadsheetId);
      final worksheet = await getWorksheet(spreadsheet, 'Sheet1');

      if (worksheet != null) {
        await worksheet.values.appendRow([score.toInt()]);
        print('Score saved to sheet: $score');
      } else {
        print('Worksheet not found!');
      }
    } catch (e) {
      print('Error saving score to sheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.deepBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Image.asset(
                'assets/logo.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 100),
              Text(
                'Are you sure?\nAll your data will be deleted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'WorkSans',
                  color: Palette.deepBlue,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'WorkSans',
                      color: Palette.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.deepBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'WorkSans',
                      color: Palette.deepBlue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.99,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please Rate Us!',
                      style: WorkSans.titleSmall,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'How likely would you recommend Aura to a friend or colleague?',
                      style: WorkSans.bodyMedium.copyWith(color: Palette.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          getIconForScore(selectedScore.toInt()),
                          size: 70,
                          color: getColorForScore(selectedScore.toInt()),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Slider(
                      value: selectedScore,
                      activeColor: getColorForScore(selectedScore.toInt()),
                      inactiveColor: Palette.softBlue1,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: selectedScore.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          selectedScore = value;
                        });
                      },
                      autofocus: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await saveScoreToSheet(selectedScore);
                            final sp = await SharedPreferences.getInstance();
                            await sp.clear();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) => LoginPage())));
                          },
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Palette.white,
                            backgroundColor: Palette.deepBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
