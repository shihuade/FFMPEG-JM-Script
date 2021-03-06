#!/bin/bash


runUsage()
{
    echo "**********************************************************"
    echo "**********************************************************"
    echo "  Usage:                                                  "
    echo "     $0  \${MP4FilesDir} \${Option}                       "
    echo "         \${Option}:  all parse all mp4 files             "
    echo "         \${Option}:  pattern=\${Option}                  "
    echo "          example:                                        "
    echo "             douyin parse all douyin's *douyin*.mp4 files "
    echo "             muse   parse all muse's   *muse*.mp4 files   "
    echo "             'douyin  muse'                               "
    echo "                   parse all douyin's/muse's  mp4 files   "
    echo ""
    echo "         \${Option}:  one \$mp4 parse given mp4 file      "
    echo "**********************************************************"
    echo "**********************************************************"
}

runInitForFrame()
{
    #Frame num
    let " FrameNumAll = 0"
    let " FrameNumI   = 0"
    let " FrameNumP   = 0"
    let " FrameNumB   = 0"

    let "FrameNumRatioI = 0"
    let "FrameNumRatioP = 0"
    let "FrameNumRatioB = 0"

    #frame size statistic
    let " FrameSizeAll = 0"
    let " FrameSizeI   = 0"
    let " FrameSizeP   = 0"
    let " FrameSizeB   = 0"

    let " FrameSizeRatioI = 0"
    let " FrameSizeRatioP = 0"
    let " FrameSizeRatioB = 0"

    let " FrameSizeAvg  = 0"
    let " FrameSizeAvgI = 0"
    let " FrameSizeAvgP = 0"
    let " FrameSizeAvgB = 0"

    let " FrameSizeMaxI = 0"
    let " FrameSizeMaxP = 0"
    let " FrameSizeMaxB = 0"

    let " FrameSizeMinI = 0"
    let " FrameSizeMinP = 0"
    let " FrameSizeMinB = 0"

    #compress ratio
    let "FrameCompressedRatio  = 0"
    let "FrameCompressedRatioI = 0"
    let "FrameCompressedRatioP = 0"
    let "FrameCompressedRatioB = 0"

    #bit rate statistic
    let " BitRateAvg       = 0"
    let " BitRateAvgFPS30  = 0"

    let " BitRateIn1S = 0"
    let " BitRateIn2S = 0"
    let " BitRateIn3S = 0"
    let " BitRateIn4S = 0"
    let " BitRateIn5S = 0"
    let " BitRateIn6S = 0"

    #PSNR statistic
    let " FramePSNRAvg = 0"
    let " FramePSNRI   = 0"
    let " FramePSNRP   = 0"
    let " FramePSNRB   = 0"

    let " FramePSNRMaxI =0"
    let " FramePSNRMaxP =0"
    let " FramePSNRMaxB =0"

    let " FramePSNRMinI =0"
    let " FramePSNRMinP =0"
    let " FramePSNRMinB =0"


    #frame QP statistic
    let " FrameQPAvg = 0"
    let " FrameQPI   = 0"
    let " FrameQPP   = 0"
    let " FrameQPB   = 0"

    let " FrameQPMaxI =0"
    let " FrameQPMaxP =0"
    let " FrameQPMaxB =0"

    let " FrameQPMinI =0"
    let " FrameQPMinP =0"
    let " FrameQPMinB =0"
}

runInitHeadLineFrame()
{
    #headline for output statistic table
    FrameHeadline1_Num="FrmNum,,,,FrmNumRatio(%),,,"
    FrameHeadline2_Num="All,I,P,B, I, P, B,"

    FrameHeadline1_AllSize="FrmSize(Byte),,,, FrmSizeRatio(%),,,"
    FrameHeadline2_AllSize="All, I, P, B, I, P, B,"

    FrameHeadline1_Size="AvgSize(Byte),,,,MaxSize(Byte),,,MinSize(Byte),,,"
    FrameHeadline2_Size="Avg, I, P, B, I, P, B, I, P, B,"

    FrameHeadline1_CR="Compressed Ratio, , , ,"
    FrameHeadline2_CR="Avg, I, P, B ,"

    FrameHeadline1_BitRate="Bit Rate(kbps), , , , , , , ,"
    FrameHeadline2_BitRate="avg, avgfps30, 1s, 2s, 3s, 4s, 5s, 6s,"
    FrameHeadline1_PSNR="Frame PSNR(db), , , , , , , , , ,"
    FrameHeadline2_PSNR="Avg, I, P, B, MaxI, MaxP, MaxB, MinI, MinP, MinB,"
    FrameHeadline1_QP="Frame QP, , , , , , , , , ,"
    FrameHeadline2_QP="Avg, I, P, B, MaxI, MaxP, MaxB, MinI, MinP, MinB"

    FrameHeadline1="${FrameHeadline1_Num} ${FrameHeadline1_AllSize}  ${FrameHeadline1_CR} ${FrameHeadline1_Size}${FrameHeadline1_BitRate} ${FrameHeadline1_PSNR} ${FrameHeadline1_QP}"
    FrameHeadline2="${FrameHeadline2_Num} ${FrameHeadline2_AllSize}  ${FrameHeadline2_CR} ${FrameHeadline2_Size} ${FrameHeadline2_BitRate} ${FrameHeadline2_PSNR} ${FrameHeadline2_QP}"
}

