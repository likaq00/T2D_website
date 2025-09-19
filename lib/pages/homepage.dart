import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _aboutKey = GlobalKey();
  final _scienceKey = GlobalKey();
  final _featuresKey = GlobalKey();

  Future<void> _to(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFF0E1414),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.6),
            title: const Text('T2D Digital Twin'),
            actions: [
              TextButton(onPressed: () => _to(_aboutKey), child: const Text('About')),
              TextButton(onPressed: () => _to(_scienceKey), child: const Text('Science')),
              TextButton(onPressed: () => _to(_featuresKey), child: const Text('Features')),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton.tonal(
                  onPressed: () => context.go('/login'), child: const Text('Login')),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 520,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E1414), Color(0xFF0A1E1B)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('A personal Digital Twin for Type 2 Diabetes',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Text(
                      'Blablabla',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.onSurface.withOpacity(0.75)),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.tonal(
                      onPressed: () => _to(_aboutKey), child: const Text('Learn more ↓')),
                  ],
                ),
              ),
            ),
          ),
          _section(key: _aboutKey, title: 'About the project',
              child: _placeholder('project story')),
          _section(key: _scienceKey, title: 'Science & datasets',
              child: _placeholder('NHANES, MIMIC-IV, DFU, DR …')),
          _section(key: _featuresKey, title: 'Features',
              child: Column(children: const [
                ListTile(leading: Icon(Icons.trending_up), title: Text('Risk previews')),
                ListTile(leading: Icon(Icons.upload), title: Text('Upload labs')),
                ListTile(leading: Icon(Icons.monitor_heart), title: Text('Multimodal insights')),
              ])),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('© ${DateTime.now().year} T2D Digital Twin — Graduation Project',
                    style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _section({
    Key? key, required String title, required Widget child,
  }) {
    return SliverToBoxAdapter(
      key: key,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x22FFFFFF)))),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16), child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(String label) => Container(
    height: 160,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white12),
    ),
    child: Text(label, style: const TextStyle(color: Colors.white70)),
  );
}
