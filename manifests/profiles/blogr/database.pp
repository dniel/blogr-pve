class pve::profiles::blogr::database(
  $db_name,
  $db_user,
  $db_password
){
  postgresql::server::db { $name:
    user     => $user,
    password => postgresql_password($user, $password),
  }->
  postgresql::server::database_grant { "GRANT ALL ${user} - ${name}:":
    privilege => 'ALL',
    db        => $name,
    role      => $user,
  }
}