runInitForSequence()
{
    #data extract from xxx.mp4_stream.csv file
    #for sequences level statistic
    Profile=""
    Level=""
    EnctrMode=""
    Resolution=""
    let "FrameRate= 0"
    Duration=""
    let "PSNR= 0"

    let "SFrameNumAll = 0"
    let "SFrameNumI = 0"
    let "SFrameNumP = 0"
    let "SFrameNumB= 0"

    let "SFrameNumRatioI= 0"
    let "SFrameNumRatioP= 0"
    let "SFrameNumRatioB= 0"

    let "FrameSizeAverage= 0"
    let "FrameSizeAverageI= 0"
    let "FrameSizeAverageP= 0"
    let "FrameSizeAverageB= 0"

    let "SCompressedRatio= 0"
    let "SCompressedRatioI= 0"
    let "SCompressedRatioP= 0"
    let "SCompressedRatioB= 0"

    let "QPAvg= 0"
    let "QPMin= 0"
    let "QPMax= 0"

    let "PicW = 540"
    let "PicH = 960"
    let "FramePixelSize = $PicW * $PicH"
}

runInitHeadLineSequence()
{
    #headline for output statistic table
    SequenceHeadLine1_Basic="Basic info, , , , , , ,"
    SequenceHeadLine2_Basic="profile, level, EncM, Resol, FrRate, Dura,PSNR,"
    SequenceHeadLine1_Frame="FrameNum,,,,  FrameRatio(%),,,FrameSize,,,,CompressedRatio(%),,,, QP, , ,"
    SequenceHeadLine2_Frame="All, I, P, B, I,  P,  B,  Avg, I, P, B,  Avg,  I,  P,  B,  Avg, Max, Min,"

    SequenceHeadLine1="${SequenceHeadLine1_Basic} ${SequenceHeadLine1_Frame}"
    SequenceHeadLine2="${SequenceHeadLine2_Basic} ${SequenceHeadLine2_Frame}"
}

runInitForStatisticFile()
{
    DetailStaticFile="StaticInfoDetail.csv"
    SequenceStaticFile="StaticInfoForAllSequences.csv"
    FrameStatiFile="StaticInfoForAllFrames.csv"

    #frame index file generated by StreamEye
    # xxx.mp4_index.csv
    FrameIndexFile=""
    #stream report file generated by StreanEye
    #xxx.mp4_stream.csv
    StreamStaticFile=""

    #init output table with headline
    echo "MP4, , ${SequenceHeadLine1} ${FrameHeadline1}"  >${DetailStaticFile}
    echo "MP4, Filesize(MB), ${SequenceHeadLine2} ${FrameHeadline2}" >>${DetailStaticFile}

    echo "MP4, , ${SequenceHeadLine1}"  >${SequenceStaticFile}
    echo "MP4, Filesize(MB), ${SequenceHeadLine2}" >>${SequenceStaticFile}

    echo "MP4, , ${FrameHeadline1}"  >${FrameStatiFile}
    echo "MP4, Filesize(MB), ${FrameHeadline2}" >>${FrameStatiFile}

    declare -a aParsedMP4FileList
    declare -a aSkipMP4FileList

    let "ParsedMum = 0"
    let "SkipNum = 0"

    #option parametes
    FilePattern=""
    declare -a aPatternList
}

runInit()
{
    runInitForFrame
    runInitForSequence

    runInitHeadLineFrame
    runInitHeadLineSequence

    runInitForStatisticFile
}

