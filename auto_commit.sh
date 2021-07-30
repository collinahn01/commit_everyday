#!/bin/bash

# https://github.com/collinahn01/commit_everyday.git
# 매일 랜덤한 시간에 한 번씩 파일 생성해서 푸시하는 스크립트

function Update_Time() {
    RAND_NUM_HOUR="$(($RANDOM% 24))"      #0~23
    RAND_NUM_MIN="$(($RANDOM% 60))"       #0~59
    echo "next commit >> ${RAND_NUM_HOUR}:${RAND_NUM_MIN}"
}

RAND_NUM_HOUR=0
RAND_NUM_MIN=0

Update_Time

while [ true ]
do

    CURRENT_HOUR=$(date +"%H")
    CURRENT_MIN=$(date +"%M")

    if [ ${CURRENT_HOUR} -ge ${RAND_NUM_HOUR} ] && [  ${CURRENT_MIN} -ge ${RAND_NUM_MIN}  ] ; then
    # if [ true ] ; then

        echo "${CURRENT_HOUR}:${CURRENT_MIN} commit start"

        TARGET_MSG="created $(date +"%b %d %Y %H:%M:%S") by commit_everyday.sh"
        TARGET_FILE="files/$(date +"%Y-%m-%d_%H:%M:%S").sh"
        
        touch ${TARGET_FILE}
        echo "#!/bin/bash" >> ${TARGET_FILE}
        echo "" >> ${TARGET_FILE}
        echo "# created ${CURRENT_HOUR}:${CURRENT_MIN}" >> ${TARGET_FILE} 

        git add ${TARGET_FILE}
        sleep 5s

        git commit -m "automated commit, ${TARGET_FILE}"
        sleep 5s

        git push

        CURRENT_DATE=$(date +"%Y%m%d")    #20210728
        NEXT_DATE=`expr ${CURRENT_DATE} "+" 1`

        CURRENT_DATE=$(date +"%Y%m%d %H:%M:%S") #20210728 23:58:00
        CURRENT_DATE_STD=`date -d "${CURRENT_DATE}" "+%s"` 

        NEXT_DATE_STD=`date -d "${NEXT_DATE} 00:00:00" "+%s"`

        DIFF_SEC=`expr ${NEXT_DATE_STD} "-" ${CURRENT_DATE_STD}`

        echo "sleeping $DIFF_SEC"
        sleep ${DIFF_SEC}s

        Update_Time
    fi

    sleep 1m

done
