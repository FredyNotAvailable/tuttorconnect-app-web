import 'package:flutter/material.dart';

/// Define los tipos de modal
enum ModalType { loading, success, error, message, input }

class CustomModal extends StatelessWidget {
  final ModalType type;
  final String message;
  final String? title; // Nuevo
  final String? acceptText;
  final String? cancelText;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final TextEditingController? inputController;

  const CustomModal({
    super.key,
    required this.type,
    required this.message,
    this.title, // Nuevo
    this.acceptText = "Aceptar",
    this.cancelText,
    this.onAccept,
    this.onCancel,
    this.inputController,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = SizedBox.shrink();

    switch (type) {
      case ModalType.loading:
        iconWidget = CircularProgressIndicator();
        break;
      case ModalType.success:
        iconWidget = Icon(Icons.check_circle, color: Colors.green, size: 60);
        break;
      case ModalType.error:
        iconWidget = Icon(Icons.error, color: Colors.red, size: 60);
        break;
      case ModalType.message:
        iconWidget = Icon(Icons.info, color: Colors.blue, size: 60);
        break;
      case ModalType.input:
        // iconWidget = Icon(Icons.email, color: Colors.orange, size: 60);
        SizedBox.shrink(); // Sin ícono

        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 20),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            if (type == ModalType.input) ...[
              const SizedBox(height: 20),
              TextField(
                controller: inputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (type != ModalType.loading)
              Row(
                mainAxisAlignment: cancelText != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (cancelText != null)
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onCancel != null) onCancel!();
                      },
                      child: Text(cancelText!),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onAccept != null) onAccept!();
                    },
                    child: Text(acceptText!),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
