# md5check
批量并发检查文件md5(linux)

1.chmod +ux Path_to_md5_check/md5_check.sh
2.cd workingDirectory
3.确保md5文件是以下结构：第一列 文件md5信息；第二列 文件位置（相对/绝对路径）；分隔符 tab
4.运行脚本
  Path_to_md5_check/md5_chech.sh md5_file.txt tmpfile_directory
5.脚本会在 tmpfile_directory路径创建临时文件用以设置并发
