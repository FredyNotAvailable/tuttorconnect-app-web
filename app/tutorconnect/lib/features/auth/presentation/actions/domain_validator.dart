// lib/features/auth/utils/domain_validator.dart

enum EmailDomainType {
  uide,
}

class EmailDomainValidator {
  static const Map<EmailDomainType, String> domainMap = {
    EmailDomainType.uide: '@uide.edu.ec',
  };

  /// Verifica si un correo pertenece al dominio especificado
  static bool validate(String email, EmailDomainType type) {
    final domain = domainMap[type]!;
    return email.trim().toLowerCase().endsWith(domain);
  }

  /// Devuelve el dominio correspondiente al tipo
  static String getDomain(EmailDomainType type) => domainMap[type]!;
}
