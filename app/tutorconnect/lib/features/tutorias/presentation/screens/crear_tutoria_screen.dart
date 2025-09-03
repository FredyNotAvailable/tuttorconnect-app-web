import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/aulas/helpers/aula_helper.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/profesores_materias/application/providers/profesor_materia_provider.dart';
import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';
import 'package:tutorconnect/features/profesores_materias/helpers/profesor_materia_helper.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';

class CrearTutoriaScreen extends ConsumerStatefulWidget {
  const CrearTutoriaScreen({super.key});

  @override
  ConsumerState<CrearTutoriaScreen> createState() => _CrearTutoriaScreenState();
}

class _CrearTutoriaScreenState extends ConsumerState<CrearTutoriaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _temaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinController = TextEditingController();

  // Fecha seleccionada
  DateTime? _fecha;

  // Materia y aula seleccionadas
  MateriaModel? _materiaSeleccionada;
  AulaModel? _aulaSeleccionada;

  // Lista de estudiantes de la materia seleccionada
  List<UsuarioModel> _estudiantesSeleccionados = [];

  // Lista de materias del docente
  List<MateriaModel> materias = [];

  @override
  void initState() {
    super.initState();
    // Cargar relaciones profesor-materia
    Future.microtask(() => ref.read(profesorMateriaProvider.notifier).getAllProfesoresMaterias());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    List<ProfesorMateriaModel> materiasDelProfesor = [];
    if (currentUser != null && currentUser.rol == UsuarioRol.docente) {
      materiasDelProfesor = getMateriasByProfesorId(ref, currentUser.id);
    }

    final aulas = getAulasDisponibles(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Tutoría')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Materia
              DropdownButtonFormField<MateriaModel>(
                value: _materiaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Materia',
                  border: OutlineInputBorder(),
                ),
                items: materiasDelProfesor.map((pm) {
                  final materia = getMateriaById(ref, pm.materiaId);
                  return DropdownMenuItem(
                    value: materia,
                    child: Text(materia.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _materiaSeleccionada = value;
                    if (value != null) {
                      _estudiantesSeleccionados = getAllEstudiantesByMateria(ref, value.id);
                    } else {
                      _estudiantesSeleccionados = [];
                    }
                  });
                },
              ),
              const SizedBox(height: 12),

              // Aula
              DropdownButtonFormField<AulaModel>(
                value: _aulaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Aula',
                  border: OutlineInputBorder(),
                ),
                items: aulas.map((aula) {
                  return DropdownMenuItem(
                    value: aula,
                    child: Text('${aula.nombre} - ${aula.tipo}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _aulaSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Tema
              TextFormField(
                controller: _temaController,
                decoration: const InputDecoration(
                  labelText: 'Tema',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Fecha
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha ?? DateTime.now(),
                    firstDate: DateTime.now(), // No días anteriores
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    final now = DateTime.now();

                    // Validar que no sea fin de semana (sábado=6, domingo=7)
                    if (picked.weekday == DateTime.saturday || picked.weekday == DateTime.sunday) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Las tutorías solo están disponibles de lunes a viernes')),
                      );
                      return;
                    }

                    // Validar si es el día actual y ya son las 22:00
                    if (picked.year == now.year &&
                        picked.month == now.month &&
                        picked.day == now.day) {
                      if (now.hour >= 22) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No puedes agendar tutorías después de las 22:00 de hoy')),
                        );
                        return;
                      }
                    }

                    // Si pasa todas las validaciones, se asigna
                    setState(() {
                      _fecha = picked;
                      _fechaController.text = DateFormat('dd/MM/yyyy').format(_fecha!);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _fechaController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      hintText: 'Seleccionar fecha',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),




              // Hora inicio y fin
              Row(
                children: [
                  // Hora inicio
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          const horaMin = TimeOfDay(hour: 7, minute: 0);
                          const horaMax = TimeOfDay(hour: 22, minute: 0);

                          // Validar rango permitido
                          if (picked.hour < horaMin.hour ||
                              (picked.hour == horaMax.hour && picked.minute > 0) ||
                              picked.hour > horaMax.hour) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La hora debe estar entre 07:00 y 22:00')),
                            );
                            return;
                          }

                          setState(() {
                            _horaInicioController.text =
                                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            _horaFinController.clear(); // Limpiar hora fin si ya estaba
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _horaInicioController,
                          decoration: const InputDecoration(
                            labelText: 'Hora inicio',
                            border: OutlineInputBorder(),
                            hintText: 'Seleccionar hora',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Hora fin
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Validar que ya exista hora inicio
                        if (_horaInicioController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Primero selecciona la hora de inicio')),
                          );
                          return;
                        }

                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          const horaMin = TimeOfDay(hour: 7, minute: 0);
                          const horaMax = TimeOfDay(hour: 22, minute: 0);

                          // Validar rango permitido
                          if (picked.hour < horaMin.hour ||
                              (picked.hour == horaMax.hour && picked.minute > 0) ||
                              picked.hour > horaMax.hour) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La hora debe estar entre 07:00 y 22:00')),
                            );
                            return;
                          }

                          // Validar que sea mayor a hora inicio con mínimo 30 min
                          final inicioParts = _horaInicioController.text.split(':');
                          final inicio = TimeOfDay(
                            hour: int.parse(inicioParts[0]),
                            minute: int.parse(inicioParts[1]),
                          );

                          final inicioMinutos = inicio.hour * 60 + inicio.minute;
                          final finMinutos = picked.hour * 60 + picked.minute;

                          if (finMinutos - inicioMinutos < 30) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La hora de fin debe ser al menos 30 minutos mayor que la de inicio')),
                            );
                            return;
                          }
                          if (finMinutos - inicioMinutos > 180) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La duración de la tutoría no puede ser mayor a 3 horas')),
                            );
                            return;
                          }

                          setState(() {
                            _horaFinController.text =
                                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _horaFinController,
                          decoration: const InputDecoration(
                            labelText: 'Hora fin',
                            border: OutlineInputBorder(),
                            hintText: 'Seleccionar hora',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              // 🔹 Lista de estudiantes de la materia seleccionada
              if (_estudiantesSeleccionados.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Estudiantes de esta materia:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                // 🔹 Debug: imprimir en consola
                Builder(builder: (_) {
                  debugPrint('Lista de estudiantes seleccionados:');
                  for (var e in _estudiantesSeleccionados) {
                    debugPrint(' - ${e.nombreCompleto} (ID: ${e.id})');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _estudiantesSeleccionados.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Opacity(
                          opacity: 0.6, // semi-opaco
                          child: Chip(
                            label: Text(
                              e.nombreCompleto,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            backgroundColor: Colors.grey[300], // color más claro
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 12),
              ],



              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0), // espacio hacia abajo
                  child: SizedBox(
                    width: double.infinity, // botón ancho completo
                    height: 55, // altura más grande
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style, // usa el tema
                      onPressed: () async {
                        if (_temaController.text.isEmpty || 
                            _materiaSeleccionada == null || 
                            _aulaSeleccionada == null || 
                            _fecha == null || 
                            _horaInicioController.text.isEmpty || 
                            _horaFinController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor complete todos los campos')),
                          );
                          return;
                        }

                        // 1️⃣ Crear la tutoría
                        final nuevaTutoria = TutoriaModel(
                          id: '', 
                          tema: _temaController.text,
                          descripcion: _descripcionController.text,
                          profesorId: currentUser!.id,
                          materiaId: _materiaSeleccionada!.id,
                          aulaId: _aulaSeleccionada!.id,
                          fecha: Timestamp.fromDate(_fecha!),
                          horaInicio: _horaInicioController.text,
                          horaFin: _horaFinController.text,
                          estado: TutoriaEstado.pendiente,
                        );

                        final newTutoria = await createTutoriaHelper(ref, nuevaTutoria);

                        // 2️⃣ Crear solicitudes para cada estudiante
                        for (final estudiante in _estudiantesSeleccionados) {
                          final solicitud = SolicitudTutoriaModel(
                            id: '',
                            tutoriaId: newTutoria.id,
                            estudianteId: estudiante.id,
                            fechaEnvio: Timestamp.now(),
                            fechaRespuesta: null,
                            estado: EstadoSolicitud.pendiente,
                          );

                          await createSolicitudHelper(ref, solicitud);
                        }

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Crear Tutoría',
                        style: TextStyle(fontSize: 18), // texto más grande
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
