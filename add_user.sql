

create user 'wordpress'@'%' identified by 'wordpress';
create database wordpress;
grant all on wordpress.* to 'wordpress'@'%';
drop user ''@'localhost';

