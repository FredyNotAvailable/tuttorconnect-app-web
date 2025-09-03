import 'package:flutter/material.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';

class TutoriaFechaFiltroUiWidget extends StatelessWidget {
  final DateTimeRange? rangoSeleccionado;
  final void Function(DateTimeRange?) onChanged;

  const TutoriaFechaFiltroUiWidget({
    super.key,
    required this.rangoSeleccionado,
    required this.onChanged,
  });

  Future<void> _seleccionarRangoFechas(BuildContext context) async {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month - 1, hoy.day);
    final fin = DateTime(hoy.year, hoy.month + 1, hoy.day);

    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(hoy.year - 5),
      lastDate: DateTime(hoy.year + 5),
      initialDateRange: rangoSeleccionado ?? DateTimeRange(start: inicio, end: fin),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        // 🔹 Aplica colores de tu tema
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,          // botón "Aceptar"
              onPrimary: AppColors.onPrimary,      // texto en botones
              surface: AppColors.primary,          // fondo del picker
              onSurface: Colors.black,             // texto del calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // botones de texto
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
                color: AppColors.onSecondary, // texto consistente con el tema
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
