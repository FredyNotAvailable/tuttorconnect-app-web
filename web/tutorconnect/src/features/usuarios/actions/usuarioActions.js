// Feature/usuarios/actions/usuarioActions.js
import { UsuarioRepository } from "../repositories/UsuarioRepository";
import { sendPasswordResetEmail } from "firebase/auth";
import { auth } from "../../../services/firebase";

export const UsuarioActions = {
  crearUsuario: async (usuario, toast) => {
    try {
      await UsuarioRepository.createUsuario(usuario);
      toast({
        title: "Usuario creado",
        description: `${usuario.nombreCompleto} ha sido creado`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear usuario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  editarUsuario: async (usuario, toast) => {
    try {
      await UsuarioRepository.updateUsuario(usuario);
      toast({
        title: "Usuario actualizado",
        description: `${usuario.nombreCompleto} ha sido modificado`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar usuario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarUsuario: async (uid, nombre, toast) => {
    try {
      await UsuarioRepository.deleteUsuario(uid);
      toast({
        title: "Usuario eliminado",
        description: `${nombre} ha sido eliminado`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar usuario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  restablecerPassword: async (correo, toast) => {
    try {
      await sendPasswordResetEmail(auth, correo);
      toast({
        title: "Email de restablecimiento enviado",
        description: `Se ha enviado un email a ${correo}`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al enviar email",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};
