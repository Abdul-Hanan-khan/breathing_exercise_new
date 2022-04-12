import 'package:flutter/material.dart';
import 'ClickType.dart';
import 'button_click_contracts.dart';

class Utills{

  static Widget getFilledButton(
      BuildContext context,
      String label,
      IFilledButtonClicked iFilledButtonClicked,
      ClickType clickType,
      Color color, {
        bool enabled,
        double borderRadius
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius??12),
        color: enabled == null || enabled ? color : Colors.black12,
      ),

      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FlatButton(
        shape: RoundedRectangleBorder(

        ),
        onPressed: enabled == null || enabled
            ? () {
          iFilledButtonClicked.onFilledButtonClick(clickType);
        }
            : null,
        child: Text(
          label,
          style: TextStyle(
              color: enabled == null || enabled ? Colors.white : Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
      ),
    );
  }
}