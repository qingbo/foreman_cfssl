create table certs (
  id serial primary key,
  user_id integer,
  owner_email varchar(255),
  imported_at timestamp,
  profile varchar(255),
  subject text,
  issuer text,
  serial_number varchar(255),
  sans text,
  not_before timestamp,
  not_after timestamp,
  sigalg varchar(255),
  authority_key_id varchar(255),
  subject_key_id varchar(255),
  pem text not null,
  key text
);

create index index_certs_owner_email on certs (owner_email);
create index index_certs_not_after on certs (not_after);
