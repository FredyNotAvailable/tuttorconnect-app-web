import 'package:flutter/material.dart';

class FechaFiltroWidget extends StatelessWidget {
  final DateTimeRange? rangoSeleccionado;
  final ValueChanged<DateTimeRange?> onChanged;

  const FechaFiltroWidget({
    super.key,
    required this.rangoSeleccionado,
    required this.onChanged,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: rangoSeleccionado,
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              rangoSeleccionado != null
                  ? '${rangoSeleccionado!.start.day}/${rangoSeleccionado!.start.month}/${rangoSeleccionado!.start.year} - '
                    '${rangoSeleccionado!.end.day}/${rangoSeleccionado!.end.month}/${rangoSeleccionado!.end.year}'
                  : 'Filtrar por fechas',
              textAlign: TextAlign.center,
            ),
            onPressed: () => _pickDateRange(context),
          ),
        ),
        if (rangoSeleccionado != null) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onChanged(null),
            child: const Icon(Icons.clear),
          ),
        ],
      ],
    );
  }
}
