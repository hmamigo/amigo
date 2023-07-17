# amigo

**EN**: Simple and friendly file manager for the console. Inspired by clifm.

**ES**: Simple y amigable administrador de archivos para la consola. Inspirado en clifm.

**PT**: Gerenciador de arquivos simples e amigável para o console. Inspirado no clifm.

**DE**: Einfacher und freundlicher Dateimanager für die Konsole. Inspiriert von clifm.

**FR**: Gestionnaire de fichiers simple et convivial pour la console. Inspiré par clifm.

**IT**: Gestore di file semplice e amichevole per la console. Ispirato da clifm.

**RU**: Простой и удобный файловый менеджер для консоли. Вдохновленный clifm.

**ZH**: 简单友好的控制台文件管理器。灵感来自clifm。

## Install
```bash
$ git clone https://github.com/hmamigo/amigo.git
$ cd amigo
$ dart compile exe bin/amigo.dart -o amigo      # Linux, MacOS, Termux (Android)
$ dart compile exe bin/amigo.dart -o amigo.exe  # Windows
$ sudo mv amigo /usr/local/bin
```

## Use
```bash
$ amigo
```

### Keys
| Key | Action |
| --- | ------ |
| `h` | Help |
| `.` | Show or hide hidden files |
| `0` | Go up one level |
| `nf` | Create new file |
| `nd` | Create new directory |
| `d` | Delete file or directory |
| `q` | Quit |

## Screenshots
![Animated screenshot](https://raw.githubusercontent.com/hmamigo/amigo/master/screenshots/1.gif)


## TODO
- [x] Create files
- [ ] Create directories
- [ ] Copy files
- [ ] Move files
- [x] Delete files
- [ ] Delete directories
- [ ] Rename files
- [ ] Rename directories
- [ ] Search files
- [x] Show/Hide hidden files

## License
MIT License

