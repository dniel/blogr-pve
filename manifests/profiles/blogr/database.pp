class pve::profiles::blogr::database(
  $db_name,
  $db_user,
  $db_password
){
  require postgresql::server

  postgresql::server::db { $name:
    user     => $user,
    password => postgresql_password($user, $password),
  }

  postgresql::server::role { $user:
    password_hash => postgresql_password($user, $password),
  }

  postgresql::server::table_grant { "grant INSERT to table post of ${name}":
    privilege => 'INSERT',
    table     => 'posts',
    db        => $name,
    role      => $user,
    require     => Postgresql::Server::Db[$name],
  }
  postgresql::server::table_grant { "grant DELETE to table post of ${name}":
    privilege => 'DELETE',
    table     => 'posts',
    db        => $name,
    role      => $user,
    require   => Postgresql::Server::Db[$name],
  }
  postgresql::server::table_grant { "grant SELECT to table post of ${name}":
    privilege => 'SELECT',
    table     => 'posts',
    db        => $name,
    role      => $user,
    require     => Postgresql::Server::Db[$name],
  }
  postgresql::server::database_grant { "GRANT ALL ${user} - ${name}:":
    privilege   => "ALL",
    db          => $name,
    role        => $user,
    require     => Postgresql::Server::Db[$name],
  }

  postgresql_psql { "create posts table ":
    db          => $name,
    command     => "create table IF NOT EXISTS posts (
                      id serial primary key,
                      title varchar(50) not null default '',
                      owner varchar(30) not null default '',
                      body varchar(1000) not null default '',
                      created timestamptz not null default now(),
                      updated timestamptz not null default now());",
    unless      => "SELECT table_schema||'.'||table_name AS full_rel_name
                    FROM information_schema.tables
                    WHERE table_schema = 'public' and table_name = 'posts'",

    require     => Postgresql::Server::Db[$name],
  }

}