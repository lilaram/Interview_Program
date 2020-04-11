filepath=$1
retention_day=$2
search_pattern=$3

if [[ -z ${filepath} && -z ${retention_day} && -z  ${search_pattern} ]];
then
 echo "************please provide three value as arguments to script********************************"
exit 0;
fi


echo "file path-->" ${filepath}
echo "retention_day-->" ${retention_day}
echo "search path-->" ${search_pattern}

TodayDate=`date +%Y-%m-%d`

 cat ${filepath} | jq  .[].name | tr -d '"' > file1.txt
 cat ${filepath} | jq  .[].creationTimestamp | tr -d '"' | cut -d ":" -f 1 | rev | cut -c 4- | rev > file2.txt
 paste -d '\0' file1.txt  file2.txt > Mergefile



echo "Todays Date:" ${TodayDate}
TodayDate=`date -d ${TodayDate} +"%j"`
TodayDate=${TodayDate#?};

image_count=0

for data in `cat Mergefile`
do

        echo $data | grep ${search_pattern}
        if [ $? -eq 0 ]; then
         echo ${data}
         datef=` echo ${data} |rev|cut -c 1-10| rev `
         DATElastnum=`date -d ${datef} +"%j"`
         DAYSdif="$(($TodayDate-$DATElastnum))"
         if [[ ${DAYSdif} > ${retention_day} ]]; then

          image_count=$((image_count+1))
         fi
      fi
done

  echo "images older than the given retention_days (i.e. due for deletion) --->" ${image_count}
