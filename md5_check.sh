tmp_file_Directory=$2
echo Info:making tmp file on $tmp_file_Directory
[ -e $tmp_file_Directory/fd5 ] || mkfifo $tmp_file_Directory/fd5
echo Info:making tmp file successfully!
exec 5<>~/data/fd5
rm -rf ~/data/fd5
for ((i=1;i<=10;i++))
do
	echo >&5
done
echo Info:Check the md5 of 10 files at a time
WorkDirectory=$(pwd)
Out_Name=Result_md5_Out
md5_path=$1
IFS=$'\n'
#echo 
echo Info:work directory is $WorkDirectory
echo 
echo ================================================================================
echo Info:md5file requirement: first column md5Result, Second column file position
echo Info:Out result: first column FileName, Second column md5Check Result
echo ================================================================================
echo
echo Info:Cheking md5_file existance
if [ -e $md5_path ]
then
	tmp_testing=$(cat ${md5_path} | head -1)
	echo Info:Testing md5file structure!
	tmp_md5=$(echo $tmp_testing | awk '{print $1}' )
	if [ ${#tmp_md5} -eq 32 ]
	then
		echo Info: md5_file checking Passed! Now checking md5
		for test in $(cat ${md5_path})
		do
		read -u5
		{
		sample=$(echo $test | awk '{print $2}' )
		echo Info:check $sample md5 Start!
		md5_supposed=$(echo $test | awk '{print $1}' )
		md5_Res=$(md5sum ${WorkDirectory}/${sample} | awk '{print $1}')
		if [ -e $sample ] 
		then
				if [ $md5_supposed == $md5_Res ]
				then
					echo -e "${sample}\tPassed" >> $Out_Name.txt
					status=Match
				echo -e "\e[32m $sample result is $status  \e[0m"
				else
					echo -e "${sample}\tDestroied" >> $Out_Name.txt
					status=NotMatch
				echo -e "\e[31m $sample result is $status \e[0m"
			fi
		else
			echo ERROR:$sample Not exist, Please check your file and md5 file!
		fi
		#echo  Info:$sample result is $status
		echo >&5
		}&
		done
	wait
	else
		echo ERROR:md5_file is not legal! Please check your md5 file !
	fi
else
	echo ERROR:$md5_path Not exist! Please check your input md5.txt file!
fi
exec 5<&-
exec 5>&-


