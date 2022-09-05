drop database if exists vk;
create database vk;
use vk;

drop table if exists users;
create table users(
	id serial primary key, -- bigint unsigned not null auto_increment unique
	firstname varchar(100),
	lastname varchar(100),
	email varchar(120) unique,
	password_hash varchar(100),
	phone bigint unsigned,
	index users_lastname_firstname_idx(lastname, firstname)
);

drop table if exists profiles;
create table profiles (
	user_id serial primary key,
	gender char(1),
	birthdayd date,
	photo_id bigint unsigned,
	created_at datetime default now(),
	foreign key (user_id) references users(id) on update cascade on delete cascade
);

drop table if exists messages;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null, -- отправитель
	user_id bigint unsigned not null, -- получатель
	body text,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id) on update cascade on delete cascade,
	foreign key (user_id) references users(id) on update cascade on delete cascade
);

drop table if exists friend_requests; -- заявка в друзья
create table friend_requests(
	-- id serial primary key,
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'declined', 'unfriended'),
	requested_at datetime default now(),
	updateed_at datetime on update now(),
	primary key (initiator_user_id, target_user_id), -- составной первичный ключ
	foreign key (initiator_user_id) references users(id) on update cascade on delete cascade,
	foreign key (target_user_id) references users(id) on update cascade on delete cascade
);

drop table if exists communities;
create table communities(
	id serial primary key,
	name varchar(150),
	index communities_name_idx(name)
);

drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	communities_id bigint unsigned not null,
	primary key (user_id, communities_id),
	foreign key(user_id) references users(id) on update cascade on delete cascade,
	foreign key(communities_id) references communities(id) on update cascade on delete cascade
);

drop table if exists media_types;
create table media_types(
	id serial primary key,
	name varchar(255)
);

drop table if exists media;
create table media(
	id serial primary key,
	user_id bigint unsigned not null,
	media_type_id bigint unsigned,
	body text,
	filename varchar(255),
	size int,
	metadata json,
	created_at datetime default now(),
	update_at datetime default now(),
	foreign key (user_id) references users(id) on update cascade on delete cascade,
	foreign key (media_type_id) references media_types(id) on update cascade on delete set null
);

drop table if exists likes;
create table likes(
	id serial primary key,
	user_id bigint unsigned not null,
	media_id bigint unsigned not null,
	created_at datetime default now(),
	foreign key (user_id) references users(id) on update cascade on delete cascade,
	foreign key (media_id) references media(id) on update cascade on delete cascade
);

drop table if exists photo_album;
create table photo_album(
	id serial primary key,
	name varchar(255) default null,
	user_id bigint unsigned default null,
	foreign key (user_id) references users(id) on update cascade on delete cascade
);

drop table if exists photos;
create table photos(
	id serial primary key,
	album_id bigint unsigned not  null,
	media_id bigint unsigned not null,
	foreign key (album_id) references photo_album(id) on update cascade on delete cascade,
	foreign key (media_id) references media(id) on update cascade on delete cascade
);

alter table profiles add constraint fk_photo_id
foreign key (photo_id) references photos(id) on update cascade on delete set null;

drop table if exists gifts;
create table gifts(
	id serial primary key,
	users_id bigint unsigned not  null,
	media_id bigint unsigned not null,
	created_at datetime default now(),
	foreign key (users_id) references users(id) on update cascade on delete cascade,
	foreign key (media_id) references media(id) on update cascade on delete cascade
);

drop table if exists mailings;
create table mailings(
	id serial primary key,
	name varchar(255),
	body varchar(255),
	metadata json,
	created_at datetime default now(),
	index mailing_name_idx(name)
);

drop table if exists users_mailing;
create table users_mailing(
	user_id bigint unsigned not null,
	mailing_id bigint unsigned not null,
	primary key (user_id, mailing_id),
	foreign key (user_id) references users(id) on update cascade on delete cascade,
	foreign key (mailing_id) references mailings(id) on update cascade on delete cascade
);

drop table if exists telephons;
create table telephons (
	telephon_id bigint unsigned auto_increment  primary key,
	number varchar(100),
	name varchar(100),
	foreign key (telephon_id) references users(id) on update cascade on delete cascade
);
	