runCheck()
{
    echo "**************************************************"
    echo "**************************************************"
    echo " checking input parameters..."
    echo " MP4FilesDir is ${MP4FilesDir}"
    echo " Option is ${Option}"
    echo " InputMP4File is ${InputMP4File}"
    echo "**************************************************"
    echo "**************************************************"

    if [ ! -d ${MP4FilesDir} ]
    then
        echo "MP4FilesDir does not exist, please double check!"
        exit 1
    fi

    if [ ! -z "${Option}" ]
    then
        if [[ "${Option}" = "one" ]]
        then
            [ -z "${InputMP4File}" ] && echo "no mp4 file parameters" && exit 1
            [ ! -e "${MP4FilesDir}/${InputMP4File}" ] && echo "mp4 file  does not exist!" && exit 1
        else
            aPatternList=(${Option})
            for vpattern in ${aPatternList[@]}
            do
                FilePattern="${vpattern}"

                Command="ls -l ${MP4FilesDir}/*${FilePattern}*.mp4"
                echo "check command is ${Command}"
                ${Command}
                [ ! $? -eq 0 ] && echo "no mp4 files match pattern *{$FilePattern}*.mp4" && exit 1
            done
        fi
    fi
}

runUpdateFrameInfo_I()
{
    if [ ${FrameNumI} -eq 0 ]
    then
        let "FrameSizeMaxI = ${FrameSize}"
        let "FrameSizeMinI = ${FrameSize}"

        let "FramePSNRMaxI = ${FramePSNR}"
        let "FramePSNRMinI = ${FramePSNR}"

        let "FrameQPMaxI   = ${FrameQP}"
        let "FrameQPMinI   = ${FrameQP}"

    fi

    let " FrameSizeI += ${FrameSize}"
    let " FrameQPI   += ${FrameQP}"
    FramePSNRI=`echo "scale=2; ${FramePSNRI} + ${FramePSNR}" | bc`

    [ ${FrameSizeMaxI} -lt ${FrameSize} ] && let " FrameSizeMaxI = ${FrameSize}"
    [ ${FrameSizeMinI} -gt ${FrameSize} ] && let " FrameSizeMinI = ${FrameSize}"

    [ ${FramePSNRMaxI} -lt ${FramePSNR} ] && FramePSNRMaxI=`echo "scale=0;${FramePSNR}" | bc`
    [ ${FramePSNRMinI} -gt ${FramePSNR} ] && FramePSNRMinI=`echo "scale=0;${FramePSNR}" | bc`

    [ ${FrameQPMaxI}   -lt ${FrameQP} ]   && let " FrameQPMaxI   = ${FrameQP}"
    [ ${FrameQPMinI}   -gt ${FrameQP} ]   && let " FrameQPMinI   = ${FrameQP}"

    let " FrameNumI +=1"
}

runUpdateFrameInfo_P()
{
    if [ ${FrameNumP} -eq 0 ]
    then
        let "FrameSizeMaxP = ${FrameSize}"
        let "FrameSizeMinP = ${FrameSize}"

        let "FramePSNRMaxP = ${FramePSNR}"
        let "FramePSNRMinP = ${FramePSNR}"

        let "FrameQPMaxP   = ${FrameQP}"
        let "FrameQPMinP   = ${FrameQP}"
    fi

    let " FrameSizeP += ${FrameSize}"
    let " FrameQPP   += ${FrameQP}"
    FramePSNRP=`echo "scale=2; ${FramePSNRP} + ${FramePSNR}" | bc`

    [ ${FrameSizeMaxP} -lt ${FrameSize} ] && let " FrameSizeMaxP = ${FrameSize}"
    [ ${FrameSizeMinP} -gt ${FrameSize} ] && let " FrameSizeMinP = ${FrameSize}"

    [ ${FramePSNRMaxP} -lt ${FramePSNR} ] && FramePSNRMaxP=`echo "scale=2;${FramePSNR}" | bc`
    [ ${FramePSNRMinP} -gt ${FramePSNR} ] && FramePSNRMinP=`echo "scale=2;${FramePSNR}" | bc`

    [ ${FrameQPMaxP}   -lt ${FrameQP} ]   && let " FrameQPMaxP   = ${FrameQP}"
    [ ${FrameQPMinP}   -gt ${FrameQP} ]   && let " FrameQPMinP   = ${FrameQP}"

    let " FrameNumP +=1"
}

