import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../services/model_service.dart' as api;  // <-- add prefix

class DrPage extends StatefulWidget {
  const DrPage({super.key});
  @override
  State<DrPage> createState() => _DrPageState();
}

class _DrPageState extends State<DrPage> {
  Map<String, dynamic>? res;
  String? err;
  Uint8List? picked;

  Future<void> _choose() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (r != null && r.files.single.bytes != null) {
      setState(() => picked = r.files.single.bytes);
      try {
        // call DR model
        res = await api.predictImage("dr", r.files.single.bytes!, r.files.single.name);
        setState(() {});
      } catch (e) {
        setState(() => err = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final probs = (res?['probs'] as Map?)?.cast<String, dynamic>();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          FilledButton(onPressed: _choose, child: const Text("Upload Retina image")),
          const SizedBox(height: 10),
          if (err != null) Text(err!, style: const TextStyle(color: Colors.red)),
          if (res != null) ...[
            const SizedBox(height: 12),
            Text(
              "Top class: ${res!['top_class']}  (${((res!['top_prob'] as num) * 100).toStringAsFixed(1)}%)",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            if (probs != null) _probsList(probs),
            const SizedBox(height: 12),
            if (res!["explanation_b64"] != null)
              Image.memory(Uri.parse(res!["explanation_b64"]).data!.contentAsBytes()),
          ],
        ],
      ),
    );
  }

  Widget _probsList(Map<String, dynamic> probs) {
    final entries = probs.entries.toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(
      children: entries.map((e) {
        final p = (e.value as num).toDouble();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(width: 160, child: Text(e.key)), // labels come from backend: no dr, mild, moderate, severe, proliferative dr
              Expanded(child: LinearProgressIndicator(value: p, minHeight: 10)),
              const SizedBox(width: 8),
              SizedBox(width: 56, child: Text("${(p * 100).toStringAsFixed(1)}%")),
            ],
          ),
        );
      }).toList(),
    );
  }
}
