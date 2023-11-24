# keenetic

### Install python
```shell
opkg install python3
```

### Install rclone
```shell
opkg install rclone
rclone config
```

### ssh copy id
```shell
cat ~/.ssh/id_rsa.pub | ssh root@myrouter.keenetic.link -p 222 "cat >> /opt/etc/dropbear/authorized_keys && chmod 600 /opt/etc/dropbear/authorized_keys"
```
### rclone
```shell
# Синхронизация файлов на локальной машине и в хранилище
rclone sync "/tmp/mnt/TOSHIBA EXT/Backup" mega:backups:keenetic-ultra-disk 
```

## Ссылки
- [Как настроить CloudFlare VPN на роутере Keenetic, чтобы только определенные сайты открывались через VPN](https://vk.com/@insane_su-kak-nastroit-cloudflare-vpn-na-routere-keenetic-chtoby-tolko)
- [Установка OPKG Entware на встроенную память роутера](https://help.keenetic.com/hc/ru/articles/360021888880)
- [Установка системы пакетов репозитория Entware на USB-накопитель](https://help.keenetic.com/hc/ru/articles/360021214160-%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B-%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%BE%D0%B2-%D1%80%D0%B5%D0%BF%D0%BE%D0%B7%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D1%8F-Entware-%D0%BD%D0%B0-USB-%D0%BD%D0%B0%D0%BA%D0%BE%D0%BF%D0%B8%D1%82%D0%B5%D0%BB%D1%8C)
- [Выборочный роутинг через VPN туннель](https://forum.keenetic.com/topic/8106-%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BE%D1%87%D0%BD%D1%8B%D0%B9-%D1%80%D0%BE%D1%83%D1%82%D0%B8%D0%BD%D0%B3-%D1%87%D0%B5%D1%80%D0%B5%D0%B7-vpn-%D1%82%D1%83%D0%BD%D0%BD%D0%B5%D0%BB%D1%8C/)
- [Планировщик заданий cron в Entware](http://forums.zyxmon.org/viewtopic.php?f=5&t=5257)
