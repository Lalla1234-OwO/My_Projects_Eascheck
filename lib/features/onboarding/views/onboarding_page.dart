import 'package:flutter/material.dart';
import 'package:eascheck/features/survey/views/health_survey_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// หน้าสอบถามข้อมูลส่วนตัว หลังจากล็อกอินสำเร็จ
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();

  // 1) ตัวแปรสำหรับ DatePicker
  final TextEditingController _birthController = TextEditingController();
  DateTime? _selectedDate;

  // 2) ตัวแปรเก็บคำตอบ
  String? birthDate;
  String? gender;
  bool? isPregnant; // เฉพาะกรณี gender == 'Female'
  double? height;
  double? currentWeight;

  @override
  void dispose() {
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final client = Supabase.instance.client;
      await client.from('user_profile').upsert({
        'user_id': client.auth.currentUser!.id,
        'birth_date': birthDate,
        'gender': gender,
        'is_pregnant': isPregnant,
        'height': height,
        'current_weight': currentWeight,
        'last_updated': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HealthSurveyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลส่วนตัว')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // วัน/เดือน/ปี (DatePicker)
            TextFormField(
              controller: _birthController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'วัน/เดือน/ปี',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _selectedDate = date;
                  // แปลงเป็น ISO-date 'YYYY-MM-DD'
                  final isoDate = date.toIso8601String().split('T').first;
                  _birthController.text = isoDate;
                  birthDate = isoDate;
                }
              },
              onSaved: (_) {
                // แน่ใจว่าเก็บเป็น ISO-date ด้วย
                birthDate = _birthController.text;
              },
            ),
            const SizedBox(height: 16),

            // เพศ
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'เพศ'),
              items:
                  ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
              onChanged: (v) => setState(() => gender = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // ถ้าเป็นหญิง ให้ถามเรื่องตั้งครรภ์
            if (gender == 'Female')
              DropdownButtonFormField<bool>(
                decoration: const InputDecoration(
                  labelText: 'คุณกำลังตั้งครรภ์หรือไม่',
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('ใช่')),
                  DropdownMenuItem(value: false, child: Text('ไม่ใช่')),
                ],
                onChanged: (v) => setState(() => isPregnant = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
            if (gender == 'Female') const SizedBox(height: 16),

            // น้ำหนักปัจจุบัน
            TextFormField(
              decoration: const InputDecoration(labelText: 'น้ำหนัก (kg)'),
              keyboardType: TextInputType.number,
              onSaved: (v) => currentWeight = double.tryParse(v!),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // ส่วนสูง
            TextFormField(
              decoration: const InputDecoration(labelText: 'ส่วนสูง (cm)'),
              keyboardType: TextInputType.number,
              onSaved: (v) => height = double.tryParse(v!),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text('ต่อไป'),
            ),
          ],
        ),
      ),
    );
  }
}
