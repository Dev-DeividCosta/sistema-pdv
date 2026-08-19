enum AppFormMode { create, view, edit }

extension AppFormModeX on AppFormMode {
  bool get isReadOnly => this == AppFormMode.view;
  bool get isEditing => this == AppFormMode.edit;
}
