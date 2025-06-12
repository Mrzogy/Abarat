import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:abarat_app/provider/auth_provider.dart';

class BookingScreen extends StatefulWidget {
  final int passengerCount;
  final String tripId;

  const BookingScreen({
    super.key,
    required this.passengerCount,
    required this.tripId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Map<String, dynamic>> passengers = [];
  List<String?> passengerNames = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passengers = List.generate(widget.passengerCount, (_) => {});
    passengerNames = List.filled(widget.passengerCount, null);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Image.asset('lib/images/nagl.png', height: 30)],
              ),
              const SizedBox(height: 20),
              const Text("اضافة الراكب", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ...List.generate(widget.passengerCount, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            passengerNames[index] ?? 'بالغ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () => _showPassengerForm(context, index),
                            child: Text(
                              'أضف',
                              style: TextStyle(
                                color: Color(0xff0033A0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              const Text("معلومات التواصل", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                "يرجى إضافة معلومات الاتصال التي تفضل تلقي تأكيد الحجز عليها",
              ),
              const SizedBox(height: 20),
              _buildTextField('رقم الجوال', controller: phoneController),
              const SizedBox(height: 12),
              _buildTextField('البريد الالكتروني', controller: emailController),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0033A0),
                  ),
                  onPressed: _confirmBooking,
                  child: const Text(
                    'تأكيد الحجز',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPassengerForm(BuildContext context, int index) {
    DateTime? selectedDate;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final idNumberController = TextEditingController();
    String idType = "هوية وطنية";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
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
                                  items:
                                      ["هوية وطنية", "إقامة"].map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                  onChanged:
                                      (value) =>
                                          setState(() => idType = value!),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _textField(idNumberController, "رقم الهوية"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              Duration(days: 3650),
                            ),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedDate == null
                                ? 'تاريخ الميلاد'
                                : selectedDate!.toLocal().toString().split(
                                  ' ',
                                )[0],
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
                          setState(() {
                            passengers[index] = {
                              "firstName": firstNameController.text,
                              "lastName": lastNameController.text,
                              "idType": idType,
                              "idNumber": idNumberController.text,
                              "birthDate": selectedDate!.toIso8601String(),
                            };
                            passengerNames[index] = firstNameController.text;
                          });
                          Navigator.pop(context);
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
                            child: Text(
                              "تأكيد الراكب",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((_) => setState(() {}));
  }

  void _confirmBooking() async {
    final isValid = passengers.every(
      (p) =>
          p.containsKey("firstName") &&
          p.containsKey("lastName") &&
          p.containsKey("idType") &&
          p.containsKey("idNumber") &&
          p.containsKey("birthDate"),
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
      "tripId": widget.tripId,
      "passengers":
          passengers
              .map(
                (p) => {
                  "firstName": p["firstName"],
                  "lastName": p["lastName"],
                  "idType": p["idType"],
                  "idNumber": p["idNumber"],
                  "birthDate": p["birthDate"],
                  "isInfant": false,
                },
              )
              .toList(),
    };

    final response = await http.post(
      Uri.parse("http://localhost:3000/bookings/makeBoking"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("تم الحجز بنجاح")));
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("فشل في الحجز")));
    }
  }

  Widget _buildTextField(String hint, {TextEditingController? controller}) {
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
}
