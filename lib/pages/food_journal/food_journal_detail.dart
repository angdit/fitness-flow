import 'package:flutter/material.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_icon_button.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_theme.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailMakananPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

  DetailMakananPage({required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () {
            context.pushNamed('FoodJournal');
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.meals_data_details,
          style: FlutterFlowTheme.of(context).titleLarge,
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            children: [
              buildRowWithDivider('Gram', '${itemData['berat']}'),
              SizedBox(
                height: 12.0,
              ),
              buildRowWithDivider(
                  AppLocalizations.of(context)!.fat, '${itemData['fat']}'),
              SizedBox(
                height: 12.0,
              ),
              buildRowWithDivider(
                  AppLocalizations.of(context)!.carbs, '${itemData['karbo']}'),
              SizedBox(
                height: 12.0,
              ),
              buildRowWithDivider('Protein', '${itemData['protein']}'),
              SizedBox(
                height: 12.0,
              ),
              buildRowWithDivider(
                  AppLocalizations.of(context)!
                      .calorie
                      .toLowerCase()
                      .split(' ')
                      .map((word) => word.isNotEmpty
                          ? '${word[0].toUpperCase()}${word.substring(1)}'
                          : '')
                      .join(' '),
                  '${itemData['kalori']}'),
              SizedBox(
                height: 12.0,
              ),
              buildRowWithDivider(
                  AppLocalizations.of(context)!.date, '${itemData['tanggal']}'),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk setiap baris dengan divider
  Widget buildRowWithDivider(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
