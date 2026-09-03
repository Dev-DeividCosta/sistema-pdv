class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://EXEMPLO.supabase.co',
  );

  static const anonkey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'EXEMPLO',
  );

  static const powerSyncUrl = String.fromEnvironment(
    'POWERSYNC_URL',
    defaultValue: 'https://EXEMPLO.powersync.journeyapps.com',
  );
}