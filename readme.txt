# BC系统开发环境配置

检出 c-system 系统源代码：
$ ./bc-start/start.sh [options]

options 选项说明：
-r  运行系统，即对 bc-system 执行 $ mvn jetty:run -Ppostgresql
-cr 清理后再运行系统，即对 bc-system 执行 $ mvn clean jetty:run -Ppostgresql
-s  检出所有模块的源代码，如 $ ./bc-start/start.sh -s
-i  对检出的模块源代码执行 $ mvn install -Dmaven.test.skip=true
-ci 对检出的模块源代码执行 $ mvn clean install -Dmaven.test.skip=true
-u  更新所有模块的源代码，即对所有模块执行 $ git pull origin master
