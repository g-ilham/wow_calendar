### README

[![Build Status](https://api.travis-ci.org/g-ilham/wow_calendar.svg?branch=master)](https://travis-ci.org/g-ilham/wow_calendar)
[![security](https://hakiri.io/github/g-ilham/wow_calendar/master.svg)](http://hakiri.io/github/g-ilham/wow_calendar/master)
[![Code Climate](https://codeclimate.com/repos/565c07d8173b4cc9eb02524a/badges/440c8381e90deb9d9247/gpa.svg)](https://codeclimate.com/repos/565c07d8173b4cc9eb02524a/feed)
[![Coverage Status](https://coveralls.io/repos/g-ilham/wow_calendar/badge.svg?branch=master&service=github)](https://coveralls.io/github/g-ilham/wow_calendar?branch=master)

[DEMO URL](wowcalendar.herokuapp.com)

* Для удобства тестирования используйте логин через VK или Facebook

### Особенности реализации

##### 1. Повторяющиеся события

Функционал recurring событий полностью реализован на базе Sidekiq API.

1) После создания cобытия в планировщик добавляется Job-а согласно
   заданным настройкам повтора события (каждый день / неделя / месяц)
   на создание клона (Child) исходного события с заданной датой (delay_until).
   Job-a добавляется только одна для следующего (Next) события (а не для всех сразу).

2) В процессе выполнения Job-ы после создания нового "Child" события,
   в Sidekiq добавляется Job-a на следующий повтор события и.т.д

3) При удалении события или же при отмене "Повтора" cозданная Job-a удаляется и Sidekiq.

Работа с событиями реализована в интеракторах и сервисах:
[Интеракторы лежат здесь](https://github.com/g-ilham/wow_calendar/tree/master/app/interactors/events)
[Сервисы можно посмотреть тут](https://github.com/g-ilham/wow_calendar/blob/master/app/services/events)

##### 2. Календарь

1) В качестве Frontend плагина для календаря Я выбрал
[Full Calendar](http://fullcalendar.io/)

2) Реализовано добавление / редактирование / удаление через попап

3) Перенос даты события так же реализован через Drag & Drop

##### 3. Использование Heroku Addons

1) RedisToGo для Sidekiq

2) Sendgrid для отправки писем

##### 4. Использование DEV Tools сервисов

1) [Travis CI](https://travis-ci.org/g-ilham/wow_calendar) статус build-a
2) [Hakiri.io](https://hakiri.io/github/g-ilham/wow_calendar/master) сканирование уязвимостей
3) [CodeClimate](https://codeclimate.com) проверка качества кода
4) [Сoveralls.io](https://coveralls.io/github/g-ilham/wow_calendar?branch=master) степень покрытия тестами

* Данные виджеты отображены в начале README ^

### Дополнительно реализованный фукнционал

##### 1. Авторизация через Вконтакте и Facebook (c полгрузкой аватарки)

##### 2. Google Captcha на регистрации через Email

##### 3. В качестве Landing секций использована UI тема

[TRANSIT LADNING](http://templated.co/transit)

##### 4. Для Dashboard использована UI тема

[DASHGUM](http://www.blacktie.co/demo/dashgum/)

### Установка

```
git clone git@github.com:g-ilham/wow_calendar.git
cd wow_calendar
bundle
rake db:create
rake db:migrate
```

### Тесты

```
RAILS_ENV=test bundle exec rake db:setup
RAILS_ENV=test COVERAGE=true COVERALLS_RUN_LOCALLY=true bundle exec rspec spec
```

### Deploy

```
heroku login
heroku create
git push heroku master
```
[Подробнее](https://devcenter.heroku.com/articles/getting-started-with-rails4)
