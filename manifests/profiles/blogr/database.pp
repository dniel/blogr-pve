class pve::profiles::blogr::database(
  $db_name,
  $db_user,
  $db_password
){
  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_password),
  }->
  postgresql::server::database_grant { "GRANT ALL ${db_user} - ${db_name}:":
    privilege => 'ALL',
    db        => $db_name,
    role      => $db_user,
  }
}