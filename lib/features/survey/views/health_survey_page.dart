import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthSurveyPage extends StatefulWidget {
  const HealthSurveyPage({super.key});
  @override
  _HealthSurveyPageState createState() => _HealthSurveyPageState();
}

class _HealthSurveyPageState extends State<HealthSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  List<Question> _questions = [];
  final Map<int, dynamic> _answers = {}; // key: questionId

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final client = Supabase.instance.client;

    // select() คืนค่าเป็น List<dynamic> เลย ไม่ต้อง .execute() และ .data
    final List<dynamic> data = await client
        .from('questions')
        .select('id, text, type, question_choices(id, label)')
        .order('order', ascending: true);

    print('✅ Loaded questions count: ${data.length}');

    setState(() {
      _questions =
          data
              // แต่ละ element เป็น Map<String, dynamic> จึง cast ก่อนส่งเข้า factory
              .map((j) => Question.fromJson(j as Map<String, dynamic>))
              .toList();
      _isLoading = false;
    });
  }

  Future<void> _submitAnswers() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final client = Supabase.instance.client;
    final userId = client.auth.currentUser!.id;
    final payload =
        _answers.entries.map((e) {
          return {
            'user_id': userId,
            'question_id': e.key,
            'choice_id': e.value is int ? e.value : null,
            'answer_value': e.value is String ? e.value : null,
          };
        }).toList();

    await client.from('user_answers').insert(payload);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Health Survey')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // วนสร้างฟอร์มตามคำถาม
            ..._questions.map((q) {
              switch (q.type) {
                case 'single_choice':
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.text,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...q.choices.map(
                        (c) => RadioListTile<int>(
                          title: Text(c.label),
                          value: c.id,
                          groupValue: _answers[q.id] as int?,
                          onChanged: (v) => setState(() => _answers[q.id] = v),
                        ),
                      ),
                    ],
                  );

                case 'text':
                  return TextFormField(
                    decoration: InputDecoration(labelText: q.text),
                    onSaved: (v) => _answers[q.id] = v,
                    validator:
                        (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  );

                // เพิ่มกรณีอื่นๆ (multi_choice, number, ฯลฯ) ตาม schema
                default:
                  return const SizedBox.shrink();
              }
            }),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitAnswers,
              child: const Text('ส่งคำตอบ'),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class
class Question {
  final int id;
  final String text;
  final String type;
  final List<Choice> choices;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> j) {
    return Question(
      id: j['id'] as int,
      text: j['text'] as String,
      type: j['type'] as String,
      choices:
          (j['question_choices'] as List<dynamic>)
              .map(
                (c) => Choice(id: c['id'] as int, label: c['label'] as String),
              )
              .toList(),
    );
  }
}

class Choice {
  final int id;
  final String label;
  Choice({required this.id, required this.label});
}
