#!/usr/bin/env bash

###############################################################################
# 系统源代码批量clean install deploy脚本
# $ ./bc-start/maven.sh [options]
# options 选项说明：
# -c  执行 mvn clean -Dmaven.test.skip=true
# -i  执行 mvn install -Dmaven.test.skip=true
# -d  执行 mvn deploy -Dmaven.test.skip=true
###############################################################################

# 取得当前正在执行脚本的绝对路径
root_dir=$(pwd)

# mvn clean install deploy
function maven() { 
	if [[ -d $1 ]]; then
		cd $1

		if [[ $2 == -*c* ]]; then
			mvn clean -Dmaven.test.skip=true
		fi

		if [[ $2 == -*i* ]]; then
			mvn install -Dmaven.test.skip=true
		fi

		if [[ $2 == -*d* ]]; then
			mvn deploy -Dmaven.test.skip=true
		fi

		cd ..
	else
		p=$(pwd)
		echo "dir not exists for 'mvn_do $2': $p/$1"
	fi
}

if [[ ! $1 ]]; then
	# echo 'nothing to do. please tell me any of option -cid to do mvn clean install or/and deploy'
	echo 'Usage: ./bc-start/maven.sh [options]'
	echo ' -c excute "mvn clean -Dmaven.test.skip=true"'
	echo ' -i excute "mvn install -Dmaven.test.skip=true"'
	echo ' -d excute "mvn deploy -Dmaven.test.skip=true"'
	exit 0
fi

ts=$(date '+%Y-%m-%d %H:%M:%S')
echo "$ts 开始..."
cd $root_dir

# 对各模块执行 maven 命令
maven 'bc-framework' $1
maven 'bc-workflow' $1

maven 'bc-attendance' $1
maven 'bc-cert' $1
maven 'bc-pmc' $1

maven 'bc-business' $1
maven 'bc-business-workflow' $1

maven 'bc-business-arrange' $1
maven 'bc-business-cartax' $1
maven 'bc-business-cert' $1
maven 'bc-business-hcjtz' $1
maven 'bc-business-workplan' $1
cd ..

echo "$(date '+%Y-%m-%d %H:%M:%S') 结束 (开始于 $ts)"
exit 0
