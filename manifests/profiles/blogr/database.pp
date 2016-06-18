class pve::profiles::blogr::database{
  require postgresql::server
  $db = hiera_hash('pve::profiles::database')

  vcsrepo { '/opt/blogr':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/dniel/blogr-workshop'
  }

  postgresql::server::db { "${db['name']}":
    user     => "${db['user']}",
    password => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::role { "${db['user']}":
    password_hash => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::table_grant { "grant to table post of ${db['name']}":
    privilege => 'SELECT',
    table     => 'posts',
    db        => "${db['name']}",
    role      => "${db['user']}",
    require     => Postgresql::Server::Db["${db['name']}"],
  }

  postgresql::server::database_grant { "GRANT ALL ${db['user']} - ${db['name']}:":
    privilege   => "ALL",
    db          => "${db['name']}",
    role        => "${db['user']}",
    require     => Postgresql::Server::Db["${db['name']}"],
  }

  postgresql_psql { "create posts table ":
    db          => "${db['name']}",
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

    require     => Postgresql::Server::Db["${db['name']}"],
  }

}