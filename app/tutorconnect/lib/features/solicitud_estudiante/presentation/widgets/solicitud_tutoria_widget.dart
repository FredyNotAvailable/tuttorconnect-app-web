import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/providers/solicitudes_tutorias_provider.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_list_widget.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';

class SolicitudesTutoriasWidget extends ConsumerStatefulWidget {
  const SolicitudesTutoriasWidget({super.key});

  @override
  ConsumerState<SolicitudesTutoriasWidget> createState() => _SolicitudesTutoriasWidgetState();
}

class _SolicitudesTutoriasWidgetState extends ConsumerState<SolicitudesTutoriasWidget> {
  DateTimeRange? filtroFecha;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // 🔹 Cargar datos apenas inicia el widget
    Future.microtask(() async {
      try {
        await ref.read(solicitudesTutoriasProvider.notifier).getAllSolicitudes();
        await ref.read(usuarioProvider.notifier).getAllUsuarios();
        await ref.read(tutoriaProvider.notifier).getAllTutorias();
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    });
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
  }

  @override
Widget build(BuildContext context) {
  if (loading) return const Center(child: CircularProgressIndicator());
  if (error != null) return Center(child: Text('Error: $error'));

  final state = ref.watch(solicitudesTutoriasProvider);
  final authState = ref.watch(authProvider);
  final currentUser = authState.user;

  // Filtrar solicitudes según permisos
  final solicitudes = (state.solicitudes ?? []).where((solicitud) {
    return currentUser?.id == solicitud.estudianteId;
  }).toList();

  // Filtrar por rango de fechas
  final solicitudesFiltradas = filtroFecha != null
      ? solicitudes.where((s) {
          final tutoria = getTutoriaById(ref, s.tutoriaId);
          final fechaTutoria = tutoria.fecha.toDate();
          final fechaSolo = DateTime(fechaTutoria.year, fechaTutoria.month, fechaTutoria.day);
          final start = DateTime(filtroFecha!.start.year, filtroFecha!.start.month, filtroFecha!.start.day);
          final end = DateTime(filtroFecha!.end.year, filtroFecha!.end.month, filtroFecha!.end.day);
          return !fechaSolo.isBefore(start) && !fechaSolo.isAfter(end);
        }).toList()
      : solicitudes;

  return Column(
    children: [
      if (filtroFecha != null)
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => filtroFecha = null),
              child: const Icon(Icons.clear),
            ),
          ],
        ),

      // Expanded con RefreshIndicator para refrescar al arrastrar
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => loading = true);
            try {
              await ref.read(solicitudesTutoriasProvider.notifier).getAllSolicitudes();
              await ref.read(usuarioProvider.notifier).getAllUsuarios();
              await ref.read(tutoriaProvider.notifier).getAllTutorias();
            } catch (e) {
              setState(() {
                error = e.toString();
              });
            } finally {
              setState(() => loading = false);
            }
          },
          child: SolicitudTutoriaListWidget(
            solicitudes: solicitudesFiltradas,
            currentUserId: currentUser?.id,
            currentUserRol: currentUser?.rol,
          ),
        ),
      ),
    ],
  );
}

}
