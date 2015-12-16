### WOW CALENDAR (Мой тестовый проект)

[![Build Status](https://api.travis-ci.org/g-ilham/wow_calendar.svg?branch=master)](https://travis-ci.org/g-ilham/wow_calendar)
[![security](https://hakiri.io/github/g-ilham/wow_calendar/master.svg)](http://hakiri.io/github/g-ilham/wow_calendar/master)
[![Code Climate](https://codeclimate.com/repos/565c07d8173b4cc9eb02524a/badges/440c8381e90deb9d9247/gpa.svg)](https://codeclimate.com/repos/565c07d8173b4cc9eb02524a/feed)
[![Coverage Status](https://coveralls.io/repos/g-ilham/wow_calendar/badge.svg?branch=master&service=github)](https://coveralls.io/github/g-ilham/wow_calendar?branch=master)

[DEMO URL](http://wowcalendar.herokuapp.com/)

> Для удобства тестирования используйте логин через VK или Facebook

![Logo](https://raw.githubusercontent.com/g-ilham/wow_calendar/master/lib/readme_images/landing_preview.png)

### Особенности реализации

##### 1. Версии

* Ruby 2.2.3 / Rails 4.2.5 / PostgreSQL

##### 2. Повторяющиеся события

Функционал recurring событий полностью реализован на базе Sidekiq API.

* После создания cобытия в планировщик добавляется Job-а согласно заданным настройкам повтора события (каждый день / неделя / месяц). В Job-e создается клон (Child) исходного события с заданной датой (delay_until). Job-a добавляется только одна для следующего (Next) события (а не для всех сразу).

* В процессе выполнения Job-ы после создания нового "Child" события, в Sidekiq добавляется Job-a на следующий повтор события и.т.д

* При удалении события или же при отмене "Повтора" cозданная Job-a удаляется.

Работа с событиями реализована в интеракторах и сервисах:

* [Интеракторы лежат здесь](https://github.com/g-ilham/wow_calendar/tree/master/app/interactors/events)
* [Сервисы можно посмотреть тут](https://github.com/g-ilham/wow_calendar/blob/master/app/services/events)

##### 3. Календарь

* В качестве Frontend плагина для календаря Я выбрал [Full Calendar](http://fullcalendar.io/)
* Реализовано добавление / редактирование / удаление через попап
* Так же реализован перенос события через Drag & Drop

##### 4. Используемые Heroku Addons

* RedisToGo для Sidekiq
* Sendgrid для отправки писем

##### 5. Использование DEV Tools сервисов

* [Travis CI](https://travis-ci.org/g-ilham/wow_calendar) статус build-a
* [Hakiri.io](https://hakiri.io/github/g-ilham/wow_calendar/master) сканирование уязвимостей
* [CodeClimate](https://codeclimate.com) проверка качества кода
* [Сoveralls.io](https://coveralls.io/github/g-ilham/wow_calendar?branch=master) cтепень покрытия тестами

> Данные виджеты отображены в начале README ^

### Дополнительно реализованный функционал

* Авторизация через Вконтакте и Facebook (c подгрузкой аватарки)
* Google Captcha на регистрации через Email
* В качестве Landing секций использована UI тема [TRANSIT LADNING](http://templated.co/transit)
* Для Dashboard использована UI тема [DASHGUM](http://www.blacktie.co/demo/dashgum/)
* Код покрыт Rspec тестами на 92% [Посмотреть покрытие](https://coveralls.io/github/g-ilham/wow_calendar?branch=master)

### Установка

```
git clone git@github.com:g-ilham/wow_calendar.git
cd wow_calendar
cp config/database.yml.example config/database.yml
cp .env.example .env
bundle
rake db:create
rake db:migrate
foreman start
```
> В файлике .env.example находятся тестовые ключи для Google Captcha и Oauth Вконтакте и Facebook.
  Обычно я НЕ ВЫКЛАДЫВАЮ credentials в github (даже если репо приватный).
  Просто без них будет трудно запустить приложение на localhost.
  Поэтому их и добавил.

### Тесты

```
cp .coveralls.yml.example .coveralls.yml
RAILS_ENV=test bundle exec rake db:setup
RAILS_ENV=test COVERAGE=true COVERALLS_RUN_LOCALLY=true bundle exec rspec spec/
```

### Deploy

```
heroku login
heroku create
git push heroku master
```
