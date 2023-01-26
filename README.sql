/*БД интернет-магазина обуви. Состоит из 9 таблиц
 * позволяет пользователю выбирать товар, делать заказ, 
 * присутствует корзина заказа в виде таблицы orders_products,
 * каталог, скидки на товар и другие таблицы.
 */ 
drop database if exists sneakers;
create database sneakers;
use sneakers;
-- serial - bigint unsigned not null auto_increment unique

-- производитель товаров
drop table if exists manufacturer;
create table manufacturer (
id serial primary key,
name varchar(255),
description varchar(255)
); -- 1 nike 2 adidas 3 puma 4 reebok manufacturer
insert into  manufacturer (id, name, description)
values
	('1', 'Nike', 'Американский производитель'),
	('2', 'Adidas', 'Английсский производитель'),
	('3', 'Puma','Китайский производитель'),
	('4', 'Reebok', 'Немецкий производитель');

-- товар 
drop table if exists products;
create table products (
id serial primary key,
name varchar(255),
price decimal (8,2),
description text,
catalog_id bigint unsigned,
manufacturer_id bigint unsigned,
created_at datetime default now(),
updated_at datetime default now(),
index products_name_idx (name),
foreign key (manufacturer_id) references manufacturer(id)
on delete cascade on update cascade
);
insert into products (id, name, price, description, catalog_id, manufacturer_id) 
values
  ('1', 'nikeair90', '2000.50', 'отличные кроссовки для бега', '1', '1'),
  ('2', 'nikeair87', '2500', 'классные кроссовки для бега', '1', '1'),
  ('3', 'nikeair80', '2500', 'отличные кроссовки для урбана', '2', '1'),
  ('4', 'nikeair95', '3000.30', 'баскетбольные легенды', '3', '1'),
  ('5', 'nikeair97', '3200.10', 'городские мейнстримы', '2', '1'),
  ('6', 'adidasZX', '1800', 'отличные неубиваемые кроссовки', '2', '2'),
  ('7', 'adidasZX750', '2100', 'лучший уровень кроссовок', '3', '2'),
  ('8', 'adidasLondon', '3400', 'лондонские денди', '2', '2'),
  ('9', 'adidasNate', '1900', 'невесомые кроссовки', '1', '2'),
  ('10', 'pumaClassic', '5000', 'для отличной прогулки', '1', '3'),
  ('11', 'pumaRDS700', '4300.50', 'гоночные кроссовки', '3', '3'),
  ('12', 'reebokClassic', '1900.50', 'классика в тонах', '3', '4');

-- фото каждого товара
drop table if exists photos;
create table photos (
photo_id serial primary key,
body json,
created_at datetime default now(),
updated_at datetime default now(),
foreign key (photo_id) references products(id) on update cascade on delete cascade
);
insert into photos (photo_id, body)
values
	('1', '1'),
	('2', '1'),
	('3', '1'),
	('4', '1'),
	('5', '1'),
	('6', '1'),
	('7', '1'),
	('8', '1'),
	('9', '1'),
	('10', '1'),
	('11', '1'),
	('12', '1');
	
-- каталоги товаров
drop table if exists catalogs;
create table catalogs (
id serial primary key,
name varchar(255)
);
-- 1 для бега, 2 урбан, 3 баскетбол catalog
insert into catalogs (id, name)
values
	('1', 'Для бега'),
	('2', 'Для урбана'),
	('3', 'Для басскетбола');
alter table products add constraint fk_catalog_id
foreign key (catalog_id) references catalogs(id)
on delete cascade on update cascade;

-- заказы
drop table if exists orders;
create table orders (
id serial primary key,
user_id bigint unsigned,
payment_id bigint unsigned, -- оплата нал/карта
created_at datetime default now(),
update_at datetime default now() on update now()
);
insert into orders (id, user_id, payment_id)
values
	('1', '1', '1'),
	('2', '2', '1'),
	('3', '4', '2'),
	('4', '4', '1'),
	('5', '4', '2'),
	('6', '8', '2'),
	('7', '9', '1'),
	('8', '9', '2'),
	('9', '11', '1'),
	('10', '12', '1');
	
-- оплата
drop table if exists payments;
create table payments (
id serial primary key,
name varchar(255)
);
insert into payments (id, name)
values
	('1', 'Visa'),
	('2', 'Mastercard');
alter table orders add constraint fk_payment_id
foreign key (payment_id) references payments(id)
on delete cascade on update cascade;

-- промежуточная таблица заказы
drop table if exists orders_products;
create table orders_products (
primary key (order_id, product_id),
order_id bigint(20) unsigned not null, -- ид заказа
product_id bigint(20) unsigned not null, -- ид товара
total int, -- колличество заказанных товаров
foreign key (order_id) references orders(id) on delete cascade on update cascade,
foreign key (product_id) references products(id) on delete cascade on update cascade
);
insert into orders_products (order_id, product_id, total)
values
	('1', '2', '1'),
	('2', '1', '2'),
	('3', '3', '2'),
	('4', '4', '2'),
	('5', '7', '2'),
	('6', '6', '5'),
	('7', '7', '3'),
	('8', '3', '4'),
	('9', '11', '2'),
	('10', '12', '1');

