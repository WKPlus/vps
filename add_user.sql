

create user 'wordpress'@'localhost' identified by 'wordpress';
create database wordpress;
grant all on wordpress.* to 'wordpress'@'localhost';
drop user ''@'localhost';

