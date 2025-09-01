// Feature/common/components/ConfirmModal.jsx
import { Modal, ModalOverlay, ModalContent, ModalHeader, ModalBody, ModalFooter, Button, Text } from "@chakra-ui/react";

export default function ConfirmModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText = "Confirmar",
  cancelText = "Cancelar"
}) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader color="brand.500">{title}</ModalHeader>
        <ModalBody>
          <Text color="onSecondary">{message}</Text>
        </ModalBody>
        <ModalFooter>
          <Button variant="ghost" mr={3} colorScheme="secondary" onClick={onClose}>
            {cancelText}
          </Button>
          <Button colorScheme="brand" onClick={() => { onConfirm(); onClose(); }}>
            {confirmText}
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
