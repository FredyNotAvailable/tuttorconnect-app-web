// features/tutorias/presentation/widgets/tutorias_status.dart
import 'package:flutter/material.dart';

class TutoriasStatus extends StatelessWidget {
  final bool loading;
  final String? error;
  final Widget child;

  const TutoriasStatus({
    super.key,
    required this.loading,
    required this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('Error: $error'));
    return child;
  }
}
