# Harbour_Samples
Used to demonstrate simple Harbour programs, to compile and run in MS Windows or Linux (tested in Ubuntu).

Each sample program is located in its own folder and has two related .code-workspace VSCODE workspace file, one when building under MS Windows, the other one under Linux.   
The files in the BuildTools folder of this repo are used by all samples.   

Each sample also has settings to run using Dev Containers.

To learn about how to use VSCode for Harbour, review the article: https://harbour.wiki/index.asp?page=PublicArticles&mode=show&id=190401174818&sig=6893630672   
To learn about how to use WSL/Docker/Ubuntu for Harbour, review the article https://harbour.wiki/index.asp?page=PublicArticles&mode=show&id=221022022831&sig=9123873596

Please update the file vscode_debugger.prg using the VSCODE "Harbour: Get debugger code" command.   

## List of Samples:
Folder | Covered Features
------------ | -------------
HelloHarbour | OutputDebugString<br>For Loop<br>C code in PRG file<br>Text Obfuscation<br>Preprocessor Directives<br>Code-based debugger breakpoint<br>Dev Containers and Ubuntu
HarbourClasses | Class include<br>Classes and Objects<br>Multi-PRG Class definition
Codeblocks | Codeblocks<br>Searching multi-dimension arrays
LocalTables | Creating dbf tables and indexes files<br>Creating VFP compatible tables and multi tag indexes<br>Use of multiple workareas
ClientAPI | Calling external APIs. To be used with Dev Containers only for now.
WebSite | Basic Hello World (Hello Harbour) website. To be used with Dev Containers only for now.

## Developing with Dev Containers
Run and debug your code in Linux while editing your code in your host OS, like Windows/Mac. All your code remain in your local file system and is mounted in the docker container.   
The HelloHarbour example has all the files needed to test out "Dev Containers".   
Install the "Dev Containers" extension in VSCode.   
Under Microsoft Windows use WSL2 and the Ubuntu 20.04 distro or newer.   
[For more info about developing in a Docker container](https://code.visualstudio.com/docs/remote/remote-overview)   

## Installing WSL in Windows
Please review the article https://harbour.wiki/index.asp?page=PublicArticles&mode=show&id=221022022831&sig=9123873596   

## Additional Debugging instructions Under Linux

**Goal:** Have Microsoft Windows DebugView like messages in Linux.   
**Solution:** Use the syslog C api to send message in the syslog system. Those message are sent via UDP messages that need to be captured by a syslog compatible server.   
By default on Ubuntu 20+ the syslog messages are captured/processed by the rsyslog service.   
In turn that rsyslog service can write the message to a log file.   
By default all messages are writen to /var/log/syslog   
To view the last 20 message use the following:   
```
$ tail -f -n20 /var/log/syslog   
```
To only view your Harbour app message we could use:   
```
$ tail -f -n20 /var/log/syslog | grep "\[Harbour\]"   
```
BUT since that log files gets message for all apps and the Linux kernel the last 20 are not necessarily your Harbour App. The "grep" filtering piped command will not guarantee 20 [Harbour] messages.   

If needed install rsyslog and nano (or any other editor you know how to use).   
```
$ sudo apt-get install -y nano rsyslog   
```

To make it easier to view your Harbour app messages, sent those messages to a separate log file.   

FYI if you cat /etc/rsyslog.conf it will display the following:   
    $IncludeConfig /etc/rsyslog.d/*.conf   
Meaning any .conf files in the /etc/rsyslog.d/ folder will be also used.   

Create a file /etc/rsyslog.d/harbour.conf   
```
$ sudo nano /etc/rsyslog.d/harbour.conf   
    Add the following line:   
        local1.debug -/var/log/harbourapps.log   
    To save and exist the editor: CTRL+O and Enter, then CTRL+X   
```

FYI the "local1" and "debug" are match with the following code in the Harbour app:   
```
    setlogmask(LOG_UPTO (LOG_DEBUG));   
    openlog("[Harbour]", LOG_PID | LOG_NDELAY, LOG_LOCAL1);   
    syslog(LOG_DEBUG, hb_parc(1));   
    closelog();   
```

```
$ sudo service rsyslog restart   
```

To constantly display the lat 20 lines for the syslog file use the following command:   
```
tail -f -n20 /var/log/harbourapps.log   
To exist press CTRL+SHIFT+C or CTRL+C   
```
The samples apps will only send to DebugView or SysLog messages when compiling and running in debug mode.   

## Warning
Currently SysLog tracing does not work under WSL (Windows Subsystem for Linux) except under Windows 11 with Microsoft Store version of Ubuntu Distro.   
The docker configuration in this repo, using the Dockerfile(s), can not start the service rsyslog if using the WSL engine, meaning.   