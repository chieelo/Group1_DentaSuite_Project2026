import '../model/user.dart';

class Permissions {
  final AppUser user;

  const Permissions(this.user);

  bool get canAccessPatients => true;

  bool get canAddPatients => true;

  bool get canUpdatePatients => true;

  bool get canViewTreatments => true;

  bool get canManageTreatments =>
      user.isAdmin || user.isDentist;

  bool get canViewToothChart => true;

  bool get canEditToothChart =>
      user.isAdmin || user.isDentist;

  bool get canViewMedicalHistory => true;

  bool get canManageMedicalHistory =>
      user.isAdmin || user.isDentist;

  bool get canManageAccounts => user.isAdmin;

  bool get canIssueCertificates => user.isDentist;
}