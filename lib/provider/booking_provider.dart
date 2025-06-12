import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abarat_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class BookingProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _passengers = [];
  final List<String?> _passengerNames = [];
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  List<Map<String, dynamic>> get passengers => _passengers;
  List<String?> get passengerNames => _passengerNames;

  void initialize(int passengerCount) {
    _passengers.clear();
    _passengerNames.clear();
    _passengers.addAll(List.generate(passengerCount, (_) => {}));
    _passengerNames.addAll(List.filled(passengerCount, null));
    notifyListeners();
  }

  void updatePassenger(int index, Map<String, dynamic> data) {
    _passengers[index] = data;
    _passengerNames[index] = data["firstName"];
    notifyListeners();
  }

  Future<void> confirmBooking(BuildContext context, String tripId) async {
    final isValid = _passengers.every((p) =>
      p.containsKey("firstName") &&
      p.containsKey("lastName") &&
      p.containsKey("idType") &&
      p.containsKey("idNumber") &&
      p.containsKey("birthDate")
    );

    if (!isValid ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى تعبئة جميع الحقول لكل الركاب")),
      );
      return;
    }

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final body = {
      "tripId": tripId,
      "passengers": _passengers.map((p) => {
        "firstName": p["firstName"],
        "lastName": p["lastName"],
        "idType": p["idType"],
        "idNumber": p["idNumber"],
        "birthDate": p["birthDate"],
        "isInfant": false
      }).toList()
    };

    final response = await http.post(
      Uri.parse("http://192.168.8.42:3000/bookings/makeBoking"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم الحجز بنجاح")),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في الحجز")),
      );
    }
  }

  Future<Map<String, dynamic>?> showPassengerForm(BuildContext context,int index) async {
    DateTime? selectedDate;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final idNumberController = TextEditingController();
    String idType = "هوية وطنية";

    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _textField(firstNameController, "الاسم الأول"),
                      SizedBox(height: 10),
                      _textField(lastNameController, "اسم العائلة"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: idType,
                                  items: ["هوية وطنية", "إقامة"].map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(() => idType = value!),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: _textField(idNumberController, "رقم الهوية")),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(Duration(days: 3650)),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedDate == null
                                ? 'تاريخ الميلاد'
                                : selectedDate!.toLocal().toString().split(' ')[0],
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              idNumberController.text.isEmpty ||
                              selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("يرجى تعبئة جميع الحقول")),
                            );
                            return;
                          }
                          Navigator.pop(context, {
                            "firstName": firstNameController.text,
                            "lastName": lastNameController.text,
                            "idType": idType,
                            "idNumber": idNumberController.text,
                            "birthDate": selectedDate!.toIso8601String(),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0033A0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text("تأكيد الراكب", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        filled: true,
        fillColor: Color(0xFFD9D9D9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      textAlign: TextAlign.right,
    );
  }

  void disposeControllers() {
    phoneController.dispose();
    emailController.dispose();
  }
}