runUpdateFrameInfo_B()
{
    if [ ${FrameNumB} -eq 0 ]
    then
        let "FrameSizeMaxB = ${FrameSize}"
        let "FrameSizeMinB = ${FrameSize}"

        let "FramePSNRMaxB = ${FramePSNR}"
        let "FramePSNRMinB = ${FramePSNR}"

        let "FrameQPMaxB   = ${FrameQP}"
        let "FrameQPMinB   = ${FrameQP}"
    fi

    let " FrameSizeB += ${FrameSize}"
    let " FrameQPB   += ${FrameQP}"
    FramePSNRB=`echo "scale=2; ${FramePSNRB} + ${FramePSNR}" | bc`

    [ ${FrameSizeMaxB} -lt ${FrameSize} ] && let " FrameSizeMaxB = ${FrameSize}"
    [ ${FrameSizeMinB} -gt ${FrameSize} ] && let " FrameSizeMinB = ${FrameSize}"

    [ ${FramePSNRMaxB} -lt ${FramePSNR} ] && FramePSNRMaxB=`echo "scale=2;${FramePSNR}" | bc`
    [ ${FramePSNRMinB} -gt ${FramePSNR} ] && FramePSNRMinB=`echo "scale=2;${FramePSNR}" | bc`

    [ ${FrameQPMaxB}   -lt ${FrameQP} ]   && let " FrameQPMaxB   = ${FrameQP}"
    [ ${FrameQPMinB}   -gt ${FrameQP} ]   && let " FrameQPMinB   = ${FrameQP}"

    let " FrameNumB +=1"
}

runUpdateBitRate()
{
    NewSecondFlag="true"
    CurrentSecondNum=`echo ${FramePts} | awk 'BEGIN {FS=":"} {print $3}'`
    [[ "$PreviousSecondNum" =~ "$CurrentSecondNum"  ]] && NewSecondFlag="false"

    PreviousSecondNum="$CurrentSecondNum"
    if [[ "$NewSecondFlag" =~ "true" ]]
    then
        [[ "${FramePts}" =~ "01" ]] && BitRateIn1S=`echo "scale=2;${FrameSizeAll} * 8 / 1 /1024"|bc`
        [[ "${FramePts}" =~ "02" ]] && BitRateIn2S=`echo "scale=2;${FrameSizeAll} * 8 / 2 /1024"|bc`
        [[ "${FramePts}" =~ "03" ]] && BitRateIn3S=`echo "scale=2;${FrameSizeAll} * 8 / 3 /1024"|bc`
        [[ "${FramePts}" =~ "04" ]] && BitRateIn4S=`echo "scale=2;${FrameSizeAll} * 8 / 4 /1024"|bc`
        [[ "${FramePts}" =~ "05" ]] && BitRateIn5S=`echo "scale=2;${FrameSizeAll} * 8 / 5 /1024"|bc`
        [[ "${FramePts}" =~ "06" ]] && BitRateIn6S=`echo "scale=2;${FrameSizeAll} * 8 / 6 /1024"|bc`
    fi
}

runParseFrameStaticInfo()
{

    if [ ! -e ${FrameIndexFile} ]
    then
        echo "  ****************************************************"
        echo "      ${FrameIndexFile} does not exist             "
        echo "      so skip to parse frame static info for ${mp4}"
        echo "  ****************************************************"
        let "SkipFlag = 1"
        return 0
    fi

    PreviousSecondNum="00"
    while read line
    do
        #parse frame level statistic info
        FrameType=`echo $line | awk 'BEGIN {FS=";"} {print $5}'`
        FrameSize=`echo $line | awk 'BEGIN {FS=";"} {print $7}'`
        FrameQP=`echo $line   | awk 'BEGIN {FS=";"} {print $8}'`
        FramePSNR=`echo $line | awk 'BEGIN {FS=";"} {print $13}'`
        #muliplt of 100
        FramePSNR=`echo "scale=0;${FramePSNR}*100" | bc`
        FramePSNR=`echo ${FramePSNR} | awk 'BEGIN {FS="."} {print $1}'`

        FrameQP=`echo "scale=2;${FrameQP}*100" | bc`
        FrameQP=`echo ${FrameQP} | awk 'BEGIN {FS="."} {print $1}'`

        #frame play time stamp
        FramePts=`echo $line | awk 'BEGIN {FS=";"}  {print $6}'`
        runUpdateBitRate

        #update statistic info based on frame type
        [[ "${FrameType}" =~ "I" ]] && runUpdateFrameInfo_I
        [[ "${FrameType}" =~ "P" ]] && runUpdateFrameInfo_P
        [[ "${FrameType}" =~ "B" ]] && runUpdateFrameInfo_B

        let " FrameNumAll  = ${FrameNumI}  + ${FrameNumP}  + ${FrameNumB}"
        let " FrameSizeAll = ${FrameSizeI} + ${FrameSizeP} + ${FrameSizeB}"
    done <${FrameIndexFile}
}

