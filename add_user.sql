

create user 'wordpress'@'localhost' identified by 'xxx';
create database wordpress;
grant all on wordpress.* to 'wordpress'@'localhost';
drop user ''@'localhost';

