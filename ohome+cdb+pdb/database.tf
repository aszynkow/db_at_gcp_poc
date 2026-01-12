resource "oci_database_db_home" "dbhome" {
  db_version = var.ohome_db_version
  display_name = var.ohome_display_name
  #is_unified_auditing_enabled = false
  source = var.ohome_source
  vm_cluster_id = var.vm_cluster_id
}
resource "oci_database_database" "cdb_database" {
  database {
    admin_password = var.database_database_admin_password 
    character_set = var.database_database_character_set 
    db_backup_config {
      auto_backup_enabled = var.auto_backup_enabled
      #backup_window = var.auto_backup_window
    }
    db_name        = var.database_database_db_name
    db_workload    = var.database_database_source
    ncharacter_set = var.db_db_ncharacter_set
    sid_prefix     = var.database_database_sid_prefix
  }
  db_home_id = oci_database_db_home.dbhome.id
  source = var.database_database_source
  lifecycle {
    ignore_changes = [database[0].admin_password, source]
  }
}
 
resource "oci_database_pluggable_database" "pluggable_database_1" {
  container_database_id = oci_database_database.cdb_database.id
  pdb_name = var.pluggable_database_name[1]
  pdb_admin_password = var.pdb_admin_password[1]
  tde_wallet_password = var.pluggable_database_tde_wallet_password[1]
}