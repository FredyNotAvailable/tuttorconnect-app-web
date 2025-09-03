// lib/features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_filtro_fecha_ui_widget.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';

class SolicitudTutoriaFiltroFechaUiWidget extends StatelessWidget {
  final DateTimeRange? rangoSeleccionado;
  final void Function(DateTimeRange?) onChanged;

  const SolicitudTutoriaFiltroFechaUiWidget({
    super.key,
    required this.rangoSeleccionado,
    required this.onChanged,
  });

  Future<void> _seleccionarRangoFechas(BuildContext context) async {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month - 1, hoy.day); // default: hace 1 mes
    final fin = DateTime(hoy.year, hoy.month + 1, hoy.day);    // default: próximo mes

    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(hoy.year - 5),
      lastDate: DateTime(hoy.year + 5),
      initialDateRange: rangoSeleccionado ?? DateTimeRange(start: inicio, end: fin),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,     // botones Aceptar/Cancelar
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,     // fondo del picker
              onSurface: Colors.black,        // texto del calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (rango != null) {
      onChanged(rango);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              rangoSeleccionado == null
                  ? "Selecciona un rango de fechas"
                  : "${rangoSeleccionado!.start.toLocal().toString().split(' ')[0]} → ${rangoSeleccionado!.end.toLocal().toString().split(' ')[0]}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSecondary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _seleccionarRangoFechas(context),
            icon: Icon(Icons.date_range, color: AppColors.primary),
            tooltip: "Seleccionar rango de fechas",
          ),
          if (rangoSeleccionado != null)
            IconButton(
              onPressed: () => onChanged(null),
              icon: Icon(Icons.clear, color: AppColors.error),
              tooltip: "Limpiar filtro",
            ),
        ],
      ),
    );
  }
}