runUpdateFrameStatisticInfo()
{
    #frame num
    FrameNumRatioI=`echo "scale=2; 100 * ${FrameNumI}/${FrameNumAll}"|bc`
    FrameNumRatioP=`echo "scale=2; 100 * ${FrameNumP}/${FrameNumAll}"|bc`
    FrameNumRatioB=`echo "scale=2; 100 * ${FrameNumB}/${FrameNumAll}"|bc`

    #frame size
    FrameSizeRatioI=`echo "scale=2; 100 * ${FrameSizeI}/${FrameSizeAll}"|bc`
    FrameSizeRatioP=`echo "scale=2; 100 * ${FrameSizeP}/${FrameSizeAll}"|bc`
    FrameSizeRatioB=`echo "scale=2; 100 * ${FrameSizeB}/${FrameSizeAll}"|bc`

    FrameSizeAvg=`echo  "scale=2; ${FrameSizeAll}/${FrameNumAll}"|bc`
    FrameSizeAvgI=`echo "scale=2; ${FrameSizeI}/${FrameNumI}"    |bc`
    FrameSizeAvgP=`echo "scale=2; ${FrameSizeP}/${FrameNumP}"    |bc`
    [ ${FrameNumB} -gt 0 ] && FrameSizeAvgB=`echo "scale=2; ${FrameSizeB}/${FrameNumB}" |bc`

    #bit rate
    DurationInS=`echo ${Duration} | awk 'BEGIN {FS=":"} {print $3}'`
    DurationInMilionS=`echo ${Duration} | awk 'BEGIN {FS=":"} {print $4}'`
    DurationInMilionS=`echo "scale=2; ${DurationInMilionS}/1000"      |bc`
    DurationInS=`echo "scale=2; ${DurationInS} + ${DurationInMilionS}"|bc`
    DurationBasedFPS30=`echo "scale=2; ${FrameNumAll}/30"    |bc`

    BitRateAvg=`echo "scale=2; ${FrameSizeAll} * 8 / ${DurationInS} / 1024" |bc`
    BitRateAvgFPS30=`echo "scale=2; ${FrameSizeAll} * 8 /${DurationBasedFPS30} / 1024" |bc`

    #frame compress ratio
    #let "FramePixelSize = $PicW * $PicH"
    FrameCompressedRatio=`echo   "scale=2; ${FramePixelSize}/${FrameSizeAvg}" |bc`
    FrameCompressedRatioI=`echo  "scale=2; ${FramePixelSize}/${FrameSizeAvgI}" |bc`
    FrameCompressedRatioP=`echo  "scale=2; ${FramePixelSize}/${FrameSizeAvgP}"|bc`
    AvgBInt=`echo $FrameSizeAvgB | awk 'BEGIN {FS="."} {print $1}'`
    [ ${AvgBInt} -gt 0 ] && FrameCompressedRatioB=`echo "scale=2; ${FramePixelSize}/${FrameSizeAvgB}"|bc`

    #PSNR statistic
    FramePSNRAvg=`echo "scale=2; ${FramePSNRI} + ${FramePSNRP} + ${FramePSNRB} "|bc`
    FramePSNRAvg=`echo "scale=2; ${FramePSNRAvg} / ${FrameNumAll} /100" |bc`
    FramePSNRI=`echo   "scale=2; ${FramePSNRI}   / ${FrameNumI}   /100" |bc`
    FramePSNRP=`echo   "scale=2; ${FramePSNRP}   / ${FrameNumP}   /100" |bc`
    [ ${FrameNumB} -gt 0 ] && FramePSNRB=`echo "scale=2; ${FramePSNRB} / ${FrameNumB} / 100" |bc`


    FramePSNRMaxI=`echo   "scale=2; ${FramePSNRMaxI} / 100" |bc`
    FramePSNRMaxP=`echo   "scale=2; ${FramePSNRMaxP} / 100" |bc`
    FramePSNRMaxB=`echo   "scale=2; ${FramePSNRMaxB} / 100" |bc`

    FramePSNRMinI=`echo   "scale=2; ${FramePSNRMinI} / 100" |bc`
    FramePSNRMinP=`echo   "scale=2; ${FramePSNRMinP} / 100" |bc`
    FramePSNRMinB=`echo   "scale=2; ${FramePSNRMinB} / 100" |bc`

    #frame QP statistic
    FrameQPAvg=`echo  "scale=2; ${FrameQPI} + ${FrameQPP} + ${FrameQPB} "|bc`
    FrameQPAvg=`echo  "scale=2; ${FrameQPAvg} / ${FrameNumAll} / 100 "|bc`
    FrameQPI=`echo    "scale=2; ${FrameQPI}   / ${FrameNumI}   / 100" |bc`
    FrameQPP=`echo    "scale=2; ${FrameQPP}   / ${FrameNumP}   / 100" |bc`
    [ ${FrameNumB} -gt 0 ] && FrameQPB=`echo "scale=2; ${FrameQPB} / ${FrameNumB} / 100" |bc`

    FrameQPMaxI=`echo    "scale=2; ${FrameQPMaxI} / 100" |bc`
    FrameQPMaxP=`echo    "scale=2; ${FrameQPMaxP} / 100" |bc`
    FrameQPMaxB=`echo    "scale=2; ${FrameQPMaxB} / 100" |bc`

    FrameQPMinI=`echo    "scale=2; ${FrameQPMinI} / 100" |bc`
    FrameQPMinP=`echo    "scale=2; ${FrameQPMinP} / 100" |bc`
    FrameQPMinB=`echo    "scale=2; ${FrameQPMinB} / 100" |bc`
}

