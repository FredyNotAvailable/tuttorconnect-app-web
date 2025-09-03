import 'package:flutter/material.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';

enum StatusModal { loading, success, error, warning }

class CustomStatusModal extends StatelessWidget {
  final StatusModal status;
  final String message;

  const CustomStatusModal({
    super.key,
    required this.status,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Icono según el estado
    Widget iconWidget;
    // ignore: unused_local_variable
    String title;

    switch (status) {
      case StatusModal.loading:
        iconWidget = const CircularProgressIndicator(color: AppColors.primary);
        title = "Cargando";
        break;
      case StatusModal.success:
        iconWidget = const Icon(Icons.check_circle, color: Colors.white, size: 48);
        title = "Éxito";
        break;
      case StatusModal.error:
        iconWidget = const Icon(Icons.error, color: Colors.white, size: 48);
        title = "Error";
        break;
      case StatusModal.warning:
        iconWidget = const Icon(Icons.warning, color: Colors.white, size: 48);
        title = "Advertencia";
        break;
    }

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 300, // ancho fijo del modal
        height: 250, // altura fija
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1️⃣ Icono con fondo según status
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),

            // 2️⃣ Mensaje
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // 3️⃣ Botón
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(status),
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para asignar color de fondo según el estado
  Color _getStatusColor(StatusModal status) {
    switch (status) {
      case StatusModal.loading:
        return AppColors.loading;
      case StatusModal.success:
        return AppColors.success;
      case StatusModal.error:
        return AppColors.error;
      case StatusModal.warning:
        return AppColors.warning;
    }
  }
}
