#!/usr/bin/env bash

#### 转换 git 仓库子目录为独立仓库 ####
# $ ./git-subdir-to-repo.sh source-repo-dir sub-dir branch-name to-repo
#
#######################################

sourceRepoDir='/d/work/bc-business-workflow'
toDir='/d/work/convert'
ts=$(date '+%Y-%m-%d %H:%M:%S')

# $1 : sub-dir-name
# $2 : 模块名称
# $3 : 分支名称
function doOne() { 
	# 将项目名转为小写
	_name=${1,,}
	if [[ -d ${toDir}/${_name} ]]; then
		echo "'${toDir}/${_name}' exists, ignore convert."
	else
		_ts=$(date '+%Y-%m-%d %H:%M:%S')
		_subDir=$sourceRepoDir/$1
		echo "start '$1' at $_ts"

		echo "cp -R ${sourceRepoDir} ${toDir}/temp_${_name}"
		cp -R ${sourceRepoDir} ${toDir}/temp_${_name}

		cd ${toDir}/temp_${_name}
		echo "git filter-branch --prune-empty --subdirectory-filter $1 $3"
		git filter-branch --prune-empty --subdirectory-filter $1 $3

		git remote set-url origin git@bitbucket.org:bctaxi/$_name.git

		# Absolute path to this script, e.g. /home/user/bin/foo.sh
		_script=$(readlink -f "$0")
		# Absolute path this script is in, thus /home/user/bin
		_scriptDir=$(dirname "$_script")

		cp ${_scriptDir}/.gitignore ${toDir}/temp_${_name}/.gitignore
		echo -e "# [$2](https://bitbucket.org/bctaxi/$_name)\r\n\r\n\r\n## 迁移说明\r\n此 Git 仓库是从 [bc-business-workflow](https://bitbucket.org/bctaxi/bc-business-workflow) 仓库早期版本的子目录 $1 迁移过来的，开始于 4.4 版。  \r\n  \r\n迁移时间：${_ts}  \r\n  \r\n迁移命令：\`$ git filter-branch --prune-empty --subdirectory-filter $1 master\`" > ./README.md
		git add .
		git commit -m "init"
		git push origin master -f

		echo "clone to ${toDir}/${_name}"
		cd ${toDir}
		git clone ${toDir}/temp_${_name} ${toDir}/${_name}
		cd ${toDir}/${_name}
		git remote set-url origin git@bitbucket.org:bctaxi/$_name.git
		git status

		echo "'$1' finished from $_ts to $(date '+%Y-%m-%d %H:%M:%S')"
	fi
}

# 对各模块执行处理
doOne 'bc-business-common' '营运业务流程的公共信息配置' 'master'

echo "finished all from $ts to $(date '+%Y-%m-%d %H:%M:%S')"
exit 0