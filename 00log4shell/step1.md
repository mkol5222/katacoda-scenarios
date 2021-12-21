
## All in log4shell_finders one demo

Install Java 11
`apt update; apt install default-jdk -y`{{execute}}
`JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/`{{execute}}
`PATH=$JAVA_HOME/bin:$PATH`{{execute}}

Grab first sample app (this one is Maven based)
`cd`{{execute}}
`git clone https://github.com/sunnyvale-it/CVE-2021-44228-PoC.git`{{execute}}
`cd CVE-2021-44228-PoC`{{execute}}
`mvn package`{{execute}}
`cd`{{execute}}
`find .m2`{{execute}}

Grab second sample app (Gradle based)
`cd`{{execute}}
`git clone https://github.com/christophetd/log4shell-vulnerable-app.git`{{execute}}
`cd log4shell-vulnerable-app`{{execute}}
`./gradlew build`{{execute}}
`find . -name '*.jar'`{{execute}}


Install Powershell
`cd`{{execute}}
`snap install powershell --classic`{{execute}}

Get Check Point finder scrip (SK176951)
`curl -O https://gist.githubusercontent.com/chkp-mkoldov/7e2c0b0f156a3be44dfa9c3916a9c640/raw/65c64c80a6969f76a873b78942a06626321e1f32/log4shell_finders.ps1`{{execute}}

Run checks
`powershell ./log4shell_finders.ps1`{{execute}}