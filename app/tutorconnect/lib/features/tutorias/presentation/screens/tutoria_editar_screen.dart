import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/features/auth/presentation/modals/custom_status_modal.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/aulas/helpers/aula_helper.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';

class EditarTutoriaScreen extends ConsumerStatefulWidget {
  final TutoriaModel tutoria;

  const EditarTutoriaScreen({super.key, required this.tutoria});

  @override
  ConsumerState<EditarTutoriaScreen> createState() => _EditarTutoriaScreenState();
}

class _EditarTutoriaScreenState extends ConsumerState<EditarTutoriaScreen> {
  // 🔹 Controladores de los campos de texto
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _horaInicioController;
  late TextEditingController _horaFinController;
  late TextEditingController _fechaController;

  // 🔹 Variables para fecha, aula y estado
  DateTime? _fechaSeleccionada;
  String? _estadoSeleccionado;
  String? _aulaSeleccionada;

  @override
  void initState() {
    super.initState();

    // 🔹 Inicializamos los controladores de texto con los valores de la tutoría
    _tituloController = TextEditingController(text: widget.tutoria.tema);
    _descripcionController = TextEditingController(text: widget.tutoria.descripcion);
    _horaInicioController = TextEditingController(text: widget.tutoria.horaInicio);
    _horaFinController = TextEditingController(text: widget.tutoria.horaFin);

    // 🔹 Inicializamos la fecha
    _fechaSeleccionada = widget.tutoria.fecha.toDate();
    _fechaController = TextEditingController(
      text: _fechaSeleccionada != null
          ? DateFormat('dd/MM/yyyy').format(_fechaSeleccionada!)
          : '',
    );

    // 🔹 Inicializamos el aula seleccionada
    _aulaSeleccionada = widget.tutoria.aulaId;

    // 🔹 Inicializamos el estado
    _estadoSeleccionado = widget.tutoria.estado.name;
  }


  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fechaController.dispose();
    _horaInicioController.dispose();
    _horaFinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aulasDisponibles = getAulasDisponibles(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tutoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔹 Campo de texto para el título
            TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Tema')),
            const SizedBox(height: 12),

            // 🔹 Campo de texto para la descripción
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // 🔹 Selector de aula
            // Dropdown con aulas disponibles
            DropdownButtonFormField<String>(
              value: _aulaSeleccionada,
              decoration: const InputDecoration(labelText: 'Aula'),
              items: aulasDisponibles.map((a) => DropdownMenuItem(
                    value: a.id,
                    child: Text('${a.nombre} - ${a.tipo}'),
                  )).toList(),
              onChanged: (val) => setState(() => _aulaSeleccionada = val),
            ),
            const SizedBox(height: 12),

            // 🔹 Selector de fecha con validaciones
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaSeleccionada ?? DateTime.now(),
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
                      picked.day == now.day &&
                      now.hour >= 22) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No puedes agendar tutorías después de las 22:00 de hoy')),
                    );
                    return;
                  }

                  // Si pasa todas las validaciones, se asigna
                  setState(() {
                    _fechaSeleccionada = picked;
                    _fechaController.text = DateFormat('dd/MM/yyyy').format(_fechaSeleccionada!);
                    _horaInicioController.clear(); // Limpiar hora inicio al cambiar fecha
                    _horaFinController.clear(); // Limpiar hora fin al cambiar fecha
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

            
            // 🔹 Selector de horas con validaciones
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

                        // Validar que la hora esté dentro del rango permitido
                        if (picked.hour < horaMin.hour ||
                            (picked.hour == horaMax.hour && picked.minute > 0) ||
                            picked.hour > horaMax.hour) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('La hora debe estar entre 07:00 y 22:00')),
                          );
                          return;
                        }

                        setState(() {
                          // Guardar hora inicio y limpiar hora fin
                          _horaInicioController.text =
                              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                          _horaFinController.clear();
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

                        // Validar que hora fin sea al menos 30 minutos mayor que hora inicio
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
            const SizedBox(height: 12),




            // 🔹 Selector de estado
            DropdownButtonFormField<String>(
              value: _estadoSeleccionado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: TutoriaEstado.values.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name))).toList(),
              onChanged: (val) => setState(() => _estadoSeleccionado = val),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (_fechaSeleccionada == null || _horaInicioController.text.isEmpty || _horaFinController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Debes seleccionar fecha y horas válidas')),
                  );
                  return;
                }

                // Convertir solo año/mes/día a UTC
                final fechaUtc = DateTime.utc(
                  _fechaSeleccionada!.year,
                  _fechaSeleccionada!.month,
                  _fechaSeleccionada!.day,
                );

                final tutoriaActualizada = widget.tutoria.copyWith(
                  tema: _tituloController.text,
                  descripcion: _descripcionController.text,
                  aulaId: _aulaSeleccionada!,
                  fecha: Timestamp.fromDate(fechaUtc), // <-- aquí
                  horaInicio: _horaInicioController.text,
                  horaFin: _horaFinController.text,
                  estado: TutoriaEstado.values.firstWhere((e) => e.name == _estadoSeleccionado),
                );

                try {
                  // 🔹 Mostrar modal de carga
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const CustomStatusModal(
                      status: StatusModal.loading,
                      message: 'Actualizando tutoría...',
                    ),
                  );

                  // 🔹 Actualizar la tutoría
                  await updateTutoriaHelper(ref, tutoriaActualizada);

                  // 🔹 Cerrar modal de carga
                  if (Navigator.canPop(context)) Navigator.pop(context);

                  // 🔹 Modal de éxito
                  await showDialog(
                    context: context,
                    builder: (_) => const CustomStatusModal(
                      status: StatusModal.success,
                      message: 'Tutoría actualizada exitosamente',
                    ),
                  );

                  // 🔹 Cerrar la pantalla
                  Navigator.pop(context);
                  
                } catch (e) {
                  // 🔹 Cerrar modal de carga si ocurrió un error
                  if (Navigator.canPop(context)) Navigator.pop(context);

                  // 🔹 Modal de error
                  showDialog(
                    context: context,
                    builder: (_) => CustomStatusModal(
                      status: StatusModal.error,
                      message: 'Error al actualizar tutoría: $e',
                    ),
                  );
                }
              },
              child: const Text('Guardar cambios'),
            )


          ],
        ),
      ),
    );
  }
}