runParseSequenceStaticInfo()
{
    if [ ! -e ${StreamStaticFile} ]
    then
        echo "  ****************************************************"
        echo "    ${StreamStaticFile} does not exist      "
        echo "    so skip to parse  stream info for ${mp4}"
        echo "  ****************************************************"
        let "SkipFlag = 1"
        return 0
    fi

    while read line
    do
        [[ "${line}" =~ "profile" ]]     && Profile=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "level" ]]       && Level=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "frame rate" ]]  && FrameRate=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "coding mode" ]] && EnctrMode=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "resolution" ]]  && Resolution=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "duration" ]]    && Duration=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "epsnr" ]]       && PSNR=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`

        [[ "${line}" =~ "qp min" ]]       && QPMin=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "qp avg" ]]       && QPAvg=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        [[ "${line}" =~ "qp max" ]]       && QPMax=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`

        [[ "${line}" =~ "count" ]] && DataCat="FrameCount"
        [[ "${line}" =~ "size (byte)" ]] && DataCat="FrameSize"

        if [[ "${DataCat}" = "FrameCount" ]]
        then
            [[ "$line" =~ "count" ]] && SFrameNumAll=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "I;" ]]    && SFrameNumI=`echo $line   | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "P;" ]]    && SFrameNumP=`echo $line   | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "B;" ]]    && SFrameNumB=`echo $line   | awk 'BEGIN {FS=";"} {print $2}'`

        elif [[ "${DataCat}" = "FrameSize" ]]
        then
            [[ "$line" =~ "encode" ]] && FrameSizeAverage=`echo $line  | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "I;" ]]     && FrameSizeAverageI=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "P;" ]]     && FrameSizeAverageP=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
            [[ "$line" =~ "B;" ]]     && FrameSizeAverageB=`echo $line | awk 'BEGIN {FS=";"} {print $2}'`
        fi
    done <${StreamStaticFile}

    PicW=`echo ${Resolution} | awk 'BEGIN {FS="x"} {print $1}'`
    PicH=`echo ${Resolution} | awk 'BEGIN {FS="x"} {print $2}'`
    let "FramePixelSize = $PicW * $PicH * 3 / 2"

    SFrameNumRatioI=`echo ${SFrameNumI} | awk 'BEGIN {FS="("} {print $2}'`
    SFrameNumRatioP=`echo ${SFrameNumP} | awk 'BEGIN {FS="("} {print $2}'`
    SFrameNumRatioB=`echo ${SFrameNumB} | awk 'BEGIN {FS="("} {print $2}'`
    SFrameNumRatioI=`echo ${SFrameNumRatioI} | awk 'BEGIN {FS="%"} {print $1}'`
    SFrameNumRatioP=`echo ${SFrameNumRatioP} | awk 'BEGIN {FS="%"} {print $1}'`
    SFrameNumRatioB=`echo ${SFrameNumRatioB} | awk 'BEGIN {FS="%"} {print $1}'`
    [ -z "$SFrameNumRatioB" ] && let "SFrameNumRatioB = 0"

    SFrameNumI=`echo ${SFrameNumI} | awk 'BEGIN {FS="("} {print $1}'`
    SFrameNumP=`echo ${SFrameNumP} | awk 'BEGIN {FS="("} {print $1}'`
    SFrameNumB=`echo ${SFrameNumB} | awk 'BEGIN {FS="("} {print $1}'`
    [ -z "$SFrameNumB" ] && let "SFrameNumB = 0"

    SCompressedRatio=`echo $FrameSizeAverage   | awk 'BEGIN {FS="/"} {print $2}'`
    SCompressedRatioI=`echo $FrameSizeAverageI | awk 'BEGIN {FS="/"} {print $2}'`
    SCompressedRatioP=`echo $FrameSizeAverageP | awk 'BEGIN {FS="/"} {print $2}'`
    SCompressedRatioB=`echo $FrameSizeAverageB | awk 'BEGIN {FS="/"} {print $2}'`
    [ -z "$SCompressedRatioB" ] && let "SCompressedRatioB = 0"

    FrameSizeAverage=`echo $FrameSizeAverage   | awk 'BEGIN {FS="/"} {print $1}'`
    FrameSizeAverageI=`echo $FrameSizeAverageI | awk 'BEGIN {FS="/"} {print $1}'`
    FrameSizeAverageP=`echo $FrameSizeAverageP | awk 'BEGIN {FS="/"} {print $1}'`
    FrameSizeAverageB=`echo $FrameSizeAverageB | awk 'BEGIN {FS="/"} {print $1}'`
    [ -z "$FrameSizeAverageB" ] && let "FrameSizeAverageB = 0"
}

runGenerateFrameStaticInfo()
{
    FrameStaticInfoNum="${FrameNumAll}, ${FrameNumI}, ${FrameNumP}, ${FrameNumB}, ${FrameNumRatioI}, ${FrameNumRatioP}, ${FrameNumRatioB}"
    FrameStaticInfoSize01="${FrameSizeAll}, ${FrameSizeI}, ${FrameSizeP}, ${FrameSizeB}, ${FrameSizeRatioI}, ${FrameSizeRatioP}, ${FrameSizeRatioB}"
    FrameStaticInfoSize02="${FrameSizeAvg}, ${FrameSizeAvgI}, ${FrameSizeAvgP}, ${FrameSizeAvgB}, ${FrameSizeMaxI}, ${FrameSizeMaxP}, ${FrameSizeMaxB}, ${FrameSizeMinI}, ${FrameSizeMinP}, ${FrameSizeMinB}"
    FrameStaticInfoCompreR="${FrameCompressedRatio}, ${FrameCompressedRatioI}, ${FrameCompressedRatioP}, ${FrameCompressedRatioB}"
    FrameStaticInfoBitRate="${BitRateAvg}, ${BitRateAvgFPS30}, ${BitRateIn1S}, ${BitRateIn2S}, ${BitRateIn3S}, ${BitRateIn4S}, ${BitRateIn5S}, ${BitRateIn6S}"
    FrameStaticInfoPSNR="${FramePSNRAvg}, ${FramePSNRI}, ${FramePSNRP}, ${FramePSNRB}, ${FramePSNRMaxI}, ${FramePSNRMaxP}, ${FramePSNRMaxB}, ${FramePSNRMinI}, ${FramePSNRMinP}, ${FramePSNRMinB}"
    FrameStaticInfoQP="${FrameQPAvg}, ${FrameQPI}, ${FrameQPP}, ${FrameQPB}, ${FrameQPMaxI}, ${FrameQPMaxP}, ${FrameQPMaxB}, ${FrameQPMinI}, ${FrameQPMinP}, ${FrameQPMinB}"

    FrameStaticInfo="${FrameStaticInfoNum}, ${FrameStaticInfoSize01}, ${FrameStaticInfoCompreR}, ${FrameStaticInfoSize02},${FrameStaticInfoBitRate}, ${FrameStaticInfoPSNR},${FrameStaticInfoQP}"
}

runGenerateSequenceStaticInfo()
{
    SequenceStaticInfoBasic="${Profile}, ${Level},${EnctrMode}, ${Resolution},${FrameRate}, ${Duration},${PSNR}"
    SequenceStaticInfo_Frame="${SFrameNumAll}, ${SFrameNumI},${SFrameNumP}, ${SFrameNumB},${SFrameNumRatioI}, ${SFrameNumRatioP},${SFrameNumRatioB}, ${FrameSizeAverage},${FrameSizeAverageI}, ${FrameSizeAverageP},${FrameSizeAverageB}, ${SCompressedRatio},${SCompressedRatioI}, ${SCompressedRatioP},${SCompressedRatioB}, ${QPAvg},${QPMax}, ${QPMin}"

    SequenceStaticInfo="${SequenceStaticInfoBasic}, ${SequenceStaticInfo_Frame}"
}

runOutputStaticInfoForOneSequence()
{
    MP4FileName=`echo "$mp4" | awk 'BEGIN {FS="/"} {print $NF}'`
    #init output table with headline
    echo "****************************************************"
    echo " Output all statistic info"
    echo "****************************************************"
    echo " MP4FileName is  $MP4FileName"
    echo "${SequenceStaticInfo}, ${FrameStaticInfo}"
    echo "${SequenceStaticInfo}"
    echo "${FrameStaticInfo}"
    echo "****************************************************"


    echo "${MP4FileName}, ${FileSize}, ${SequenceStaticInfo}, ${FrameStaticInfo}" >>${DetailStaticFile}
    echo "${MP4FileName}, ${FileSize}, ${SequenceStaticInfo}" >>${SequenceStaticFile}
    echo "${MP4FileName}, ${FileSize}, ${FrameStaticInfo}" >>${FrameStatiFile}
}

runParseOneMP4File()
{
    if [ ! -e ${mp4} ]
    then
        echo "${mp4} file does not exist, please double check!"
        return 0
    fi


    FrameIndexFile=${mp4}_index.csv
    StreamStaticFile=${mp4}_stream.csv
    FileSize=`ls -l $mp4 | awk '{print $5}'`
    FileSize=`echo  "scale=2; ${FileSize} / 1024 / 1024 "|bc`

    echo "****************************************************"
    echo "  parsing mp4 file:   ${mp4}"
    echo "  frame index file:   ${FrameIndexFile}"
    echo "  stream static file: ${StreamStaticFile}"
    echo "  FileSize(MByte):    ${FileSize}"
    echo "****************************************************"

    let "SkipFlag = 0"
    runInitForFrame
    runInitForSequence

    runParseSequenceStaticInfo
    runParseFrameStaticInfo

    if [ ${SkipFlag} -eq 0 ]
    then
        echo "****************************************************"
        echo "****************************************************"
        echo " start to update data...."
        echo "****************************************************"
        echo "****************************************************"

        runUpdateFrameStatisticInfo

        runGenerateFrameStaticInfo
        runGenerateSequenceStaticInfo

        runOutputStaticInfoForOneSequence

        aParsedMP4FileList[${ParsedMum}]=${mp4}
        let "ParsedMum += 1"
    else
        aSkipMP4FileList[${SkipNum}]=${mp4}
        let "SkipNum += 1"
    fi
}


runParseStaticInfoForAllSequences()
{
    for vpattern in ${aPatternList[@]}
    do
        FilePattern=${vpattern}
        runParseStaticInfoForAllSequencesWithSinglePattern
    done
}


runParseStaticInfoForAllSequencesWithSinglePattern()
{
    for file in ${MP4FilesDir}/*${FilePattern}*.mp4
    do
        echo "file is ${file}"
        mp4="${file}"
        runParseOneMP4File
    done
}



runOutputSummary()
{
    echo "****************************************************"
    echo "****************************************************"
    echo "   Summary of current parse status"
    echo "****************************************************"
    echo "****************************************************"

    echo "   ParsedMum of mp4 file is: ${ParsedMum}"
    for((i=0; i<${ParsedMum}; i++))
    do
        echo "    $i: ${aParsedMP4FileList[$i]}"
    done
    echo "****************************************************"
    echo "****************************************************"

    echo "   SkipNum of mp4 file is: ${SkipNum}"
    for((i=0; i<${SkipNum}; i++))
    do
        echo "    $i: ${aSkipMP4FileList[$i]}"
    done
    echo "****************************************************"
    echo "****************************************************"
}


runMain()
{
    runInit
    runCheck

    if [[ "${Option}" = "one" ]]
    then
        mp4=${MP4FilesDir}/${InputMP4File}
        runParseOneMP4File
    else
        if [ ${#aPatternList[@]}  -eq 0 ]
        then
            runParseStaticInfoForAllSequencesWithSinglePattern
        else
            FilePattern=""
            runParseStaticInfoForAllSequences
        fi
    fi

    runOutputSummary
}

#**********************************************************
#**********************************************************
if [ $# -lt 1 ]
then
    runUsage
    exit 1
fi

MP4FilesDir=$1
Option=$2
InputMP4File=$3

runMain


