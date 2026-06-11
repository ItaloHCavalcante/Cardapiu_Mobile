enum UserRole {
  user,
  admin,
  deliverer;

  String get apiValue => switch (this) {
    UserRole.user => 'USER',
    UserRole.admin => 'ADMIN',
    UserRole.deliverer => 'DELIVERER',
  };

  String get label => switch (this) {
    UserRole.user => 'Cliente',
    UserRole.admin => 'Admin',
    UserRole.deliverer => 'Entregador',
  };

  bool get isCustomer => this == UserRole.user;
  bool get isAdmin => this == UserRole.admin;
  bool get isDeliverer => this == UserRole.deliverer;

  static UserRole fromApi(String? value) {
    final normalized = value?.toUpperCase().replaceAll('ROLE_', '').trim();
    return switch (normalized) {
      'ADMIN' || 'ESTABELECIMENTO' => UserRole.admin,
      'DELIVERER' || 'ENTREGADOR' => UserRole.deliverer,
      _ => UserRole.user,
    };
  }
}