-- пользователь, заказчик, клиент
drop table if exists users;
create table users(
id serial primary key,
name varchar(255),
birthday_at date,
telephone varchar(255),
mail varchar(255),
created_at datetime default now(),
updated_at datetime default now()
);
insert into users(id, name, birthday_at, telephone, mail)
values
	('1', 'Paul', '2000-09-27', '89011112233', 'paul@mail1.ru'),
	('2', 'Maxim', '2001-10-23', '89012223435', 'paul@mail2.ru'),
	('3', 'Oleg', '2002-11-24', '890245677893', 'paul@mail3.ru'),
	('4', 'Olga', '2003-08-17', '89038097658', 'paul@mail4.ru'),
	('5', 'Oksana', '1991-10-07', '89018847657', 'paul@mail5.ru'),
	('6', 'Petr', '1992-01-05', '89015018987', 'paul@mail6.ru'),
	('7', 'Fadey', '1987-03-14', '89013674597', 'paul@mail7.ru'),
	('8', 'Sergey', '2005-09-17', '89013457690', 'paul@mail8.ru'),
	('9', 'Anna', '1989-11-25', '89163248956', 'paul@mail9.ru'),
	('10', 'Dmitry', '2000-06-18', '89087980453', 'paul@mail10.ru'),
	('11', 'kristina', '1990-05-30', '89013287659', 'paul@mail11.ru'),
	('12', 'Roman', '1999-08-12', '89011245695', 'paul@mail12.ru');
alter table orders add constraint fk_order_user_id
foreign key (user_id) references users(id) 
on delete cascade on update cascade;

-- таблица скидок
drop table if exists discounts;
create table discounts (
id serial primary key,
user_id bigint unsigned,
product_id bigint unsigned,
discount float(8,2),
started_at datetime,
finished_at datetime,
foreign key (user_id) references users(id) on delete cascade on update cascade,
foreign key (product_id) references products(id) on delete cascade on update cascade
);
insert into discounts (id, user_id, product_id, discount, started_at, finished_at) 
values
	('1','1', '1', '0.1', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('2','1', '3', '0.1', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('3','2', '4', '0.2', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('4','2', '7', '0.25', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('5','2', '11', '0.5', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('6','2', '2', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('7','2', '5', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('8','2', '6', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('9','3', '8', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('10','3', '9', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('11','3', '10', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00'),
	('12','3', '12', '0', '2022-09-27 15:25:35', '2022-12-25 11:30:00');








/* Задача 1
Найти пользователя, который сделал больше всего заказов.
*/
select u.name, count(*) as total_order
from orders o join users u 
on u.id = o.user_id 
group by u.id
order by total_order desc
limit 1;

/* Задача 2
Вывести пользователя и его день рождение, у которого больше всего товаров в одном заказе.
*/
select u.name, u.birthday_at, op.total as total_product
from orders_products op 
join orders o on op.order_id = o.id
join users u on o.user_id = u.id
order by total_product desc
limit 1;

/* Задача 3
Найти пользователя, который купил больше всего товаров за всё время своих заказов.
*/
select u.name, sum(op.total) as total
from orders_products op 
join orders o on op.order_id = o.id
join users u on o.user_id = u.id
group by u.id
order by total desc
limit 1;

/* Задача 4
Какой платёжной системой реже пользовались пользователи, оплачивая заказы.
*/
select p.name, count(*) as total
from payments p 
join orders o on p.id = o.payment_id
group by p.id
order by total
limit 1;

/* Задача 5
Вывести название и описание товара, к какому произволителю он принадлежит,
к какому каталогу относится.
Для товара Adidas, который больше всего купили 
*/
select p.name,p.description, m.name, c.name, count(*) as total
from products p
join orders_products op on p.id = op.product_id
join manufacturer m on p.manufacturer_id = m.id
join catalogs c on p.catalog_id = c.id
group by p.name
having m.name = 'Adidas'
order by total desc
limit 1;

/* Задача 6
Вывести стоимость товаров, у которых есть скидка, 
учитывая стоимость с учётом скидки на товар.
*/
select p.name, (p.price -(p.price * d.discount)) as price from products p
join discounts d on p.id = d.product_id
where d.discount <> '0';


/* Представление 1.
 * Создать представление, которое выводит name из таблицы products и
 * соответсвующее name из catalogs
 */
create or replace view products_catalogs as 
select p.name product_name, c.name catalog_name
from products p join catalogs c
on p.catalog_id = c.id;
-- выводим представление
select * from products_catalogs; 

/* Представление 2.
 * Создать представление, которое выводит name из таблицы users и
 * соответсвующее поле discount из таблицы discounts
 */
create or replace view users_discounts as
select u.name users_name, d.discount discount_price
from users u join discounts d
on u.id = d.user_id;
-- выводим представление
select * from users_discounts; 


/*Хранимая функция 1.
 * Возвратим значение, хранящееся в таблице products под id=1/
 */
drop function if exists show_product;
delimiter //
create function show_product ()
returns text no sql
begin
	return (select name from products where id=1);
end//
delimiter ;
select show_product();

/*Хранимая функция 2.
 * Возвратим значение, хранящееся в таблице products под id=1/
 */
drop function if exists maximum_discount;
delimiter //
create function maximum_discount ()
returns text no sql
begin
	return (select max(discount) from discounts);
end//
delimiter ;
select maximum_discount();


/*Триггер 1.
 * Поле name в таблице catalogs сегда должно быть заполнено,
 * иначе операция отменяется командой 45000
 */
drop trigger if exists insert_not_null;
delimiter //
create trigger insert_not_null before insert on catalogs
for each row
begin 
	if new.name is null then 
	signal sqlstate '45000';
end if;
end//
delimiter ;
-- проверка
insert into catalogs values (null, null);

/*Триггер 2.
 * Поле name в таблице manufacturer сегда должно быть заполнено,
 * иначе операция отменяется командой 45000
 */
drop trigger if exists update_not_null;
delimiter //
create trigger update_not_null before update on manufacturer
for each row
begin 
	if new.name is null then 
	signal sqlstate '45000';
end if;
end// 
delimiter ;
-- проверка
update manufacturer set name =null;

