#!/usr/bin/env bash

###############################################################################
# 系统源代码批量检出脚本
###############################################################################

# 取得当前正在执行脚本的绝对路径
root_dir=$(pwd)

# git仓库的基本参数
ip=192.168.0.222
git_server=git@$ip

# 检出git仓库
function git_clone() { 
	if [[ ! -d $1 ]]; then
		if [[ $2 ]]; then
			git clone $git_server:$2.git $1
		else
			git clone $git_server:$1.git
		fi
	else
		p=$(pwd)
		if [[ $2 ]]; then
			echo "git repo exists: $2.git > $p/$1"
		else
			echo "git repo exists: $1.git > $p/$1"
		fi
	fi
}

# git pull origin master
function git_pull() { 
	if [[ -d $1 ]]; then
		cd $1
		git pull origin master
		cd ..
	else
		p=$(pwd)
		echo "dir not exists for 'git pull': $p/$1"
	fi
}

# mvn install
function mvn_install() { 
	if [[ -d $1 ]]; then
		cd $1
		if [[ $clean == 'true' ]]; then
			mvn clean install -Dmaven.test.skip=true
		else
			mvn install -Dmaven.test.skip=true
		fi
		cd ..
	else
		p=$(pwd)
		echo "dir not exists for 'mvn install': $p/$1"
	fi
}

ts=$(date '+%Y-%m-%d %H:%M:%S')
echo "$ts 开始..."
if [[ $1 == -*c* ]]; then
	clean='true'
	echo $clean
fi

echo '检出git仓库...'

# 检出bc-system全部
git_clone 'bc-system'
cd 'bc-system/src/main/webapp'
git_clone 'ui-libs'
git_clone 'ui-libs-demo'
git_clone 'bc' 'bc-framework-webapp'
git_clone 'bc-workflow' 'bc-workflow-webapp'
git_clone 'bc-test' 'bc-test-webapp'
git_clone 'bc-business' 'bc-business-webapp'
git_clone 'bc-business-workflow' 'bc-business-workflow-webapp'
# webapp/modules/bc/*
mkdir -p $root_dir/bc-system/src/main/webapp/modules/bc
cd $root_dir/bc-system/src/main/webapp/modules/bc
git_clone 'attendance' 'bc-attendance-webapp'
git_clone 'pmc' 'bc-pmc-webapp'
git_clone 'cert' 'bc-cert-webapp'
git_clone 'attendance' 'bc-attendance-webapp'
# webapp/modules/bs/*
mkdir -p $root_dir/bc-system/src/main/webapp/modules/bs
cd $root_dir/bc-system/src/main/webapp/modules/bs
git_clone 'arrange' 'bc-business-arrange-webapp'
git_clone 'cartax' 'bc-business-cartax-webapp'
git_clone 'workplan' 'bc-business-workplan-webapp'
git_clone 'cert' 'bc-business-cert-webapp'


cd $root_dir

# 检出其他模块的后台源码: -s
if [[ $1 == -*s* ]]; then
	git_clone 'bc-framework'
	git_clone 'bc-workflow'

	git_clone 'bc-attendance'
	git_clone 'bc-cert'
	git_clone 'bc-pmc'

	git_clone 'bc-business'
	git_clone 'bc-business-workflow'

	git_clone 'bc-business-arrange'
	git_clone 'bc-business-cartax'
	git_clone 'bc-business-cert'
	git_clone 'bc-business-hcjtz'
	git_clone 'bc-business-workplan'
fi

# 对后台源码执行 git pull origin master: -u
if [[ $1 == -*u* ]]; then
	git_pull 'bc-framework'
	git_pull 'bc-workflow'

	git_pull 'bc-attendance'
	git_pull 'bc-cert'
	git_pull 'bc-pmc'

	git_pull 'bc-business'
	git_pull 'bc-business-workflow'

	git_pull 'bc-business-arrange'
	git_pull 'bc-business-cartax'
	git_pull 'bc-business-cert'
	git_pull 'bc-business-hcjtz'
	git_pull 'bc-business-workplan'

	cd 'bc-system/src/main/webapp'
	git_pull 'ui-libs'
	git_pull 'ui-libs-demo'
	git_pull 'bc'
	git_pull 'bc-workflow'
	git_pull 'bc-test'
	git_pull 'bc-business'
	git_pull 'bc-business-workflow'
	cd $root_dir
fi

# 对后台源码执行 mvn install: -i 选项
if [[ $1 == -*i* ]]; then
	mvn_install 'bc-framework'
	mvn_install 'bc-workflow'

	mvn_install 'bc-attendance'
	mvn_install 'bc-cert'
	mvn_install 'bc-pmc'

	mvn_install 'bc-business'
	mvn_install 'bc-business-workflow'

	mvn_install 'bc-business-arrange'
	mvn_install 'bc-business-cartax'
	mvn_install 'bc-business-cert'
	mvn_install 'bc-business-hcjtz'
	mvn_install 'bc-business-workplan'
fi

# 启动系统: -r 选项
cd 'bc-system'
if [[ $clean == 'true' ]]; then
	mvn clean
fi
if [[ $1 == -*r* ]]; then
	mvn jetty:run -Ppostgresql
fi
cd ..

exit 0
