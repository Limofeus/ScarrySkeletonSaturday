Как запустить:
- Godot 4.3
- Запустить проект (кнопка в верхнем правом углу или F5)

Для одиночной игры:
- Create Server
- Start Game

Для мультиплеера:
- Верхний левый угол редактора Отладка->Настроить запускаемые экземпляры
- Включить несколько экземпляров, и настроить число экземпляров
- Откроется несколько экземпляров приложения
- э1: Create Server
- э2,3,4,т.д.: Create Client
- э1: Start Game

ip и порт тоже работают, по локальной сети или эмулируя её через hamachi / radmin vpn можно запустить мультиплеер с нескольких машин.

Если перед созданием сервера нажать Dedicated server, то для экземпляра не будет создан игрок, в будущем это можно будет использовать с headless режимом.

![something0](./SCHEMES/upstream%20test%20screenshots/uts1.png)
Система компонентов
![something2](./SCHEMES/better%20ones/T6.png)
Синглтоны
![something2](./SCHEMES/better%20ones/T7.png)
Взаимодействия
![something1](./SCHEMES/better%20ones/T1.png)
![something2](./SCHEMES/better%20ones/T2.png)
Конвеер логики моба/игрока
![something2](./SCHEMES/better%20ones/T3.png)
Реакция на взаимодействия
![something2](./SCHEMES/better%20ones/T4.png)
![something2](./SCHEMES/better%20ones/T5.png)