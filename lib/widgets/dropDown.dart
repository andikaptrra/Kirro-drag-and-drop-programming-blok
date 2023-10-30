import 'package:flutter/material.dart';

import '../global_Variabel/variabel.dart';
import '../utillitas/database/database_user.dart';
import 'package:sqflite/sqflite.dart';

class AccountDropdown extends StatefulWidget {
  final List<String> accountList;
  final String selectedAccount;
  final ValueChanged<String?> onChanged;

  AccountDropdown({
    required this.accountList,
    required this.selectedAccount,
    required this.onChanged,
  });

  @override
  _AccountDropdownState createState() => _AccountDropdownState();
}

class _AccountDropdownState extends State<AccountDropdown> {
 
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String?>(
            value: widget.selectedAccount.isEmpty ? null : widget.selectedAccount,
            onChanged: widget.onChanged,
            dropdownColor: Colors.transparent,
            items: widget.accountList.map<DropdownMenuItem<String?>>(
              (String account) {
                return DropdownMenuItem<String?>(
                  value: account,
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          offset: Offset(-6.0, -6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          offset: Offset(-6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          offset: Offset(6.0, -6.0),
                          blurRadius: 16.0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      account,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
